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
    'dragon-sin-equipo.png': (4, 2),
    'dragon-herboristeria.png': (4, 4),
    'dragon-transiciones.png': (4, 4),
    'dragon-trabajo.png': (4, 4),
    'dragon-tala.png': (4, 4),
    'dragon-marcha-frontal.png': (4, 4),
    'dragon-marcha-trasera.png': (4, 4),
    'dragon-marcha-norte.png': (4, 4),
}
BOXES = {}
# Extremos visibles revisados en las fuentes de impacto; no contactos ficticios
# colocados en el recurso. Se ajustan al píxel de metal más próximo (máx. 12 px).
CONTACT_REFERENCES = {
    'golpe': [(170,883),(377,862),(668,866),(1009,772),
              (170,912),(586,1149),(892,1120),(1207,1166)],
    'golpe-talar': [(167,879),(386,868),(680,870),(970,806),
                    (166,913),(585,1125),(887,1140),(1178,1147)],
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
        if not len(head_x):
            # Some newly shaded faces have no saturated blue in the narrow
            # head band. Measure the middle of the blue torso instead of
            # emitting a NaN anchor into the playable JSON.
            torso = data[by+round(bh*.40):by+round(bh*.75), bx:bx+bw, :3].astype(int)
            tr, tg, tb = [torso[:, :, i] for i in range(3)]
            _, head_x = np.nonzero((tb > tr+20) & (tg > tr+10))
        assert len(head_x), ('Ancla sin cuerpo azul', key)
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
            frame['working_end'] = 'pick_tip' if action == 'minar' else 'axe_edge'
            frame['contact_reference'] = [px, py]
        frames[key] = frame

    for key, reference in old.items():
        if key.startswith(('reposo-', 'andar-', 'paso-')):
            continue
        name = reference['file']
        cols, rows = GRIDS[name]
        data = images[name]
        x, y, w, h = reference['region']
        col = min(cols-1, int((x+w/2)*cols/data.shape[1]))
        row = min(rows-1, int((y+h/2)*rows/data.shape[0]))
        if key == 'levantar-E':
            col, row = 2, 3
        add(key, name, col, row, reference)
    walk_sources = {
        'S': ('dragon-marcha-frontal.png', 0),
        'SW': ('dragon-marcha-frontal.png', 1),
        'E': ('dragon-marcha-frontal.png', 2),
        'SE': ('dragon-marcha-frontal.png', 3),
        'W': ('dragon-marcha-trasera.png', 0),
        'NE': ('dragon-marcha-trasera.png', 1),
        'NW': ('dragon-marcha-trasera.png', 3),
        'N': ('dragon-marcha-norte.png', 2),
    }
    for direction, (filename, row) in walk_sources.items():
        poses = ['andar-a', 'paso-a', 'andar-b', 'paso-b']
        for col, pose in enumerate(poses):
            add(pose+'-'+direction, filename, col, row, old[pose+'-'+direction])
        # A single anatomical scale/ground reference for the whole cycle.
        # Measuring to a different foot on every frame resized the head/torso.
        height = frames['andar-a-'+direction]['body_height_px']
        for pose in poses:
            frame = frames[pose+'-'+direction]
            frame['body_height_px'] = height
            frame['anchor'][1] = frame['body_bounds_px'][1]+height
            frame['scale'] = round(80/height, 8)
            frame['anatomy_reference'] = 'andar-a-'+direction
        # Both feet in a contact stance: stopping and starting share actual
        # pixels, anatomy and ground registration, rather than another skin.
        frames['reposo-'+direction] = dict(frames['andar-a-'+direction])
    for index, direction in enumerate(DIRS):
        add('sin-equipo-'+direction, 'dragon-sin-equipo.png', index%4, index//4, old['reposo-'+direction])
        # Same neutral preparation, overhead load and impact gesture as mining.
        # The chopping load/impact drawings use the opposite metal end.
        frames['medio-talar-'+direction] = dict(frames['medio-'+direction])
        add('cargar-talar-'+direction, 'dragon-tala.png', index%4, index//4, old['cargar-'+direction])
        add('golpe-talar-'+direction, 'dragon-tala.png', index%4, 2+index//4, old['golpe-'+direction])
    assert len(frames) == 112
    return dict(version=5, directions=DIRS, presentation_height_px=80,
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
                       'Reposo comparte el contacto A; una escala anatómica por dirección y ciclo.',
                       'Tala y minería comparten gesto; filo del hacha / punta del pico como extremos activos.',
                       'Contactos de impacto sobre punta del pico / filo del hacha; nunca sobre el mango.',
                       'Fuentes PNG intactas. Revisión visual del usuario pendiente.'],
                frames=frames)


def main():
    catalog = build_catalog()
    (SOURCE / 'dragon-jugable.json').write_text(json.dumps(catalog, ensure_ascii=False, indent=2, allow_nan=False)+'\n')
    TARGET.mkdir(parents=True, exist_ok=True)
    for name in [*GRIDS, 'dragon-jugable.json']:
        shutil.copyfile(SOURCE/name, TARGET/name)
    print('112 poses registradas; ocho PNG copiados sin modificar sus bytes.')


if __name__ == '__main__':
    main()
