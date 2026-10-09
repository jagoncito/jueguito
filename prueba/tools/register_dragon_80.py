"""Registra los atlas nuevos sin editar sus PNG (Pillow solo los lee).

Las celdas conservan el orden de las fuentes. La altura se mide sobre los
colores del cuerpo, excluyendo metal y madera; el ancla permanece en el suelo.
Las manos de poses con herramienta integrada son referencias, no un montaje.
Ejecutar desde cualquier carpeta: python prueba/tools/register_dragon_80.py
"""
import hashlib
import json
import shutil
from pathlib import Path

import numpy as np
from PIL import Image
from scipy.ndimage import find_objects, label

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'assets/personajes/dragon-avatar'
TARGET = ROOT / 'prueba/assets/personajes/dragon-avatar'
DIRS = ['S', 'SW', 'W', 'NW', 'N', 'NE', 'E', 'SE']
GRIDS = {
    'dragon-reposo.png': (4, 2),
    'dragon-sin-equipo.png': (4, 2),
    'dragon-herboristeria.png': (4, 4),
    'dragon-transiciones.png': (4, 4),
    'dragon-trabajo.png': (4, 4),
    'dragon-tala.png': (4, 4),
    'dragon-marcha-frontal.png': (4, 4),
    'dragon-marcha-trasera.png': (4, 4),
    'dragon-marcha-apoyos.png': (2, 2),
    'dragon-marcha-opuesta.png': (4, 2),
}
BOXES = {}
# Extremos visibles revisados en las fuentes de impacto; no contactos ficticios
# colocados en el recurso. Se ajustan al píxel de metal más próximo (máx. 12 px).
CONTACT_REFERENCES = {
    'golpe': [(175,876),(410,872),(695,844),(1060,642),
              (175,906),(548,912),(881,1103),(1169,1142)],
    'golpe-talar': [(166,881),(414,872),(657,809),(990,672),
                    (175,909),(522,932),(899,1080),(1193,1133)],
}


def box_of(mask, offset=(0, 0)):
    ys, xs = np.nonzero(mask)
    assert len(xs), 'Celda sin dibujo'
    return [int(xs.min()) + offset[0], int(ys.min()) + offset[1],
            int(xs.max() - xs.min() + 1), int(ys.max() - ys.min() + 1)]


def main_component(mask):
    parts, _ = label(mask)
    counts = np.bincount(parts.ravel())
    counts[0] = 0
    return parts == counts.argmax()


def cell(data, filename, col, row):
    cols, rows = GRIDS[filename]
    if filename not in BOXES:
        parts, _ = label(data[:, :, 3] > 128)
        counts = np.bincount(parts.ravel())
        boxes = []
        for index, obj in enumerate(find_objects(parts), 1):
            if obj is not None and counts[index] > 1000:
                ys, xs = obj
                boxes.append([xs.start, ys.start, xs.stop, ys.stop])
        assert len(boxes) == cols * rows, (filename, len(boxes))
        boxes.sort(key=lambda b: b[1])
        BOXES[filename] = [b for start in range(0, len(boxes), cols)
                           for b in sorted(boxes[start:start+cols], key=lambda b: b[0])]
    # Source drawings can cross the nominal cell boundary by a few pixels.
    # Measure complete components, not equal rectangles that clip the crest.
    x0, y0, x1, y1 = BOXES[filename][row*cols+col]
    pixels = data[y0:y1, x0:x1]
    # Only measure; sources are copied byte for byte, never rewritten.
    alpha = pixels[:, :, 3] > 128
    connected = main_component(alpha)
    r, g, b = [pixels[:, :, i].astype(int) for i in range(3)]
    blue = (b > r + 35) & (g > r + 20)
    orange = (r > 220) & (g > 110) & (g < 210) & (b < 105) & (r > g * 1.18)
    cream = (g > 170) & (b > 120) & (r > g + 20) & (g > b + 20)
    anatomy = connected & (blue | orange | cream)
    body = box_of(anatomy, (x0, y0))
    region = box_of(connected, (x0, y0))
    return region, body


def nearest_drawn(point, data, region):
    x, y, w, h = region
    ys, xs = np.nonzero(data[y:y+h, x:x+w, 3] > 128)
    i = np.argmin((xs + x - point[0]) ** 2 + (ys + y - point[1]) ** 2)
    return [int(xs[i] + x), int(ys[i] + y)]


def build_catalog():
    old = json.loads((SOURCE / 'dragon-registro-base.json').read_text())['frames']
    images = {name: np.asarray(Image.open(SOURCE / name).convert('RGBA')) for name in GRIDS}
    frames = {}

    def add(key, filename, col, row, reference):
        data = images[filename]
        region, body = cell(data, filename, col, row)
        pose, direction = key.rsplit('-', 1)
        if pose in ['reposo','sin-equipo','andar-a','paso-a','andar-b','paso-b']:
            # In carry/walk views the tool is below the crest. Include its
            # dark outline so the rendered crest stays at exactly 80 px,
            # rather than letting a 1–2 px outline difference look like growth.
            body[3] += body[1]-region[1]
            body[1] = region[1]
        ox, oy, ow, oh = reference['region']
        bx, by, bw, bh = body
        # Ground is registered independently of any raised tool silhouette.
        head_band = data[by+round(bh*.20):by+round(bh*.40), bx:bx+bw, :3].astype(int)
        hr, hg, hb = [head_band[:, :, i] for i in range(3)]
        _, head_x = np.nonzero((hb > hr+35) & (hg > hr+20))
        anchor = [float(bx + np.median(head_x)), by + bh - 2]
        height = anchor[1] - by
        desired = {'arrodillado': 59, 'levantar': 60, 'medio': 76,
                   'medio-talar': 76, 'golpe': 65, 'golpe-talar': 65}.get(pose, 80)
        hands = {}
        for name in ['hand', 'other_hand']:
            relative = [(reference[name][0]-ox)/ow, (reference[name][1]-oy)/oh]
            point = [bx + relative[0] * bw, by + relative[1] * bh]
            hands[name] = nearest_drawn(point, data, region)
        baked = pose not in ['arrodillado', 'levantar', 'sin-equipo']
        frame = dict(file=filename, region=region, anchor=anchor,
                     body_bounds_px=body, body_height_px=height, presentation_height_px=desired,
                     scale=round(desired/height, 8), baked_tool=baked,
                     tool_behind=direction in ['NW', 'N', 'NE'], **hands)
        if not baked and pose != 'sin-equipo':
            hx, hy = hands['hand']
            frame['hand_cover'] = [hx-9, hy-8, 18, 16]
        if pose in ['reposo', 'andar-a', 'paso-a', 'andar-b', 'paso-b']:
            frame['carry_orientation'] = 'punta-arriba-filo-abajo'
        if pose in CONTACT_REFERENCES:
            px, py = CONTACT_REFERENCES[pose][DIRS.index(direction)]
            patch = data[py-12:py+13, px-12:px+13]
            rgb = patch[:, :, :3].astype(int)
            metal = (patch[:, :, 3]>128) & ((rgb.max(2)-rgb.min(2))<65) & (rgb.min(2)>60)
            ys, xs = np.nonzero(metal)
            assert len(xs), ('Contacto sin metal', key)
            nearest = np.argmin((xs-12)**2+(ys-12)**2)
            action = 'minar' if pose == 'golpe' else 'talar'
            frame['contacts'] = {action:[int(px-12+xs[nearest]), int(py-12+ys[nearest])]}
        frames[key] = frame

    for key, reference in old.items():
        name = reference['file']
        cols, rows = GRIDS[name]
        data = images[name]
        x, y, w, h = reference['region']
        col = min(cols-1, int((x+w/2)*cols/data.shape[1]))
        row = min(rows-1, int((y+h/2)*rows/data.shape[0]))
        if key == 'levantar-E':
            col, row = 2, 3
        add(key, name, col, row, reference)
    # Complete the second half-cycle at the back: the opposite passing leg.
    add('paso-b-N', 'dragon-marcha-apoyos.png', 1, 1, old['andar-b-N'])
    for direction, row, col in [('W',0,0), ('E',0,2), ('SW',1,0), ('SE',1,2)]:
        for index, pose in enumerate(['andar-b', 'paso-b']):
            add(pose+'-'+direction, 'dragon-marcha-opuesta.png', col+index, row,
                old[pose+'-'+direction])
    for index, direction in enumerate(DIRS):
        add('sin-equipo-'+direction, 'dragon-sin-equipo.png', index%4, index//4, old['reposo-'+direction])
        add('medio-talar-'+direction, 'dragon-tala.png', index%4, index//4, old['medio-'+direction])
        add('golpe-talar-'+direction, 'dragon-tala.png', index%4, 2+index//4, old['golpe-'+direction])
    assert len(frames) == 104
    return dict(version=4, directions=DIRS, presentation_height_px=80,
                reference='dragon-idle.png',
                runtime_normalization=dict(upright_height_px=80, kneeling_height_px=59,
                                           filter='nearest', remove_isolated_components_at_or_below=240),
                sources={name: dict(size=[data.shape[1], data.shape[0]],
                                    sha256=hashlib.sha256((SOURCE/name).read_bytes()).hexdigest())
                         for name,data in images.items()},
                notes=['Herramienta y dedos dibujados junto al cuerpo: sin montaje giratorio.',
                       'Punta del pico arriba y filo del hacha abajo al llevarla.',
                       'Cuatro fases de marcha por dirección; apoyos alternados.',
                       'Altura del cuerpo medida sin metal; ancla de suelo por fotograma.',
                       'Tala lateral y minería sobre cabeza con atlas distintos.',
                       'Fuentes PNG intactas. Revisión visual del usuario pendiente.'],
                frames=frames)


def main():
    catalog = build_catalog()
    (SOURCE / 'dragon-jugable.json').write_text(json.dumps(catalog, ensure_ascii=False, indent=2)+'\n')
    TARGET.mkdir(parents=True, exist_ok=True)
    for name in [*GRIDS, 'dragon-jugable.json']:
        shutil.copyfile(SOURCE/name, TARGET/name)
    print('104 poses registradas; diez PNG copiados sin modificar sus bytes.')


if __name__ == '__main__':
    main()
