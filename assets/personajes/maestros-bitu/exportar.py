"""Exportación técnica de vistas generadas, sin alterar las fuentes."""
import asyncio,base64,json,hashlib
from pathlib import Path
from playwright.async_api import async_playwright
ROOT=Path(__file__).resolve().parent
DIRECTIONS=['s','so','o','no','n','ne','e','se']
CHARACTERS={'cocinero':{'height':80,'states':['libre','pesca','cocina','comida'],'source_order':DIRECTIONS},'enano':{'height':64,'states':['libre','quebraveta','forja','comida'],'source_order':['s','se','e','ne','n','no','o','so']}}
ANALYZE=r'''async url=>{
const im=new Image();im.src=url;await im.decode();
const canvas=document.createElement('canvas');canvas.width=im.width;canvas.height=im.height;const ctx=canvas.getContext('2d',{willReadFrequently:true});ctx.drawImage(im,0,0);
const pixels=ctx.getImageData(0,0,im.width,im.height).data;
const alpha=(x,y)=>pixels[(y*im.width+x)*4+3]>=128;
function gap(counts,target,radius){
 let spans=[],start=-1;
 const low=Math.max(1,Math.floor(target-radius)),high=Math.min(counts.length-2,Math.ceil(target+radius));
 for(let k=low;k<=high+1;k++){
  if(k<=high&&counts[k]===0){if(start<0)start=k;}else if(start>=0){spans.push([start,k-1]);start=-1;}
 }
 if(!spans.length)throw Error('No transparent gap near '+target);
 spans.sort((a,b)=>Math.abs((a[0]+a[1])/2-target)-Math.abs((b[0]+b[1])/2-target));
 return Math.round((spans[0][0]+spans[0][1])/2);
}
const yc=Array(im.height).fill(0);for(let y=0;y<im.height;y++)for(let x=0;x<im.width;x++)if(alpha(x,y))yc[y]++;
const rows=[0,gap(yc,im.height/2,im.height*.1),im.height];let regions=[];
for(let row=0;row<2;row++){
 const top=rows[row],bottom=rows[row+1],xc=Array(im.width).fill(0);
 for(let x=0;x<im.width;x++)for(let y=top;y<bottom;y++)if(alpha(x,y))xc[x]++;
 const cols=[0,gap(xc,im.width/4,im.width*.085),gap(xc,im.width/2,im.width*.085),gap(xc,im.width*3/4,im.width*.085),im.width];
 for(let col=0;col<4;col++){
  const left=cols[col],right=cols[col+1];let x0=right,y0=bottom,x1=-1,y1=-1;
  for(let y=top;y<bottom;y++)for(let x=left;x<right;x++)if(alpha(x,y)){x0=Math.min(x0,x);y0=Math.min(y0,y);x1=Math.max(x1,x);y1=Math.max(y1,y);}
  if(x1<0||x0<=left||x1>=right-1||y0<=top||y1>=bottom-1)throw Error('Empty or clipped figure '+row+','+col);
  let foot0=right,foot1=left;
  for(let y=Math.max(y0,y1-Math.round((y1-y0)*.06));y<=y1;y++)for(let x=x0;x<=x1;x++)if(alpha(x,y)){foot0=Math.min(foot0,x);foot1=Math.max(foot1,x);}
  regions.push({cell:[left,top,right-left,bottom-top],bbox:[x0,y0,x1-x0+1,y1-y0+1],foot:[(foot0+foot1)/2,y1+1]});
 }
}
return {size:[im.width,im.height],regions};
}'''
RENDER=r'''async ({url,regions,scale,order,directions})=>{
 const im=new Image();im.src=url;await im.decode();const atlas=document.createElement('canvas');atlas.width=512;atlas.height=256;const ax=atlas.getContext('2d');ax.imageSmoothingEnabled=false;const frames=[];
 for(let i=0;i<8;i++){
  const sourceIndex=order.indexOf(directions[i]),r=regions[sourceIndex],[x,y,w,h]=r.bbox;
  const c=document.createElement('canvas');c.width=128;c.height=128;const cx=c.getContext('2d',{willReadFrequently:true});cx.imageSmoothingEnabled=false;
  const dest=[Math.round(64+(x-r.foot[0])*scale),112-Math.round(h*scale),Math.round(w*scale),Math.round(h*scale)];
  if(dest[0]<1||dest[0]+dest[2]>127||dest[1]<1)throw Error('Native frame clips equipment '+i);
  cx.drawImage(im,x,y,w,h,...dest);const p=cx.getImageData(0,0,128,128);let x0=128,y0=128,x1=-1,y1=-1,count=0;
  for(let yy=0;yy<128;yy++)for(let xx=0;xx<128;xx++){const k=(yy*128+xx)*4;const visible=p.data[k+3]>=128;p.data[k+3]=visible?255:0;if(!visible){p.data[k]=p.data[k+1]=p.data[k+2]=0;}else{count++;x0=Math.min(x0,xx);y0=Math.min(y0,yy);x1=Math.max(x1,xx);y1=Math.max(y1,yy);}}
  cx.putImageData(p,0,0);ax.drawImage(c,i%4*128,Math.floor(i/4)*128);
  frames.push({source_index:sourceIndex,source:r,destination:dest,bbox_native:[x0,y0,x1-x0+1,y1-y0+1],opaque_pixels:count,png:c.toDataURL('image/png').split(',')[1]});
 }
 return {frames,atlas:atlas.toDataURL('image/png').split(',')[1]};
}'''
async def main():
 catalogue={'schema_version':1,'status':'revisión visual, poses estáticas; sin integración','frame_px':[128,128],'foot_anchor_px':[64,112],'ground_tile_px':[64,32],'directions':DIRECTIONS,'filter':'nearest','alpha':'binaria, umbral 128','characters':{}}
 async with async_playwright() as p:
  browser=await p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--disable-dev-shm-usage'])
  page=await browser.new_page()
  for name,spec in CHARACTERS.items():
   analyzed={}
   for state in spec['states']:
    source=ROOT/'fuentes'/f'{name}-{state}.png';raw=source.read_bytes();url='data:image/png;base64,'+base64.b64encode(raw).decode();measure=await page.evaluate(ANALYZE,url);analyzed[state]=(source,raw,url,measure)
   # Each source sheet may have a different source size. Normalize without stretching,
   # using one uniform scale for its eight views and the same target body height.
   char={'height_max_px':spec['height'],'states':{}}
   for state,(source,raw,url,measure) in analyzed.items():
    scale=spec['height']/max(r['bbox'][3] for r in measure['regions'])
    result=await page.evaluate(RENDER,{'url':url,'regions':measure['regions'],'scale':scale,'order':spec['source_order'],'directions':DIRECTIONS})
    folder=ROOT/'sprites'/name/state;folder.mkdir(parents=True,exist_ok=True)
    entry={'uniform_scale':scale,'source':str(source.relative_to(ROOT)),'source_sha256':hashlib.sha256(raw).hexdigest(),'source_size':measure['size'],'source_direction_order':spec['source_order'],'atlas':f'{name}-{state}-atlas.png','frames':[]}
    (ROOT/entry['atlas']).write_bytes(base64.b64decode(result['atlas']));entry['atlas_sha256']=hashlib.sha256((ROOT/entry['atlas']).read_bytes()).hexdigest()
    for direction,frame in zip(DIRECTIONS,result['frames']):
     path=folder/f'{direction}.png';path.write_bytes(base64.b64decode(frame.pop('png')));frame.update({'direction':direction,'file':str(path.relative_to(ROOT)),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()});entry['frames'].append(frame)
    char['states'][state]=entry
   catalogue['characters'][name]=char
  await browser.close()
 (ROOT/'sprites.json').write_text(json.dumps(catalogue,ensure_ascii=False,indent=2)+'\n')
 print('BITU_MASTERS_EXPORT_OK: 64 PNG nativos y 8 atlas')
asyncio.run(main())
