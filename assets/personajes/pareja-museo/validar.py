"""Comprueba fuentes, sprites y atlas sin modificar las imágenes."""
from pathlib import Path
from PIL import Image
import json,hashlib
r=Path(__file__).resolve().parent
catalogue=json.loads((r/'sprites.json').read_text())
assert catalogue['frame_px']==[128,128]
assert catalogue['foot_anchor_px']==[64,112]
for name,char in catalogue['characters'].items():
 source=r/char['source'];assert hashlib.sha256(source.read_bytes()).hexdigest()==char['source_sha256']
 atlas_path=r/char['atlas'];assert hashlib.sha256(atlas_path.read_bytes()).hexdigest()==char['atlas_sha256']
 atlas=Image.open(atlas_path);assert atlas.size==(512,256) and atlas.mode=='RGBA'
 seen=set()
 for i,frame in enumerate(char['frames']):
  p=r/frame['file'];assert hashlib.sha256(p.read_bytes()).hexdigest()==frame['sha256']
  im=Image.open(p);assert im.mode=='RGBA' and im.size==(128,128)
  assert set(im.getchannel('A').getdata())=={0,255}
  box=im.getbbox();assert box and box[0]>0 and box[1]>0 and box[2]<128 and box[3]==112
  assert 74<=box[3]-box[1]<=char['height_max_px']
  assert atlas.crop((i%4*128,i//4*128,i%4*128+128,i//4*128+128)).tobytes()==im.tobytes()
  assert frame['direction']==catalogue['directions'][i]
  assert frame['sha256'] not in seen;seen.add(frame['sha256'])
 print(name, len(seen),'vistas, altura máxima',char['height_max_px'],'px')
print('BITU_COUPLE_ASSETS_OK')
