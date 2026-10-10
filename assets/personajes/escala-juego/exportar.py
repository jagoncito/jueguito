"""Exportación técnica a píxeles de juego. Fuentes originales intactas."""
import asyncio,base64,hashlib,json,shutil
from pathlib import Path
from playwright.async_api import async_playwright
ROOT=Path(__file__).resolve().parents[3]
OUT=Path(__file__).resolve().parent
DIRS=['S','SW','W','NW','N','NE','E','SE']
LOCAL=['s','so','o','no','n','ne','e','se']
def read(p):return json.loads(p.read_text())
def specs():
 return read(OUT/"fuentes.json")
RENDER=r'''async ({url,f})=>{
const im=new Image();im.src=url;await im.decode();const [rx,ry,rw,rh]=f.region;
const c=document.createElement('canvas');c.width=rw;c.height=rh;const ctx=c.getContext('2d');ctx.drawImage(im,rx,ry,rw,rh,0,0,rw,rh);let p=ctx.getImageData(0,0,rw,rh);
if(f.clean){const visited=new Uint8Array(rw*rh);for(let i=0;i<visited.length;i++){if(visited[i]||p.data[i*4+3]<=20)continue;let stack=[i],comp=[];visited[i]=1;while(stack.length){const j=stack.pop();comp.push(j);for(const k of [j%rw?j-1:-1,j%rw<rw-1?j+1:-1,j-rw,j+rw])if(k>=0&&k<visited.length&&!visited[k]&&p.data[k*4+3]>20){visited[k]=1;stack.push(k);}}if(comp.length<=240)for(const j of comp)p.data[j*4+3]=0;}}
let x0=rw,y0=rh,x1=-1,y1=-1;for(let y=0;y<rh;y++)for(let x=0;x<rw;x++)if(p.data[(y*rw+x)*4+3]>=128){x0=Math.min(x0,x);y0=Math.min(y0,y);x1=Math.max(x1,x);y1=Math.max(y1,y);}
if(x1<0)throw Error('Empty '+f.id);ctx.putImageData(p,0,0);
const h=y1-y0+1,w=x1-x0+1,s=f.height/h,dw=Math.round(w*s),dh=f.height;
// Uniform design scale, integer destination bounds. Source support stays horizontally registered.
let dx=Math.round(64+(rx+x0-f.foot[0])*s),dy=112-dh;
if(dx<1||dx+dw>127)throw Error('Clipped '+f.id+' width '+dw+' origin '+dx);
const n=document.createElement('canvas');n.width=128;n.height=128;const nc=n.getContext('2d');nc.imageSmoothingEnabled=false;nc.drawImage(c,x0,y0,w,h,dx,dy,dw,dh);p=nc.getImageData(0,0,128,128);
let bottom=0;for(let y=0;y<128;y++)for(let x=0;x<128;x++){let k=(y*128+x)*4;if(p.data[k+3]>=128){p.data[k+3]=255;bottom=Math.max(bottom,y+1);}else p.data[k]=p.data[k+1]=p.data[k+2]=p.data[k+3]=0;}nc.putImageData(p,0,0);
const shift=112-bottom;if(shift){const tmp=document.createElement('canvas');tmp.width=128;tmp.height=128;tmp.getContext('2d').drawImage(n,0,shift);nc.clearRect(0,0,128,128);nc.drawImage(tmp,0,0);dy+=shift;}
const transform=point=>[dx+(point[0]-rx-x0)*dw/w,dy+(point[1]-ry-y0)*dh/h];
const hands={};for(const [key,value]of Object.entries(f.hands))hands[key]={...value,position_px:transform(value.position_px)};
let cover=null;if(f.hand_cover?.length===4){const [x,y,wc,hc]=f.hand_cover;const a=transform([x,y]),b=transform([x+wc,y+hc]);cover=[Math.floor(a[0]),Math.floor(a[1]),Math.ceil(b[0])-Math.floor(a[0]),Math.ceil(b[1])-Math.floor(a[1])];}
return {png:n.toDataURL('image/png').split(',')[1],hands,hand_cover:cover,source_bbox:[rx+x0,ry+y0,w,h],destination:[dx,dy,dw,dh],source_scale:s};
}'''
ATLAS=r'''async urls=>{const c=document.createElement('canvas');c.width=1024;c.height=1280;const x=c.getContext('2d');for(let i=0;i<urls.length;i++){const im=new Image();im.src=urls[i];await im.decode();x.drawImage(im,i%8*128,Math.floor(i/8)*128);}return c.toDataURL('image/png').split(',')[1];}'''
async def main():
 catalog={'schema_version':1,'frame_px':[128,128],'foot_anchor_px':[64,112],'atlas_px':[1024,1280],'directions':DIRS,'ground_tile_px':[64,32],'filter':'nearest','characters':{}}
 cache={}
 async with async_playwright() as p:
  browser=await p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox','--disable-dev-shm-usage']);page=await browser.new_page()
  for name,ch in specs().items():
   frames=sorted(ch['frames'],key=lambda f:(f['action'],f['phase'],DIRS.index(f['direction'])));entry={'height_px':ch['height_px'],'atlas':f'{name}/atlas.png','frames':[]};urls=[]
   folder=OUT/name;folder.mkdir(exist_ok=True)
   for index,f in enumerate(frames):
    if f['source'] not in cache:
     raw=(ROOT/f['source']).read_bytes();cache[f['source']]='data:image/png;base64,'+base64.b64encode(raw).decode()
    result=await page.evaluate(RENDER,{'url':cache[f['source']],'f':f});raw=base64.b64decode(result.pop('png'));file=f"{name}/{f['id']}.png";(OUT/file).write_bytes(raw);urls.append('data:image/png;base64,'+base64.b64encode(raw).decode())
    entry['frames'].append({**{k:f[k] for k in ['id','action','phase','direction','source']},'file':file,'region':[index%8*128,index//8*128,128,128],'sha256':hashlib.sha256(raw).hexdigest(),'tool_behind':f.get('tool_behind',False),**result})
   (folder/'atlas.png').write_bytes(base64.b64decode(await page.evaluate(ATLAS,urls)));catalog['characters'][name]=entry;print(name,len(frames),flush=True)
  await browser.close()
 (OUT/'sprites.json').write_text(json.dumps(catalog,ensure_ascii=False,indent=2,allow_nan=False)+'\n')
 target=ROOT/'prueba/assets/personajes/escala-juego';target.mkdir(parents=True,exist_ok=True)
 shutil.copy2(OUT/'sprites.json',target/'sprites.json')
 for name in catalog['characters']:
  (target/name).mkdir(exist_ok=True);shutil.copy2(OUT/name/'atlas.png',target/name/'atlas.png')
 print('EXPORT_OK',sum(len(c['frames'])for c in catalog['characters'].values()),flush=True)
if __name__=='__main__':asyncio.run(main())
