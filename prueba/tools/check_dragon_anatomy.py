"""Audita los fotogramas completos que reproduce Godot, sin editar PNG.

Altura, escala y alineación son controles técnicos. La alternancia y el acabado
se revisan además en los ciclos y en el juego: este informe no los aprueba.
"""
import hashlib
import json
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'assets/personajes/dragon'


def audit():
    catalog = json.loads((SOURCE / 'dragon-jugable.json').read_text())
    images = {}
    frames = catalog['frames']

    def pixels(frame):
        name = frame['file']
        if name not in images:
            images[name] = np.array(Image.open(SOURCE / name).convert('RGBA'))
        x, y, w, h = frame['region']
        assert 0 <= x and 0 <= y and x+w <= images[name].shape[1] and y+h <= images[name].shape[0]
        result = images[name][y:y+h, x:x+w]
        assert np.any(result[:, :, 3] > 128), ('Fotograma vacío', name, frame['region'])
        return result

    def top(frame):
        patch = pixels(frame)
        ys, _ = np.where(patch[:, :, 3] > 128)
        return (int(ys.min())+frame['region'][1]-frame['anchor'][1])*frame['scale']

    report = {}
    for direction in catalog['directions']:
        idle = frames['reposo-'+direction]
        result = {'idle_top_px': round(top(idle), 3)}
        for action in ['andar', 'sprint']:
            keys = catalog['animations'][action][direction]
            preserved_north = direction == 'N'
            assert len(keys) == 4 if preserved_north else len(keys) >= 6
            specs = [frames[key] for key in keys]
            scales = [spec['scale'] for spec in specs]
            tops = [top(spec) for spec in specs]
            assert len(set(scales)) == 1, ('Escala cambia dentro del ciclo', action, direction)
            assert all(abs(value-top(idle)) <= 2.01 for value in tops), ('Cambio de altura', action, direction, tops, top(idle))
            if not preserved_north:
                cell_sizes = [tuple(spec.get('canvas_px',spec['region'][2:])) for spec in specs]
                anchors = [tuple(spec.get('canvas_anchor_px',[spec['anchor'][axis]-spec['region'][axis] for axis in range(2)])) for spec in specs]
                assert len(set(cell_sizes)) == 1, ('Lienzo cambia', action, direction)
                assert len(set(anchors)) == 1, ('Ancla cambia', action, direction)
            distinct = []
            widths = []
            for spec in specs:
                patch = pixels(spec)
                if spec.get('mirror_x', False):
                    patch = patch[:, ::-1]
                distinct.append(hashlib.sha256(patch.tobytes()).hexdigest())
                ys, xs = np.where(patch[:, :, 3] > 128)
                widths.append(round(float(xs.max()-xs.min()+1)*spec['scale'], 3))
            assert len(set(distinct)) == len(keys), ('Fotogramas repetidos', action, direction)
            result[action] = {'frames': len(keys), 'top_px': [round(value, 3) for value in tops],
                              'width_px': widths, 'one_scale': True, 'common_anchor': not preserved_north}
        for action in ['minar', 'talar']:
            keys = catalog['animations'][action][direction]
            assert len(keys) >= 6
            impact = frames[keys[3]]
            point = impact['contacts'][action]
            x, y, _, _ = impact['region']
            patch = pixels(impact)
            assert patch[point[1]-y, point[0]-x, 3] > 128, ('Contacto vacío', action, direction)
            assert impact['working_end'] == ('pick_tip' if action == 'minar' else 'axe_edge')
            result[action] = {'frames': len(keys), 'impact_phase': 3, 'working_end': impact['working_end']}
        report[direction] = result
    return report


if __name__ == '__main__':
    print(json.dumps(audit(), ensure_ascii=False, indent=2))
    print('BITU_DRAGON_ANATOMY_OK: píxeles, escala, anclas y extremos registrados')
