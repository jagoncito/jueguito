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
    registration = json.loads((SOURCE / 'registro-fuentes.json').read_text())
    images = {name: np.array(Image.open(SOURCE/name).convert('RGBA')) for name in registration['sources']}
    regions = {name: spec['regions'] if 'regions' in spec else boxes(images[name],spec['columns']) for name,spec in registration['sources'].items()}
    for name,spec in registration['sources'].items():
        if 'regions' not in spec: assert len(regions[name]) == spec.get('count',8 if spec['columns']==2 else 8*spec['columns']), (name,len(regions[name]))
    frames = dict(registration['preserved_frames'])
    def support(name,index,direction):
        x,y,w,h = regions[name][index]
        data = images[name]; p = data[y:y+h,x:x+w]; rgb = p[:,:,:3].astype(int)
        hip,_ = anatomy(data,regions[name][index])
        cream = (p[:,:,3]>128)&(rgb[:,:,0]>150)&(rgb[:,:,1]>120)&(rgb[:,:,0]-rgb[:,:,2]>25)&(rgb[:,:,1]-rgb[:,:,2]>12)
        yy,xx = np.indices(cream.shape)
        cream &= (yy>h*.65)&(abs(xx+x-hip)<w*.32)
        if direction in [3,4,5]: cream &= abs(xx+x-hip)>w*.055
        ys,xs = np.where(cream)
        feet = int(ys.max())+y+1 if len(ys) else y+h
        return [hip,feet]
    def add(pose,direction,name,index,factor,anchor_y=None,mirror=False,action=None):
        region = regions[name][index]; x,y,w,h = region
        anchor = support(name,index,direction)
        if anchor_y is not None: anchor[1] = anchor_y
        palm = hand(images[name],region,pose.startswith('cargar') or pose=='pesca-cargar')
        neutral = name in ['reposo.png','marcha.png','sprint.png','zarpazo.png']
        frame = {'file':name,'region':region,'anchor':anchor,'scale':factor,'hand':palm,'other_hand':palm,
                 'body_bounds_px':[x,y,w,anchor[1]-y],'body_height_px':anchor[1]-y,
                 'presentation_height_px':(anchor[1]-y)*factor,'tool_behind':direction in [3,4,5],
                 'baked_tool':not neutral,'mirror_x':mirror}
        if action:
            source_direction = index//4
            point = registration['impact_points'][action][source_direction]
            frame.update(contacts={action:nearest(images[name],region,point,metal=True)},working_end='axe_edge' if action=='talar' else 'pick_tip',contact_reference=point)
        if name.startswith('pesca'):
            reference=registration['fishing_north_tip'] if name=='pesca-norte.png' else registration['fishing_tips'][pose][index//3]
            tip=nearest(images[name],region,reference)
            assert sum((tip[i]-reference[i])**2 for i in range(2))<144, ('Punta de caña fuera de referencia',pose,direction,tip,reference)
            frame['contacts']={'sedal':tip}
            frame['rod_tip_reference']=reference
        frames[pose+'-'+DIRS[direction]]=frame
    for direction in range(8):
        anchor=support('reposo.png',direction,direction); top=regions['reposo.png'][direction][1]
        for pose in ['reposo','sin-equipo']: add(pose,direction,'reposo.png',direction,80/(anchor[1]-top))
        for name,poses in [('marcha.png',['andar-a','paso-a','andar-b','paso-b']),('sprint.png',['sprint-a','sprint-paso-a','sprint-b','sprint-paso-b'])]:
            first=direction*4; height=support(name,first,direction)[1]-regions[name][first][1]
            for phase,pose in enumerate(poses):
                add(pose,direction,name,first+phase,80/height,anchor_y=regions[name][first+phase][1]+height)
        for name,poses,action in [('tala.png',['medio-talar','cargar-talar','golpe-talar','recuperar-talar'],'talar'),('mineria.png',['medio','cargar','golpe','recuperar'],'minar')]:
            # Norte/diagonal y perfil opuestos se proyectan de una vista coherente
            # cuando el generador cambia la orientación entre fotogramas.
            projected=3 if direction==5 else direction
            for phase,pose in enumerate(poses):
                source_direction=2 if direction==6 and phase==1 else (1 if direction==7 and phase==1 else projected)
                mirror=direction==5 or (direction in [6,7] and phase==1)
                first=source_direction*4
                base=regions[name][first]; height=support(name,first,source_direction)[1]-base[1]
                add(pose,direction,name,first+phase,80/height,mirror=mirror,action=action if phase==2 else None)
        name='zarpazo.png'
        for phase,pose in enumerate(['zarpazo-cargar','zarpazo-golpe','zarpazo-seguir','zarpazo-recuperar']):
            projected=3 if direction in [3,5] else direction
            first=projected*4; height=support(name,first,projected)[1]-regions[name][first][1]
            add(pose,direction,name,first+phase,80/height,mirror=direction==3)
        name='pesca.png'
        for phase,pose in enumerate(['pesca-cargar','pesca-esperar','pesca-recoger']):
            projected=7 if direction==1 else (6 if direction==2 else (5 if direction==3 else direction))
            first=projected*3
            mirror=direction in [1,2,3]
            # La caña eleva el recorte, no la altura anatómica del cuerpo.
            region=regions[name][first+1]; x,y,w,h=region
            hip,blue_top=anatomy(images[name],region)
            height=support(name,first+1,direction)[1]-(blue_top-round(h*.055))
            add(pose,direction,'pesca-norte.png' if direction==4 and phase==2 else name,0 if direction==4 and phase==2 else first+phase,80/height,mirror=mirror)
    assert len(frames)==216
    sources={name:{'size_px':list(Image.open(SOURCE/name).size),'sha256':hashlib.sha256((SOURCE/name).read_bytes()).hexdigest()} for name in images}
    return {'version':2,'art_revision':registration['art_revision'],'height_px':80,'directions':DIRS,'sources':sources,'frames':frames,'notes':registration['notes']}
def main():
    catalog = build_catalog()
    text = json.dumps(catalog, ensure_ascii=False, indent=2)+"\n"
    (SOURCE/"dragon-jugable.json").write_text(text)
    TARGET.mkdir(parents=True, exist_ok=True)
    for name in catalog["sources"]:
        shutil.copyfile(SOURCE/name, TARGET/name)
    (TARGET/"dragon-jugable.json").write_text(text)
    print("216 poses registradas; diez PNG copiados sin editar sus bytes.")

if __name__ == "__main__":
    main()
