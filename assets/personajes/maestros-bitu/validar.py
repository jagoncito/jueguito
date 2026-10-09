"""Validación de solo lectura de las fuentes, fotogramas y atlas."""
from pathlib import Path
from PIL import Image
import json,hashlib
r=Path(__file__).resolve().parent;data=json.loads((r/'sprites.json').read_text());total=0
assert data['frame_px']==[128,128] and data['foot_anchor_px']==[64,112]
for name,char in data['characters'].items():
 assert len(char['states'])==4
 for state,entry in char['states'].items():
  source=r/entry['source'];assert hashlib.sha256(source.read_bytes()).hexdigest()==entry['source_sha256']
  atlas_path=r/entry['atlas'];assert hashlib.sha256(atlas_path.read_bytes()).hexdigest()==entry['atlas_sha256']
  atlas=Image.open(atlas_path);assert atlas.mode=='RGBA' and atlas.size==(512,256)
  assert len(entry['frames'])==8
  for i,frame in enumerate(entry['frames']):
   p=r/frame['file'];assert hashlib.sha256(p.read_bytes()).hexdigest()==frame['sha256']
   im=Image.open(p);assert im.size==(128,128) and im.mode=='RGBA'
   assert set(im.getchannel('A').get_flattened_data())=={0,255}
   box=im.getbbox();assert box and box[0]>0 and box[1]>0 and box[2]<128 and box[3]==112
   assert char['height_max_px']-6<=box[3]-box[1]<=char['height_max_px'],(name,state,frame['direction'],box)
   assert atlas.crop((i%4*128,i//4*128,i%4*128+128,i//4*128+128)).tobytes()==im.tobytes()
   assert frame['direction']==data['directions'][i]
   assert entry['source_direction_order'][frame['source_index']]==frame['direction']
   total+=1
 print(name,'32 poses, altura máxima',char['height_max_px'],'px')
assert total==64
print('BITU_MASTERS_ASSETS_OK')
