import asyncio,base64,json,hashlib
from pathlib import Path
from playwright.async_api import async_playwright
ROOT=Path(__file__).resolve().parent
DIRECTIONS=['s','so','o','no','n','ne','e','se']
JS=r'''async ({url,height})=>{
const im=new Image();im.src=url;await im.decode();
const source=document.createElement('canvas');source.width=im.width;source.height=im.height;
const sx=source.getContext('2d',{willReadFrequently:true});sx.drawImage(im,0,0);
// Find the actual transparent gap between rows rather than assuming H/2.
const whole=sx.getImageData(0,0,im.width,im.height).data;
const clear=[];
for(let y=Math.floor(im.height*.42);y<im.height*.58;y++){
 let count=0;for(let x=0;x<im.width;x++)if(whole[(y*im.width+x)*4+3]>=128)count++;
 if(count===0)clear.push(y);
}
if(!clear.length)throw Error('No clear separation between source rows');
const cut=Math.round((clear[0]+clear[clear.length-1])/2);
const rows=[0,cut,im.height];
const regions=[];
for(let i=0;i<8;i++){
 const left=Math.round((i%4)*im.width/4),right=Math.round((i%4+1)*im.width/4);
 const top=rows[Math.floor(i/4)],bottom=rows[Math.floor(i/4)+1];
 const pixels=sx.getImageData(left,top,right-left,bottom-top),w=pixels.width,h=pixels.height;
 let x0=w,y0=h,x1=-1,y1=-1;
 for(let y=0;y<h;y++)for(let x=0;x<w;x++)if(pixels.data[(y*w+x)*4+3]>=128){x0=Math.min(x0,x);y0=Math.min(y0,y);x1=Math.max(x1,x);y1=Math.max(y1,y);}
 if(x1<0)throw Error('Empty cell '+i);
 if(x0<2||y0<2||x1>w-3||y1>h-3)throw Error('Figure clipped at source cell '+i);
 let footMin=w,footMax=-1;
 for(let y=Math.max(y0,y1-Math.round((y1-y0)*.06));y<=y1;y++)for(let x=x0;x<=x1;x++)if(pixels.data[(y*w+x)*4+3]>=128){footMin=Math.min(footMin,x);footMax=Math.max(footMax,x);}
 regions.push({cell:[left,top,w,h],bbox:[left+x0,top+y0,x1-x0+1,y1-y0+1],foot:[left+(footMin+footMax)/2,top+y1+1]});
}
const scale=height/Math.max(...regions.map(r=>r.bbox[3]));
const atlas=document.createElement('canvas');atlas.width=512;atlas.height=256;const ac=atlas.getContext('2d');ac.imageSmoothingEnabled=false;
const frames=[];
for(let i=0;i<8;i++){
 const r=regions[i],c=document.createElement('canvas');c.width=128;c.height=128;
 const cx=c.getContext('2d',{willReadFrequently:true});cx.imageSmoothingEnabled=false;
 const [x,y,w,h]=r.bbox;const destination=[Math.round(64+(x-r.foot[0])*scale),112-Math.round(h*scale),Math.round(w*scale),Math.round(h*scale)];
 cx.drawImage(im,x,y,w,h,...destination);
 const p=cx.getImageData(0,0,128,128);
 let xx0=128,yy0=128,xx1=-1,yy1=-1,count=0;
 for(let yy=0;yy<128;yy++)for(let xx=0;xx<128;xx++){
  const k=(yy*128+xx)*4;const opaque=p.data[k+3]>=128;
  p.data[k+3]=opaque?255:0;
  if(!opaque){p.data[k]=0;p.data[k+1]=0;p.data[k+2]=0;}else{count++;xx0=Math.min(xx0,xx);yy0=Math.min(yy0,yy);xx1=Math.max(xx1,xx);yy1=Math.max(yy1,yy);}
 }
 cx.putImageData(p,0,0);ac.drawImage(c,(i%4)*128,Math.floor(i/4)*128);
 frames.push({png:c.toDataURL('image/png').split(',')[1],source:r,destination,bbox_native:[xx0,yy0,xx1-xx0+1,yy1-yy0+1],opaque_pixels:count});
}
return {source_size:[im.width,im.height],scale,frames,atlas:atlas.toDataURL('image/png').split(',')[1]};
}'''
async def main():
 catalogue={'schema_version':1,'status':'revisión visual, reposo; no integración','frame_px':[128,128],'foot_anchor_px':[64,112],'ground_tile_px':[64,32],'directions':DIRECTIONS,'order':'fila superior S, SO, O, NO; inferior N, NE, E, SE','filter':'nearest','alpha':'binaria, umbral 128','characters':{}}
 async with async_playwright() as p:
  browser=await p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--disable-dev-shm-usage'])
  page=await browser.new_page()
  for name,height in [('elfa-museo',80),('comerciante',84)]:
   source=ROOT/'fuentes'/f'{name}-vistas.png'
   url='data:image/png;base64,'+base64.b64encode(source.read_bytes()).decode()
   result=await page.evaluate(JS,{'url':url,'height':height})
   folder=ROOT/'sprites'/name;folder.mkdir(parents=True,exist_ok=True)
   char={'height_max_px':height,'uniform_scale':result['scale'],'source':str(source.relative_to(ROOT)),'source_size':result['source_size'],'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'atlas':f'{name}-atlas.png','frames':[]}
   (ROOT/char['atlas']).write_bytes(base64.b64decode(result['atlas']))
   for direction,frame in zip(DIRECTIONS,result['frames']):
    path=folder/f'reposo-{direction}.png';path.write_bytes(base64.b64decode(frame.pop('png')))
    frame.update({'direction':direction,'file':str(path.relative_to(ROOT)),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    char['frames'].append(frame)
   char['atlas_sha256']=hashlib.sha256((ROOT/char['atlas']).read_bytes()).hexdigest()
   catalogue['characters'][name]=char
  await browser.close()
 (ROOT/'sprites.json').write_text(json.dumps(catalogue,ensure_ascii=False,indent=2)+'\n')
 print('BITU_COUPLE_NATIVE_EXPORT_OK: 16 frames, 2 atlases')
asyncio.run(main())
