"""Mide los PNG nuevos sin editar imágenes; copia sus bytes al juego."""
import hashlib
import json
import shutil
from pathlib import Path
import numpy as np
from PIL import Image
from scipy.ndimage import find_objects, label, distance_transform_edt

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "assets/personajes/dragon"
TARGET = ROOT / "prueba/assets/personajes/dragon"
DIRS = ["S", "SW", "W", "NW", "N", "NE", "E", "SE"]

def boxes(data, columns):
    parts, _ = label(data[:, :, 3] > 128, np.ones((3, 3)))
    counts = np.bincount(parts.ravel())
    found = []
    for index, region in enumerate(find_objects(parts), 1):
        if region is not None and counts[index] > 500:
            y, x = region
            other = np.unique(parts[region])
            assert not any(i != index and i != 0 and counts[i] > 500 for i in other), "Dibujo vecino dentro del recorte"
            found.append([x.start, y.start, x.stop-x.start, y.stop-y.start])
    found.sort(key=lambda b: b[1])
    return [b for row in range(len(found)//columns)
            for b in sorted(found[row*columns:(row+1)*columns], key=lambda b: b[0])]

def nearest(data, region, point, metal=False):
    x, y, w, h = region
    patch = data[y:y+h, x:x+w]
    mask = patch[:, :, 3] > 128
    if metal:
        rgb = patch[:, :, :3].astype(int)
        mask &= (rgb.max(2)-rgb.min(2) < 40) & (rgb.min(2) > 70)
    ys, xs = np.where(mask)
    distances = (xs+x-point[0])**2+(ys+y-point[1])**2
    i = np.argmin(distances)
    result = [int(xs[i]+x), int(ys[i]+y)]
    if metal:
        assert distances[i] < 100, (point, result, "Contacto fuera del metal")
    return result

def anatomy(data, region):
    x, y, w, h = region
    patch = data[y:y+h, x:x+w]
    r, g, b = [patch[:, :, i].astype(int) for i in range(3)]
    blue = (patch[:, :, 3] > 128) & (b > r+12) & (b > g)
    ys, xs = np.where(blue)
    band = (ys > h*.4) & (ys < h*.65)
    hip = int(np.median(xs[band] if band.any() else xs))+x
    return hip, int(ys.min())+y

def hand(data, region, raised=False):
    x, y, w, h = region
    patch = data[y:y+h, x:x+w]
    r, g, b = [patch[:, :, i].astype(int) for i in range(3)]
    opaque = patch[:, :, 3] > 128
    cream = opaque & (r > 160) & (g > 125) & (b > 85) & (r > g+8) & (g > b+8)
    wood = opaque & (r > g+25) & (r < g+85) & (g > 65) & (g < 160) & (g > b+15) & (g < b+55)
    yy = np.indices(cream.shape)[0]
    cream &= yy < h*.55 if raised else (yy > h*.43) & (yy < h*.8)
    if not cream.any() or not wood.any():
        return nearest(data, region, [x+w*.5, y+h*.65])
    distance = distance_transform_edt(~wood)
    distance[~cream] = np.inf
    py, px = np.unravel_index(np.argmin(distance), distance.shape)
    return [int(px+x), int(py+y)]

def build_catalog():
    registration = json.loads((SOURCE / "registro-fuentes.json").read_text())
    images = {name: np.array(Image.open(SOURCE/name).convert("RGBA")) for name in registration["sources"]}
    regions = {name: boxes(images[name], spec["columns"]) for name, spec in registration["sources"].items()}
    frames = {}
    def add(pose, direction, filename, index, factor, anchor_y=None, anchor=None, point=None):
        data = images[filename]
        region = regions[filename][index]
        x, y, w, h = region
        hip, blue_top = anatomy(data, region)
        head_top = y if pose in ["reposo", "sin-equipo", "arrodillado", "levantar"] or pose.startswith(("andar", "paso", "sprint")) else max(y, blue_top-round(h*.06))
        support = anchor if anchor is not None else [hip, anchor_y if anchor_y is not None else y+h-(round(h*.07) if direction in [3, 4, 5] else 0)]
        palm = hand(data, region, pose.startswith("cargar"))
        herbal = pose in ["arrodillado", "levantar"]
        if herbal:
            palm = nearest(data, region, registration["herbal_hands"][pose][direction])
        frame = {"file": filename, "region": region, "anchor": support,
                 "scale": factor, "hand": palm, "other_hand": palm,
                 "body_bounds_px": [x, head_top, w, support[1]-head_top],
                 "body_height_px": support[1]-head_top,
                 "presentation_height_px": (support[1]-head_top)*factor,
                 "tool_behind": direction in [3, 4, 5],
                 "baked_tool": pose != "sin-equipo" and not herbal}
        if herbal:
            frame["hand_cover"] = [palm[0]-5, palm[1]-5, 10, 10]
        if pose in ["reposo", "andar-a", "paso-a", "andar-b", "paso-b"] or pose.startswith("sprint"):
            frame["carry_orientation"] = "punta-arriba-filo-abajo"
        if point is not None:
            action = "talar" if pose == "golpe-talar" else "minar"
            frame.update(contacts={action: nearest(data, region, point, metal=True)},
                         working_end="axe_edge" if action == "talar" else "pick_tip", contact_reference=point)
        frames[f"{pose}-{DIRS[direction]}"] = frame
    for direction in range(8):
        for pose in ["reposo", "sin-equipo"]:
            name = pose+".png"
            top = regions[name][direction][1]
            ground = registration["feet_y"][pose][direction]
            add(pose, direction, name, direction, 80/(ground-top), anchor_y=ground)
        for kind, poses in [("marcha", ["andar-a", "paso-a", "andar-b", "paso-b"]),
                            ("sprint", ["sprint-a", "sprint-paso-a", "sprint-b", "sprint-paso-b"])]:
            name = kind+".png"
            first = regions[name][direction*4]
            height = registration["feet_y"]["marcha"][direction]-regions["marcha.png"][direction*4][1] if kind == "marcha" else first[3]-(round(first[3]*.07) if direction in [3, 4, 5] else 0)
            factor = 80/height
            for phase, pose in enumerate(poses):
                top = regions[name][direction*4+phase][1]
                add(pose, direction, name, direction*4+phase, factor, anchor_y=top+height)
        for kind, suffix in [("mineria", ""), ("tala", "-talar")]:
            name = kind+".png"
            first = regions[name][direction*4]
            height = first[3]-(round(first[3]*.07) if direction in [3, 4, 5] else 0)
            factor = 80/height
            for phase, pose in [(0, "medio"), (1, "cargar"), (3, "recuperar")]:
                add(pose+suffix, direction, name, direction*4+phase, factor)
        for action, pose in [("minar", "golpe"), ("talar", "golpe-talar")]:
            add(pose, direction, f"impacto-{action}.png", direction, .26,
                anchor=registration["impact_feet"][action][direction], point=registration["impact_points"][action][direction])
        add("arrodillado", direction, "arrodillado.png", direction, .285)
        add("levantar", direction, "levantar.png", direction, .26)
    assert len(frames) == 160
    sources = {name: {"size_px": list(Image.open(SOURCE/name).size),
                      "sha256": hashlib.sha256((SOURCE/name).read_bytes()).hexdigest()}
               for name in images}
    return {"version": 1, "art_revision": registration.get("art_revision", "reinicio-pixel-npc-2026-10-10"), "height_px": 80,
            "directions": DIRS, "sources": sources, "frames": frames,
            "notes": registration["notes"]}

def main():
    catalog = build_catalog()
    text = json.dumps(catalog, ensure_ascii=False, indent=2)+"\n"
    (SOURCE/"dragon-jugable.json").write_text(text)
    TARGET.mkdir(parents=True, exist_ok=True)
    for name in catalog["sources"]:
        shutil.copyfile(SOURCE/name, TARGET/name)
    (TARGET/"dragon-jugable.json").write_text(text)
    print("160 poses nuevas registradas; diez PNG copiados sin editar sus bytes.")

if __name__ == "__main__":
    main()
