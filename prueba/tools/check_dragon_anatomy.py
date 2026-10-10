"""Measure actual source pixels across idle and four walk phases.

The earlier total-height check missed changing skull/face proportions. These
measurements exclude metal, ears for the frontal muzzle, and raised feet.
Pillow reads original bytes; this script never edits PNGs.
"""
import json
from pathlib import Path

import numpy as np
from PIL import Image
from scipy.ndimage import find_objects, label

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'assets/personajes/dragon-avatar'
POSES = ['reposo', 'andar-a', 'paso-a', 'andar-b', 'paso-b']


def audit():
    catalog = json.loads((SOURCE / 'dragon-jugable.json').read_text())
    images = {name: np.asarray(Image.open(SOURCE/name).convert('RGBA'))
              for name in catalog['sources']}
    report = {}
    for direction in catalog['directions']:
        frames = [catalog['frames'][pose+'-'+direction] for pose in POSES]
        assert frames[0] == frames[1], ('Idle differs from contact stance', direction)
        assert len({frame['scale'] for frame in frames}) == 1, direction
        widths, faces = [], []
        for frame in frames:
            data = images[frame['file']]
            x, y, w, h = frame['region']
            height = frame['body_height_px']
            patch = data[y:y+round(height*.52), x:x+w]
            r, g, b = [patch[:, :, i].astype(int) for i in range(3)]
            cream = (patch[:, :, 3]>128) & (r>170) & (g>140) & (b>100) & (r>g+10) & (g>b+10)
            parts, _ = label(cream)
            counts = np.bincount(parts.ravel())
            boxes = [(counts[i], obj[1].stop-obj[1].start)
                     for i, obj in enumerate(find_objects(parts), 1)
                     if obj is not None and counts[i]>50]
            faces.append(max(boxes, default=(0, 0))[1]*frame['scale'])
            # Back views have almost no visible muzzle. Measure the actual
            # coloured skull/fin silhouette in its upper band instead.
            bx, by, bw, _ = frame['body_bounds_px']
            patch = data[by+round(height*.16):by+round(height*.42), bx:bx+bw]
            r, g, b = [patch[:, :, i].astype(int) for i in range(3)]
            anatomy = (patch[:, :, 3]>128) & (((b>r+25)&(g>r+15)) |
                ((r>220)&(g>90)&(g<210)&(b<115)) |
                ((r>g+20)&(g>b+20)&(g>170)))
            rows = [np.flatnonzero(row) for row in anatomy if row.sum()>20]
            widths.append(float(np.median([row[-1]-row[0]+1 for row in rows]))*frame['scale'])
        metric = widths if direction in ['N', 'NE', 'NW'] else faces
        assert max(metric)/min(metric)<1.08, (direction, 'Changing head size', metric)
        report[direction] = {'face_width_px': [round(v, 2) for v in faces],
                             'skull_width_px': [round(v, 2) for v in widths],
                             'scale': frames[0]['scale'], 'idle_equals_contact': True}
    return report


if __name__ == '__main__':
    print(json.dumps(audit(), ensure_ascii=False, indent=2))
    print('BITU_DRAGON_ANATOMY_OK')
