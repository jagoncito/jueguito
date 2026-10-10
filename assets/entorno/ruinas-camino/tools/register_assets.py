"""Registra regiones sin modificar los PNG fuente. Requiere Pillow, numpy y scipy."""
import hashlib
import json
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

ROOT = Path(__file__).resolve().parents[1]
GROUPS = {
    'terreno': [
        'hierba-a', 'hierba-b', 'tierra', 'pavimento',
        'sendero-recto-a', 'sendero-recto-b', 'sendero-curva-a', 'sendero-curva-b',
        'sendero-curva-c', 'sendero-curva-d', 'sendero-final-a', 'sendero-final-b',
        'sendero-final-c', 'sendero-final-d', 'pavimento-musgo', 'pavimento-hierba',
    ],
    'ruinas': [
        'muro-bajo-a', 'muro-bajo-b', 'muro-esquina', 'arco',
        'columna-alta', 'columna-baja', 'columna-caida-a', 'columna-caida-b',
        'escombros-pequenos', 'escombros-grandes', 'dintel-caido', 'pedestal',
        'escalones-a', 'escalones-b', 'muro-alto-a', 'muro-alto-b',
    ],
    'costa': [
        'acantilado-a', 'acantilado-b', 'acantilado-esquina-a', 'acantilado-esquina-b',
        'rampa-a', 'rampa-b', 'roca', 'rocas',
        'pino', 'arbol-costero', 'arbusto-a', 'arbusto-b',
        'hierbas', 'flores-blancas', 'flores-moradas', 'tronco',
    ],
}


def regions(path):
    """Las fuentes no cumplen una cuadrícula exacta; medir las 16 siluetas grandes."""
    with Image.open(path) as image:
        pixels = np.array(image.convert('RGBA'))
    labels, _ = ndimage.label(pixels[:, :, 3] > 127)
    found = []
    for index, slices in enumerate(ndimage.find_objects(labels), 1):
        if slices is None:
            continue
        area = int((labels[slices] == index).sum())
        if area > 1500:
            found.append((area, slices))
    found = sorted(found, key=lambda item: item[0], reverse=True)[:16]
    assert len(found) == 16, f'{path}: faltan siluetas'
    found.sort(key=lambda item: (item[1][0].start + item[1][0].stop) / 2)
    ordered = []
    for row in range(4):
        ordered.extend(sorted(found[row*4:row*4+4], key=lambda item: item[1][1].start))
    output = []
    for _, (ys, xs) in ordered:
        x, y = max(0, xs.start - 2), max(0, ys.start - 2)
        right, bottom = min(pixels.shape[1], xs.stop + 2), min(pixels.shape[0], ys.stop + 2)
        output.append([x, y, right - x, bottom - y])
    for i, a in enumerate(output):
        for b in output[i+1:]:
            assert not (max(a[0],b[0]) < min(a[0]+a[2],b[0]+b[2]) and
                        max(a[1],b[1]) < min(a[1]+a[3],b[1]+b[3])), 'Recortes superpuestos'
    return output


def reference_size(group, name):
    if group == 'terreno':
        return 'width', 64
    if name == 'arco':
        return 'height', 144
    if name in ('columna-alta', 'columna-baja'):
        return 'height', 96 if name == 'columna-alta' else 48
    if name in ('pino', 'arbol-costero'):
        return 'height', 160 if name == 'pino' else 176
    if name.startswith(('muro', 'acantilado', 'rampa')):
        return 'width', 128
    return 'width', 48 if name.startswith(('flores', 'hierbas')) else 64


def main():
    textures = ROOT / 'texturas'
    scenes = ROOT / 'prefabs'
    textures.mkdir(exist_ok=True)
    scenes.mkdir(exist_ok=True)
    catalog = {'version': 1, 'status': 'registrado-para-revision-no-integrado',
               'tile_reference': [64,32], 'adult_height_reference': 80,
               'collision_status': 'pendiente', 'sources': {}, 'assets': []}
    for group, names in GROUPS.items():
        path = ROOT / 'atlas' / f'{group}.png'
        with Image.open(path) as image:
            size = list(image.size)
        catalog['sources'][group] = {'file': f'atlas/{group}.png', 'size': size,
                                    'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
        for name, region in zip(names, regions(path)):
            identity = f'{group}-{name}'
            x, y, width, height = region
            axis, target = reference_size(group, name)
            scale = target / (width if axis == 'width' else height)
            anchor = [width / 2, height / 2 if group == 'terreno' else height]
            (textures / f'{identity}.tres').write_text(
                '[gd_resource type="AtlasTexture" load_steps=2 format=3]\n\n'
                f'[ext_resource type="Texture2D" path="../atlas/{group}.png" id="1"]\n\n'
                '[resource]\natlas = ExtResource("1")\n'
                f'region = Rect2({x}, {y}, {width}, {height})\nfilter_clip = true\n')
            (scenes / f'{identity}.tscn').write_text(
                '[gd_scene load_steps=2 format=3]\n\n'
                f'[ext_resource type="Texture2D" path="../texturas/{identity}.tres" id="1"]\n\n'
                f'[node name="Pieza" type="Node2D"]\ntexture_filter = 1\n\n'
                '[node name="Dibujo" type="Sprite2D" parent="."]\n'
                f'position = Vector2({-anchor[0]*scale:.8f}, {-anchor[1]*scale:.8f})\n'
                f'scale = Vector2({scale:.8f}, {scale:.8f})\n'
                'texture = ExtResource("1")\ncentered = false\n')
            catalog['assets'].append({'id': identity, 'group': group, 'region': region,
                'anchor_source': anchor, 'uniform_scale': scale,
                'visible_reference_size': [width*scale,height*scale],
                'texture': f'texturas/{identity}.tres', 'prefab': f'prefabs/{identity}.tscn',
                'anchor_status': 'provisional', 'seams_status': 'pendiente'})
    assert len(catalog['assets']) == 48
    (ROOT / 'assets.json').write_text(json.dumps(catalog, ensure_ascii=False, indent=2)+'\n')
    print('BITU_RUINAS_ASSETS_48_OK')


if __name__ == '__main__':
    main()
