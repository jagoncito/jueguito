"""Mediciones de solo lectura de figuras completas y regiones anatómicas.

No recorta, genera, modifica ni guarda imágenes. El informe distingue tamaño de
fuente y tamaño presentado para evitar igualar siluetas extendiendo miembros.
Las regiones de cabeza/torso son explícitas: el color o el borde de una cola no
pueden decidir automáticamente la proporción correcta del personaje.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np
from scipy.ndimage import find_objects, label

from register_dragon import SOURCE, describe_source, pixels, read_json


def components(filename):
    data = pixels(filename)
    groups, _ = label(data[:, :, 3] > 128, np.ones((3, 3)))
    counts = np.bincount(groups.ravel())
    result = []
    for index, bounds in enumerate(find_objects(groups), 1):
        if bounds is None or counts[index] < 500:
            continue
        y, x = bounds
        result.append({"region": [x.start, y.start, x.stop-x.start, y.stop-y.start],
                       "opaque_pixels": int(counts[index])})
    return sorted(result, key=lambda spec: (spec["region"][1], spec["region"][0]))


def anatomy_regions(filename, regions, factor):
    result = {}
    for name, region in regions.items():
        description = describe_source(filename, region)
        bounds = description["opaque_bounds_px"]
        result[name] = {
            "measurement_region_px": region, "opaque_bounds_px": bounds,
            "presentation_width_px": round(bounds[2]*factor, 4),
            "presentation_height_px": round(bounds[3]*factor, 4),
            "opaque_pixels": description["opaque_pixels"],
        }
    if "head" in result and "torso" in result:
        head, torso = result["head"], result["torso"]
        result["head_to_torso_width"] = round(head["presentation_width_px"]/torso["presentation_width_px"], 4)
    return result


def report_registration(registration):
    result = {}
    for action, views in registration["animations"].items():
        result[action] = {}
        for direction, specs in views.items():
            rows = []
            for index, spec in enumerate(specs):
                path = SOURCE/spec["file"]
                factor = spec["import_scale"]
                report = describe_source(path, spec["region"], spec.get("body_bounds_px"))
                report.update(phase=index, file=spec["file"], import_scale=factor,
                              presentation_bounds_px=[round(value*factor, 3) for value in report["opaque_bounds_px"][2:]],
                              anatomy=anatomy_regions(path, spec.get("measurement_regions", {}), factor))
                if spec.get("body_bounds_px"):
                    report["presentation_body_height_px"] = round(spec["body_bounds_px"][3]*factor, 3)
                rows.append(report)
            result[action][direction] = rows
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--registration", type=Path)
    parser.add_argument("--file", type=Path)
    parser.add_argument("--region", type=int, nargs=4)
    parser.add_argument("--head", type=int, nargs=4)
    parser.add_argument("--torso", type=int, nargs=4)
    parser.add_argument("--import-scale", type=float, default=1)
    args = parser.parse_args()
    if args.registration:
        result = report_registration(read_json(args.registration))
    elif args.file:
        data = pixels(args.file)
        region = args.region or [0, 0, data.shape[1], data.shape[0]]
        regions = {name: getattr(args, name) for name in ["head", "torso"] if getattr(args, name)}
        result = {"file": str(args.file), "source_size_px": [data.shape[1], data.shape[0]],
                  "components": components(args.file), "frame": describe_source(args.file, region),
                  "anatomy": anatomy_regions(args.file, regions, args.import_scale)}
    else:
        parser.error("Indica --registration o --file")
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
