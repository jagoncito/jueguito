"""Audita píxeles de los atlas nuevos; no edita imágenes.

Comprueba altura real de cresta y escala constante de cada ciclo. La anchura
superior incluye cresta/hocico y se informa para revisión, no como aprobación.
"""
import json
from pathlib import Path
import numpy as np
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
SOURCE=ROOT/'assets/personajes/dragon'

def audit():
    catalog=json.loads((SOURCE/'dragon-jugable.json').read_text())
    images={name:np.array(Image.open(SOURCE/name)) for name in catalog['sources']}
    report={}
    for direction in catalog['directions']:
        result={}
        for cycle,poses in [('marcha',['reposo','andar-a','paso-a','andar-b','paso-b']),('sprint',['sprint-a','sprint-paso-a','sprint-b','sprint-paso-b'])]:
            widths=[];tops=[];scales=[]
            for pose in poses:
                frame=catalog['frames'][pose+'-'+direction]
                x,y,w,h=frame['region'];patch=images[frame['file']][y:y+h,x:x+w]
                ys,xs=np.where(patch[:,:,3]>128)
                top=(int(ys.min())+y-frame['anchor'][1])*frame['scale']
                assert abs(top+80)<.01,(pose,direction,top)
                upper=patch[:round(frame['body_height_px']*.24),:,3]>128
                ys,xs=np.where(upper)
                widths.append(round(float(xs.max()-xs.min()+1)*frame['scale'],2))
                tops.append(round(top,2));scales.append(frame['scale'])
            assert len(set(scales[1:] if cycle=='marcha' else scales))==1
            result[cycle]={'crest_top_px':tops,'upper_silhouette_width_px':widths,'one_scale_per_cycle':True}
        report[direction]=result
    return report

if __name__=='__main__':
    print(json.dumps(audit(),ensure_ascii=False,indent=2))
    print('BITU_DRAGON_ANATOMY_OK')
