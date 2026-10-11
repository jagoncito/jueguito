"""Compila el registro explícito del dragón y empaqueta sprites enteros en Godot.

El arte de entrada se conserva. Python solo lee píxeles y registros; Godot
importa cada figura completa con escala uniforme y traslación, sin rig ni retoque.
Los registros aceptados mantienen regiones, apoyos y transformaciones originales.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import os
import shutil
import subprocess
import tempfile
from pathlib import Path

import numpy as np
from PIL import Image
from scipy.ndimage import label

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "assets/personajes/dragon"
RUNTIME = ROOT / "prueba/assets/personajes/dragon"
DIRS = ["S", "SW", "W", "NW", "N", "NE", "E", "SE"]
CELL = [192, 192]
ANCHOR = [96, 168]
WALK = ["andar-a", "paso-a", "andar-b", "paso-b"]
RUN = ["sprint-a", "sprint-paso-a", "sprint-b", "sprint-paso-b"]
WORK = {
    "minar": ["medio", "cargar", "golpe", "recuperar"],
    "talar": ["medio-talar", "cargar-talar", "golpe-talar", "recuperar-talar"],
}
PHASES = ["preparacion", "carga", "descenso", "impacto", "seguimiento", "recuperacion"]


def read_json(path: Path):
    return json.loads(path.read_text())


def write_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, separators=(",", ":")) + "\n")


def pixels(path: Path):
    return np.array(Image.open(path).convert("RGBA"))


def describe_source(path: Path, region: list[int], body_bounds=None):
    """Medidas de lectura; no cambia proporciones ni decide si el dibujo es bueno."""
    data = pixels(path)
    x, y, w, h = region
    assert all(isinstance(v, int) for v in region), (path, region)
    assert x >= 0 and y >= 0 and w > 0 and h > 0
    assert x+w <= data.shape[1] and y+h <= data.shape[0], (path, region)
    alpha = data[y:y+h, x:x+w, 3] > 128
    ys, xs = np.where(alpha)
    assert xs.size, (path, "Fotograma vacío")
    components, count = label(alpha, np.ones((3, 3)))
    sizes = np.bincount(components.ravel())[1:]
    result = {
        "opaque_bounds_px": [int(xs.min())+x, int(ys.min())+y,
                             int(xs.max()-xs.min()+1), int(ys.max()-ys.min()+1)],
        "opaque_pixels": int(alpha.sum()),
        "significant_alpha_components": int(np.sum(sizes >= 16)),
        "alpha_components": int(count),
    }
    if body_bounds is not None:
        bx, by, bw, bh = body_bounds
        assert x <= bx < bx+bw <= x+w and y <= by < by+bh <= y+h
        result["body_bounds_px"] = body_bounds
        # Anchura por bandas, incluyendo cabeza/torso: solo indicador auditable.
        patch = data[by:by+bh, bx:bx+bw, 3] > 128
        widths = []
        for start, stop in [(0, .3), (.3, .6), (.6, .85), (.85, 1)]:
            area = patch[int(bh*start):int(bh*stop)]
            _, band_xs = np.where(area)
            widths.append(int(band_xs.max()-band_xs.min()+1) if band_xs.size else 0)
        result["body_band_widths_px"] = widths
    return result


def source_metadata(path: Path):
    return {"size_px": list(Image.open(path).size),
            "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}


def transformed_point(spec, point, cell_index=0):
    factor = spec["import_scale"]
    offset = [(point[i]-spec["anchor"][i])*factor for i in range(2)]
    if spec.get("mirror_x", False):
        offset[0] *= -1
    # Nearest matching logical pixel centres; one transformation for all points.
    return [int(math.floor(ANCHOR[0]+offset[0]))+CELL[0]*cell_index,
            int(math.floor(ANCHOR[1]+offset[1]))]


def transformed_bounds(spec, bounds, cell_index=0):
    x, y, w, h = bounds
    points = [transformed_point(spec, p, cell_index) for p in [(x, y), (x+w, y+h)]]
    return [min(p[0] for p in points), min(p[1] for p in points),
            abs(points[1][0]-points[0][0]), abs(points[1][1]-points[0][1])]


def validate_spec(spec, action, direction, phase):
    required = {"file", "region", "anchor", "import_scale", "body_bounds_px"}
    assert required <= spec.keys(), (action, direction, phase, required-spec.keys())
    filename = SOURCE/spec["file"]
    assert filename.is_file(), filename
    factor = spec["import_scale"]
    assert isinstance(factor, (int, float)) and 0 < factor <= 2
    assert len(spec["anchor"]) == 2
    assert isinstance(spec.get("mirror_x", False), bool)
    measurement = describe_source(filename, spec["region"], spec["body_bounds_px"])
    visible = transformed_bounds(spec, measurement["opaque_bounds_px"])
    assert 0 <= visible[0] and 0 <= visible[1]
    assert visible[0]+visible[2] <= CELL[0] and visible[1]+visible[3] <= CELL[1], (
        "El personaje completo sale del lienzo", action, direction, phase, visible)
    if action in WORK:
        assert spec.get("working_end") == ("pick_tip" if action == "minar" else "axe_edge")
        if phase == 3:
            assert action in spec.get("contacts", {}), ("Impacto sin contacto", action, direction)
    return measurement


def native_frame(spec, filename, phase, action, measurement):
    origin = phase*CELL[0]
    body_bounds = transformed_bounds(spec, spec["body_bounds_px"], phase)
    hand = spec.get("hand", spec["anchor"])
    other = spec.get("other_hand", hand)
    height = body_bounds[3]
    result = {
        "file": filename, "region": [origin, 0, *CELL], "anchor": [origin+ANCHOR[0], ANCHOR[1]],
        "canvas_px": CELL, "canvas_anchor_px": ANCHOR, "scale": 1.0,
        "hand": transformed_point(spec, hand, phase),
        "other_hand": transformed_point(spec, other, phase),
        "body_bounds_px": body_bounds, "body_height_px": height,
        "presentation_height_px": height, "tool_behind": False,
        "baked_tool": action in WORK, "mirror_x": False, "complete_sprite": True,
        "source_frame": copy.deepcopy(spec),
        "source_measurements": measurement,
    }
    if action in WORK:
        result["phase"] = PHASES[phase]
        result["working_end"] = spec["working_end"]
    if "contacts" in spec:
        result["contacts"] = {name: transformed_point(spec, point, phase)
                              for name, point in spec["contacts"].items()}
    return result


def compile_catalog(registration, preserved, staging):
    assert preserved["directions"] == DIRS
    assert len(preserved["frames"]) == 96, "El catálogo aceptado debe contener96 registros"
    frames = copy.deepcopy(preserved["frames"])
    animations, jobs = {}, []
    source_files = set()
    for action in ["andar", "sprint", "minar", "talar"]:
        animations[action] = {}
        for direction in DIRS:
            if direction == "N" and action in ["andar", "sprint"]:
                aliases = WALK if action == "andar" else RUN
                animations[action][direction] = [f"{pose}-N" for pose in aliases]
                continue
            specs = registration["animations"][action][direction]
            assert len(specs) == 6, (action, direction, "Se requieren seis dibujos completos")
            name = f"sprites/fotogramas/{action}-{direction}.png"
            output = staging/name
            output.parent.mkdir(parents=True, exist_ok=True)
            job = {"output": str(output), "frames": []}
            keys = []
            for phase, spec in enumerate(specs):
                measurement = validate_spec(spec, action, direction, phase)
                key = f"{action}-fotograma-{phase+1}-{direction}"
                keys.append(key)
                frames[key] = native_frame(spec, name, phase, action, measurement)
                source_files.add(spec["file"])
                job["frames"].append(dict(spec, file=str(SOURCE/spec["file"])))
            animations[action][direction] = keys
            jobs.append(job)
            aliases = WORK[action] if action in WORK else (WALK if action == "andar" else RUN)
            mapped = [0, 2, 3, 5] if action in WORK else [0, 1, 3, 5]
            for alias, index in zip(aliases, mapped):
                frames[f"{alias}-{direction}"] = copy.deepcopy(frames[keys[index]])
    assert len(frames) == 396, len(frames)
    catalog = {
        "version": 3, "art_revision": registration.get("art_revision", "dragon-fotogramas-completos-2026-10-11"),
        "height_px": 80, "directions": DIRS, "frames": frames, "animations": animations,
        "work_timing": {action: [0.0, .12, .24, .33, .40, .50] for action in WORK},
        "native_canvas_px": CELL, "native_anchor_px": ANCHOR,
        "sources": {}, "source_art": {name: source_metadata(SOURCE/name) for name in sorted(source_files)},
        "notes": [
            "Fotogramas completos, sin rig, deformaciones ni rotación de extremidades.",
            "Godot importa el personaje entero mediante nearest, un factor uniforme y traslación.",
            "Marcha/carrera NORTE, pesca, recolección, garras y reposo conservan registros aceptados.",
            "Las vistas derechas se reflejan una sola vez por dirección y conservan la anatomía del ciclo.",
            "Los controles técnicos no sustituyen la revisión visual de cada ciclo y transición.",
        ],
    }
    return catalog, jobs


def validate_native(catalog, staging):
    images = {}
    for key, frame in catalog["frames"].items():
        if not frame.get("complete_sprite"):
            continue
        filename = frame["file"]
        if filename not in images:
            images[filename] = pixels(staging/filename)
        data = images[filename]
        x, y, w, h = frame["region"]
        patch = data[y:y+h, x:x+w]
        assert np.any(patch[:, :, 3] > 128), (key, "Importación vacía")
        assert not np.any(patch[[0, -1], :, 3] > 128) and not np.any(patch[:, [0, -1], 3] > 128), (
            key, "Dibujo recortado por el borde del lienzo")
        for action, point in frame.get("contacts", {}).items():
            assert 0 <= point[0]-x < w and 0 <= point[1]-y < h
            assert data[point[1], point[0], 3] > 128, (key, action, "Contacto transparente tras importar", point)


def run_baker(jobs, staging):
    manifest = staging/"empaquetado.json"
    write_json(manifest, {"jobs": jobs})
    environment = dict(os.environ)
    environment.update(XDG_DATA_HOME="/workspace/.local/godot/data",
                       XDG_CONFIG_HOME="/workspace/.local/godot/config",
                       XDG_CACHE_HOME="/workspace/.cache/godot")
    subprocess.run([shutil.which("godot") or "godot", "--headless", "--path", str(ROOT/"prueba"),
                    "--script", "res://tools/bake_dragon_atlas.gd", "--", str(manifest)],
                   env=environment, check=True, timeout=120)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--registration", type=Path, default=SOURCE/"registro-fotogramas.json")
    args = parser.parse_args()
    preserved = read_json(SOURCE/"catalogo-conservado.json")
    registration = read_json(args.registration)
    scratch = ROOT.parent/"work/bitu-fotogramas"
    scratch.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="atlas-", dir=scratch) as temp:
        staging = Path(temp)
        catalog, jobs = compile_catalog(registration, preserved, staging)
        run_baker(jobs, staging)
        validate_native(catalog, staging)
        files = sorted({frame["file"] for frame in catalog["frames"].values()})
        for filename in files:
            generated = staging/filename
            source = generated if generated.exists() else SOURCE/filename
            assert source.is_file(), source
            catalog["sources"][filename] = source_metadata(source)
            canonical = SOURCE/filename
            runtime = RUNTIME/filename
            canonical.parent.mkdir(parents=True, exist_ok=True)
            runtime.parent.mkdir(parents=True, exist_ok=True)
            if generated.exists():
                shutil.copyfile(generated, canonical)
            shutil.copyfile(canonical, runtime)
        write_json(SOURCE/"dragon-jugable.json", catalog)
        write_json(RUNTIME/"dragon-jugable.json", catalog)
    print(f"BITU_DRAGON_REGISTER_OK:96 registros conservados,180 fotogramas nuevos,396 nombres;{len(jobs)}atlas nativos")


if __name__ == "__main__":
    main()
