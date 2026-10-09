/* Visor independiente. Los PNG fuente se conservan intactos. */
(() => {
  'use strict';
  const data = JSON.parse(document.getElementById('sprite-data').textContent);
  const images = {};
  const $ = id => document.getElementById(id);
  const state = {zoom: 1, guides: true, family: 'superficie', variation: 0};
  function context(canvas) {
    const ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;
    return ctx;
  }
  function diamond(ctx, x, y, w = 64, h = 32) {
    ctx.beginPath();
    ctx.moveTo(x, y - h / 2); ctx.lineTo(x + w / 2, y);
    ctx.lineTo(x, y + h / 2); ctx.lineTo(x - w / 2, y); ctx.closePath();
  }
  function renderFrame(ctx, id, x, y) {
    const frame = data.frames[id], region = frame.region_px;
    if(images.house_native && id==='casa'){
      const a=frame.native_anchor_px;
      ctx.drawImage(images.house_native,x-a[0],y-a[1]);return;
    }
    if(images.water_native && id!=='casa'){
      ctx.drawImage(images.water_native,...frame.native_region_px,x-32,y-16,64,32);return;
    }
    const [ax, ay] = frame.anchor_px;
    const scale = frame.scale;
    const sx = frame.target_size_px ? frame.target_size_px[0]/region[2] : scale;
    const sy = frame.target_size_px ? frame.target_size_px[1]/region[3] : scale;
    ctx.drawImage(images[frame.source], ...region,
      x - ax * sx, y - ay * sy, region[2] * sx, region[3] * sy);
  }
  function renderWater(ctx, id, x, y, shore) {
    const frame = data.frames[id];
    ctx.save();
    diamond(ctx, x, y); ctx.clip();
    ctx.fillStyle = data.families[frame.family].base_color;
    ctx.fillRect(x - 32, y - 16, 64, 32);
    renderFrame(ctx, id, x, y);
    if (shore) renderFrame(ctx, shore, x, y);
    ctx.restore();
  }
  function houseView() {
    const canvas = $('house'), ctx = context(canvas);
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const origin = [304, 240], cell = (x,y) => [origin[0]+(x-y)*32, origin[1]+(x+y)*16];
    for (let y=-1; y<8; y++) for (let x=-1; x<11; x++) {
      const p=cell(x,y); diamond(ctx,...p);
      ctx.fillStyle=(x+y)%2 ? '#68824e' : '#6e8854'; ctx.fill();
      if(state.guides){ctx.strokeStyle='#ffffff18';ctx.stroke();}
    }
    const anchor=cell(...data.house.placement_anchor_cells);
    if(state.guides){
      const footprint=data.house.footprint_cells.map(p=>cell(...p));
      ctx.beginPath();footprint.forEach((p,i)=>i?ctx.lineTo(...p):ctx.moveTo(...p));ctx.closePath();
      ctx.strokeStyle='#f6cf77';ctx.lineWidth=2;ctx.stroke();
    }
    renderFrame(ctx,'casa',...anchor);
    const d=data.reference_character;
    const r=d.region_px;
    const person=cell(10.8,6.8);
    ctx.drawImage(images.dragon,...r,person[0]-d.anchor_px[0]*d.scale,
      person[1]-d.anchor_px[1]*d.scale,r[2]*d.scale,r[3]*d.scale);
    if(state.guides){
      const door=data.house.door_world_offset_px.map((v,i)=>v+anchor[i]);
      ctx.fillStyle='#f6cf77';ctx.fillRect(door[0]-3,door[1]-3,6,6);
      ctx.fillStyle='#fff1ca';ctx.font='14px system-ui';
      ctx.fillText('Suelo: 10 × 7 casillas · 544 × 272 px',22,620);
      ctx.fillText('Dragón: 90 px · Puerta: ~90 px · Entrada marcada',22,645);
    }
    canvas.style.width=`${canvas.width*state.zoom}px`;
    canvas.style.height=`${canvas.height*state.zoom}px`;
  }
  function waterView() {
    const canvas=$('water'),ctx=context(canvas);
    ctx.clearRect(0,0,canvas.width,canvas.height);
    for(let y=0;y<9;y++)for(let x=0;x<9;x++){
      const [cx,cy]=[320+(x-y)*32,66+(x+y)*16];
      const family=state.family;
      const id=`agua-${family}-${(x*3+y+state.variation)%4}`;
      let shore;
      if(x===0&&y===0)shore='orilla-esquina-arriba';
      else if(x===0)shore='orilla-borde-no';
      else if(y===0)shore='orilla-borde-ne';
      renderWater(ctx,id,cx,cy,shore);
      if(state.guides){diamond(ctx,cx,cy);ctx.strokeStyle='#ffffff12';ctx.stroke();}
    }
    canvas.style.width=`${canvas.width*state.zoom}px`;
    canvas.style.height=`${canvas.height*state.zoom}px`;
  }
  function gallery() {
    const container=$('gallery');container.replaceChildren();
    for(const [id,frame] of Object.entries(data.frames)){
      if(id==='casa')continue;
      const article=document.createElement('article'), canvas=document.createElement('canvas');
      canvas.width=128;canvas.height=64;canvas.dataset.sprite=id;
      const ctx=context(canvas);ctx.scale(2,2);
      if(frame.family==='orilla')renderWater(ctx,'agua-superficie-0',32,16,id);
      else renderWater(ctx,id,32,16);
      const caption=document.createElement('p');caption.textContent=id.replaceAll('-',' ');
      article.append(canvas,caption);container.append(article);
    }
  }
  function draw(){houseView();waterView();}
  $('zoom').addEventListener('change',()=>{state.zoom=Number($('zoom').value);draw();});
  $('guides').addEventListener('change',()=>{state.guides=$('guides').checked;draw();});
  $('family').addEventListener('change',()=>{state.family=$('family').value;draw();});
  $('variation').addEventListener('click',()=>{state.variation=(state.variation+1)%4;draw();});
  async function load(){
    await Promise.all(Object.entries(data.image_paths).map(([id,url])=>new Promise((resolve,reject)=>{
      const img=new Image();img.onload=()=>{images[id]=img;resolve();};img.onerror=()=>reject(Error(`No carga ${id}`));img.src=url;
    })));
    gallery();draw();document.documentElement.dataset.ready='true';
    $('loading').hidden=true;
  }
  window.bituSpritePreview={data,images,state,draw,renderFrame,renderWater};
  load().catch(e=>{$('loading').textContent=e.message;console.error(e);});
})();
