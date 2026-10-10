"""Registra los personajes existentes para la comparación en la granja.

Solo copia PNG originales y sus recortes; no dibuja ni modifica imágenes.
"""
import hashlib
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "prueba/assets/personajes/comparacion"
DIRECTIONS = ["S", "SW", "W", "NW", "N", "NE", "E", "SE"]


def build():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    characters = []
    sources = {}

    def copy_source(path):
        original = ROOT / path
        shutil.copyfile(original, OUTPUT / original.name)
        sources[original.name] = {
            "repository_path": path,
            "sha256": hashlib.sha256(original.read_bytes()).hexdigest(),
            "bytes": original.stat().st_size,
        }
        return original.name

    for who, label in [("flavia", "Flavia"), ("unamahloni", "Unamahloni")]:
        source = json.loads((ROOT / f"assets/personajes/{who}/equipamiento/equipamiento.json").read_text())
        names = {}
        frames = {}
        for frame in source["frames"]:
            if frame["action"] != "walk":
                continue
            key = frame["source"]
            if key not in names:
                names[key] = copy_source(source["sources"][key]["repository_path"])
                assert sources[names[key]]["sha256"] == source["sources"][key]["sha256"]
            frames[f'{frame["direction"]}-{frame["phase"]}'] = {
                "file": names[key], "region": frame["region_px"],
                "anchor": frame["foot_anchor_px"], "scale": frame["source_to_game_scale"],
            }
        for direction in DIRECTIONS:
            scales = {frames[f"{direction}-{phase}"]["scale"] for phase in range(4)}
            assert len(scales) == 1, f"Escala de marcha variable: {who}/{direction}"
        characters.append({"id": who, "label": label, "height_px": 80, "motion": "walk", "frames": frames})

    for who, label, height, path in [
        ("cocinero", "Cocinero / pescador", 80, "assets/personajes/maestros-bitu/cocinero-libre-atlas.png"),
        ("enano", "Minero / herrero", 64, "assets/personajes/maestros-bitu/enano-libre-atlas.png"),
        ("elfa-museo", "Elfa del museo", 80, "assets/personajes/pareja-museo/elfa-museo-atlas.png"),
        ("comerciante", "Comerciante", 84, "assets/personajes/pareja-museo/comerciante-atlas.png"),
    ]:
        name = copy_source(path)
        frames = {f"{direction}-0": {
            "file": name, "region": [index % 4 * 128, index // 4 * 128, 128, 128],
            "anchor": [64, 112], "scale": 1.0,
        } for index, direction in enumerate(DIRECTIONS)}
        characters.append({"id": who, "label": label, "height_px": height, "motion": "turn", "frames": frames})
    (OUTPUT / "personajes.json").write_text(json.dumps({
        "version": 1, "directions": DIRECTIONS, "sources": sources, "characters": characters,
        "scope": "Comparación visual temporal; caminar solo donde ya existen fotogramas de marcha.",
    }, ensure_ascii=False, indent=2) + "\n")
    print(f"BITU_NPCS_REGISTERED: {len(characters)} personajes, {len(sources)} PNG intactos")


if __name__ == "__main__":
    build()
