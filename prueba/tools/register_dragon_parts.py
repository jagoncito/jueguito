"""Registra UV del PNG existente; no modifica imágenes. Requiere Pillow, NumPy y SciPy."""
from pathlib import Path
import json,shutil,hashlib
import numpy as np
from PIL import Image
from scipy.ndimage import label,find_objects
R=Path(__file__).resolve().parents[2];source=R/'assets/personajes/dragon/piezas-articuladas.png'
x=np.array(Image.open(source));l,n=label(x[:,:,3]>128,np.ones((3,3)));c=np.bincount(l.ravel());found=[]
for i,s in enumerate(find_objects(l),1):
 if s is not None and c[i]>500:
  yy,xx=s;found.append([xx.start,yy.start,xx.stop-xx.start,yy.stop-yy.start])
found.sort(key=lambda x:x[1]);regions=[b for k in range(5) for b in sorted(found[k*6:k*6+6],key=lambda x:x[0])];assert len(regions)==30
shutil.copyfile(source,R/'prueba/assets/personajes/dragon/piezas-articuladas.png')
def tris(b):
 x,y,w,h=b
 component=int(l[y+h//2,x+w//2])
 if component==0:
  values,counts=np.unique(l[y:y+h,x:x+w],return_counts=True)
  component=int(values[1:][counts[1:].argmax()]) if values[0]==0 else int(values[counts.argmax()])
 points=[]
 for yy in range(y,y+h):
  mask=(l[yy,x:x+w]==component);edges=np.diff(np.r_[False,mask,False].astype(int));starts=np.where(edges==1)[0];ends=np.where(edges==-1)[0]
  for a,b in zip(starts,ends):
   a+=x;b+=x;points.extend([[int(a),yy],[int(b),yy],[int(b),yy+1],[int(a),yy],[int(b),yy+1],[int(a),yy+1]])
 return points
def part(upper,lower,start,ground,bend,kind,foot=None):
 result=dict(clean=True,upper_triangles=tris(upper),lower_triangles=tris(lower),start=start,bend=bend,width_factor=1.4 if kind=='arm' else 1.6,lower_width_factor=1.4 if kind=='arm' else 2.0,length_a=10.0 if kind=='arm' else 8.0,length_b=10.0 if kind=='arm' else 8.0)
 for key,b in [('upper',upper),('lower',lower)]:
  x,y,w,h=b;result[key+'_pivot']=[x+w*.5,y+h*.12];result[key+'_end']=[x+w*.5,y+h*(.85 if kind=='arm' and key=='lower' else .90)]
 if kind=='leg':
  result.update(ground=ground,sole_offset=[0,9.24]);x,y,w,h=foot;result.update(foot_triangles=tris(foot),foot_pivot=[x+w*.5,y+h*.12],foot_scale=10.5/h)
 else:result['end']=[start[0],start[1]+17]
 return result
catalog=json.loads((R/'assets/personajes/dragon/dragon-jugable.json').read_text())
original=np.array(Image.open(R/'assets/personajes/dragon/reposo.png'))
views={}
for k,d in enumerate(['S','SW','W','NW','N']):
 body,upper,lower,thigh,shin,foot=regions[k*6:k*6+6]
 center=[-5.1,-3.6,-4.2,-2.1,0][k];x,y,w,h=body;f=.34
 # The head retains its measured height; the trunk is clean, with no filling rectangles.
 old=catalog['frames']['reposo-'+d];ox,oy,ow,oh=old['region']
 alpha=original[oy:oy+round(20/old['scale']),ox:ox+ow,3]/255
 original_center=((np.arange(ow)*alpha.sum(0)).sum()/alpha.sum()+ox-old['anchor'][0])*old['scale']
 component=int(l[y+h//2,x+w//2])
 if component==0:
  values,counts=np.unique(l[y:y+h,x:x+w],return_counts=True)
  component=int(values[1:][counts[1:].argmax()]) if values[0]==0 else int(values[counts.argmax()])
 alpha=np.array(Image.open(source))[y:y+round(20/f),x:x+w,3]/255*(l[y:y+round(20/f),x:x+w]==component)
 source_center=(np.arange(w)*alpha.sum(0)).sum()/alpha.sum()+x
 pivot=[float(source_center-original_center/f),y+80/f]
 spread=6 if d in ['S','N'] else 2.5
 views[d]=dict(body_triangles=tris(body),anchor=pivot,scale=f,repair_triangles=[],arms=[part(upper,lower,[center+(4 if d=='NW' else -7),-37],None,-1 if d=='NW' else 1,'arm'),part(upper,lower,[center+(-7 if d=='NW' else 7),-37],None,1 if d=='NW' else -1,'arm')],legs=[part(thigh,shin,[center-spread,-22],[center-spread,0],1,'leg',foot),part(thigh,shin,[center+spread,-22],[center+spread,0],-1 if d in ['S','N'] else 1,'leg',foot)])
data=json.dumps(dict(version=3,renderer='rigid_clean_parts',source='piezas-articuladas.png',source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),views=views),ensure_ascii=False,separators=(",",":"))+'\n'
for directory in [R/'assets/personajes/dragon',R/'prueba/assets/personajes/dragon']:(directory/'articulaciones.json').write_text(data)
print('Clean connected artwork, metadata:',len(data.encode()),'bytes')
