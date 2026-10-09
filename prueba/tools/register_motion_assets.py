"""Registros medidos de animación. No modifica, recorta ni redimensiona PNG.

Emite los catálogos JSON para revisión; los dibujos originales se conservan.
Las coordenadas de palmas/contactos se miden sobre cada proyección fuente.
"""
import json
from pathlib import Path
from PIL import Image
import numpy as np
from scipy.ndimage import label, find_objects

ROOT = Path(__file__).resolve().parents[2]
DIRS = ['S', 'SW', 'W', 'NW', 'N', 'NE', 'E', 'SE']

def regions(path):
    alpha = np.asarray(Image.open(path))[:, :, 3]
    boxes = []
    for obj in find_objects(label(alpha > 128)[0]):
        if obj is None:
            continue
        y, x = obj
        if (x.stop-x.start)*(y.stop-y.start) > 1000:
            boxes.append([x.start, y.start, x.stop-x.start, y.stop-y.start])
    # Cada fila está separada por un amplio margen transparente.
    rows = []
    for box in sorted(boxes, key=lambda b: b[1]):
        if not rows or abs(box[1]-rows[-1][0][1]) > 70:
            rows.append([])
        rows[-1].append(box)
    return [b for row in rows for b in sorted(row, key=lambda b: b[0])]

def main():
    dragon_dir = ROOT/'assets/personajes/dragon-avatar'
    catalog = json.loads((dragon_dir/'dragon-jugable.json').read_text())
    catalog['version'] = 3
    catalog['notes'] = [
        'Ocho vistas completas, cuatro fases distintas de marcha por dirección.',
        'Palmas medidas por fotograma; hand_cover recorta dedos solo al presentar en Godot.',
        'PNG intactos, escalado uniforme; cuerpo trasero orientado hacia el avance.',
        'La elevación E reutiliza la pose baja de perfil correcto.',
    ]
    frames = {k:v for k,v in catalog['frames'].items()
              if not k.startswith(('andar-', 'paso'))}
    palms = {
        'reposo': [(114,357),(494,359),(900,403),(1235,375),(295,833),(712,821),(966,855),(1310,848)],
        'medio': [(155,794),(425,794),(709,792),(1061,757),(226,1087),(581,1059),(887,1071),(1220,1066)],
        'cargar': [(114,170),(387,179),(669,149),(1143,165),(270,421),(582,437),(889,438),(1204,449)],
        'golpe': [(175,831),(449,833),(698,834),(1010,827),(251,1080),(569,1100),(877,1103),(1189,1105)],
        'arrodillado': [(112,237),(455,232),(813,231),(1226,230),(280,436),(678,458),(1048,466),(1449,464)],
        'levantar': [(113,664),(468,672),(815,673),(1223,669),(277,893),(677,890),(1048,466),(1430,929)],
    }
    second = {
        'reposo': [(281,386),(630,397),(846,360),(1434,354),(101,839),(581,825),(1070,818),(1465,838)],
        'medio': [(157,754),(430,750),(710,756),(1065,744),(225,1060),(569,1036),(879,1052),(1225,1047)],
        'cargar': [(121,148),(396,147),(684,118),(1133,145),(270,410),(565,415),(871,416),(1188,429)],
        'golpe': [(200,824),(427,820),(719,838),(1025,822),(247,1070),(566,1093),(896,1085),(1170,1115)],
        'arrodillado': [(198,236),(552,236),(887,233),(1233,216),(270,425),(666,448),(1036,453),(1438,454)],
        'levantar': [(172,694),(513,707),(829,654),(1236,658),(279,912),(663,885),(1036,453),(1419,912)],
    }
    for key, frame in frames.items():
        pose, direction = key.rsplit('-', 1)
        index = DIRS.index(direction)
        frame['hand'] = list(palms[pose][index])
        frame['other_hand'] = list(second[pose][index])
        frame['tool_behind'] = index in [3,4,5]
        w,h = (32,28) if pose == 'reposo' else (18,16)
        x,y = frame['hand']
        frame['hand_cover'] = [x-w//2,y-h//2,w,h]
        if index == 4 and pose in ['medio','golpe']:
            frame['hand_cover'] = []  # Las manos están detrás del torso.
    walks = [
        ('dragon-marcha-frontal.png', ['S','SW','E','SE'],
         [[(151,206),(441,202),(775,193),(1050,204)],[(129,485),(428,491),(750,496),(1051,496)],
          [(218,783),(535,782),(850,786),(1167,782)],[(205,1073),(518,1078),(833,1077),(1147,1071)]],
         [[208,494,811,1106],[202,494,808,1115],[207,519,831,1145],[220,535,850,1165]]),
        ('dragon-marcha-trasera.png', ['W','NE','N','NW'],
         [[(180,216),(498,216),(805,217),(1141,215)],[(267,479),(596,479),(905,480),(1235,476)],
          [(231,764),(558,771),(872,770),(1201,776)],[(83,1051),(419,1057),(739,1055),(1072,1057)]],
         [[168,492,803,1140],[215,539,847,1179],[176,500,813,1140],[167,489,813,1135]]),
    ]
    for filename, directions, hands, ground_x in walks:
        boxes = regions(dragon_dir/filename)
        assert len(boxes) == 16, (filename,boxes)
        for row, direction in enumerate(directions):
            for col, pose in enumerate(['andar-a','paso-a','andar-b','paso-b']):
                box = boxes[row*4+col]
                x,y = hands[row][col]
                frames[f'{pose}-{direction}'] = {
                    'file':filename,'region':box,'anchor':[ground_x[row][col],box[1]+box[3]-2],
                    'scale':0.31,'hand':[x,y],'other_hand':[x,y-20],
                    'hand_cover':[x-10,y-9,20,18],'tool_behind':direction in ['NW','N','NE'],
                }
    # Los apoyos frontales/traseros opuestos se redibujaron aparte: alternar
    # realmente la pierna de apoyo, no solo cambiar el brazo o el sombreado.
    filename = 'dragon-marcha-apoyos.png'
    boxes = regions(dragon_dir/filename)
    for key, i, hand, ground_x, factor in [
        ('andar-b-S',0,(318,380),413,0.166),
        ('paso-b-S',1,(813,376),909,0.166),
        ('andar-b-N',2,(529,934),410,0.169),
    ]:
        box = boxes[i]
        x,y = hand
        frames[key] = {'file':filename,'region':box,
                       'anchor':[ground_x,box[1]+box[3]-2],'scale':factor,
                       'hand':[x,y],'other_hand':[x,y-35],
                       'hand_cover':[x-19,y-17,38,34], 'tool_behind':key.endswith('-N')}
    catalog['frames'] = frames
    outputs = {'assets/personajes/dragon-avatar/dragon-jugable.json':catalog}
    filename = 'assets/herramientas/pico-hacha/pico-hacha-vistas.png'
    boxes = regions(ROOT/filename)
    grips = [(236,344),(682,344),(1126,344),(1543,344),(239,788),(706,788),(1110,788),(1544,788)]
    tips = [(74,140),(526,158),(1073,175),(1695,154),(402,593),(841,559),(1150,613),(1386,598)]
    axes = [(398,109),(811,100),(1169,90),(1424,115),(75,550),(575,552),(1065,550),(1683,550)]
    views = {}
    assert len(boxes) == 8
    for i, (x,y,w,h) in enumerate(boxes):
        gx,gy = grips[i]
        left,right = gx-24,gx+24
        pieces = {'handle':[left,y,right-left,h]}
        pick_left = tips[i][0] < gx
        pieces['pick' if pick_left else 'axe'] = [x,y,left-x,h]
        pieces['axe' if pick_left else 'pick'] = [right,y,x+w-right,h]
        views[DIRS[i]] = {'region':[x,y,w,h],'grip':[gx,gy],'scale':0.145,
                         'contacts':{'minar':tips[i],'talar':axes[i]},'pieces':pieces}
    outputs[filename.replace('.png','.json')] = {'version':1,'directions':DIRS,'views':views}
    filename = 'assets/herramientas/palin-herborista/palin-vistas.png'
    boxes = regions(ROOT/filename)
    grips = [(248,364),(595,364),(945,364),(1322,364),(246,878),(625,878),(950,878),(1306,878)]
    tips = [(245,20),(628,20),(944,20),(1230,18),(246,521),(541,523),(958,523),(1390,523)]
    assert len(boxes) == 8
    views = {direction:{'region':boxes[i],'grip':grips[i],'tip':tips[i],'scale':0.088}
             for i,direction in enumerate(DIRS)}
    outputs[filename.replace('.png','.json')] = {'version':1,'directions':DIRS,'views':views}
    print(json.dumps(outputs, ensure_ascii=False))

if __name__ == '__main__':
    main()
