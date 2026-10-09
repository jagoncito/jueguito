/* Preview-only renderer. Original PNGs remain untouched. */
(() => {
  'use strict';
  const bundle = JSON.parse(document.getElementById('equipment-data').textContent);
  const images = {};
  const dirs = bundle.characters.flavia.directions;
  const labels = {S:'Frente', SW:'Frente izquierda', W:'Perfil izquierdo', NW:'Espalda izquierda', N:'Espalda', NE:'Espalda derecha', E:'Perfil derecho', SE:'Frente derecha'};
  const $ = id => document.getElementById(id);
  const state = {character:'flavia', action:'one_hand', item:'mallet', phase:0, playing:false, anchors:false};
  const canvases = dirs.map(direction => {
    const article = document.createElement('article');
    const title = document.createElement('h2');
    title.textContent = `${direction} · ${labels[direction]}`;
    const canvas = document.createElement('canvas');
    canvas.width = canvas.height = 128;
    canvas.dataset.direction = direction;
    canvas.setAttribute('aria-label', labels[direction]);
    const info = document.createElement('p');
    info.className = 'frame-note';
    article.append(title, canvas, info);
    $('views').append(article);
    return {direction, canvas, info};
  });

  function getFrame(direction) {
    const data = bundle.characters[state.character];
    return data.frames.find(f => f.direction===direction && f.action===state.action && f.phase===(state.action==='walk'?state.phase:0));
  }

  function getItem(direction) {
    if (state.item === 'none') return null;
    const view = ['N','NW','NE'].includes(direction) ? 'back' : 'front';
    return bundle.props.objects.find(p => p.id===state.item && p.view===view)
      || bundle.props.objects.find(p => p.id===state.item && p.view==='any');
  }

  function transformFor(frame, item, bodyOrigin) {
    const bs = frame.source_to_game_scale;
    const point = name => frame.hands[name].position_px.map((v,i)=>bodyOrigin[i]+v*bs);
    const primary = point('primary'), secondary = point('secondary');
    let scale = item.source_to_game_scale, angle = 0;
    if (state.action === 'two_hands' && item.grips_px.length > 1) {
      const a = item.grips_px[0], b = item.grips_px[1];
      scale = Math.hypot(secondary[0]-primary[0],secondary[1]-primary[1])/Math.hypot(b[0]-a[0],b[1]-a[1]);
      angle = Math.atan2(secondary[1]-primary[1],secondary[0]-primary[0])-Math.atan2(b[1]-a[1],b[0]-a[0]);
    } else if (state.action !== 'consume') {
      angle = (['W','SW','NW'].includes(frame.direction)?-1:['E','SE','NE'].includes(frame.direction)?1:0)*Math.PI/18;
    }
    const grip=item.grips_px[0], c=Math.cos(angle), s=Math.sin(angle);
    const project = p => [primary[0]+scale*((p[0]-grip[0])*c-(p[1]-grip[1])*s),primary[1]+scale*((p[0]-grip[0])*s+(p[1]-grip[1])*c)];
    const r=item.region_px;
    const corners=[[0,0],[r[2],0],[r[2],r[3]],[0,r[3]]].map(project);
    return {scale,angle,primary,secondary,grip,project,corners};
  }

  function render(direction, canvas, overlay=state.anchors) {
    const ctx=canvas.getContext('2d');
    ctx.imageSmoothingEnabled=false;
    ctx.clearRect(0,0,128,128);
    for(let y=0;y<128;y+=8) for(let x=0;x<128;x+=8){ctx.fillStyle=(x+y)%16?'#202b32':'#243039';ctx.fillRect(x,y,8,8);}
    ctx.fillStyle='#334837'; ctx.strokeStyle='#63815a';
    ctx.beginPath();ctx.moveTo(64,96);ctx.lineTo(96,112);ctx.lineTo(64,127);ctx.lineTo(32,112);ctx.closePath();ctx.fill();ctx.stroke();
    const frame=getFrame(direction), data=bundle.characters[state.character], item=getItem(direction);
    const bs=frame.source_to_game_scale, origin=frame.foot_anchor_px.map((v,i)=>data.presentation.foot_anchor_game_px[i]-v*bs);
    const source=images[data.sources[frame.source].repository_path];
    const r=frame.region_px;
    const body=()=>ctx.drawImage(source,...r,...origin,r[2]*bs,r[3]*bs);
    let tx=null;
    const prop=()=>{
      ctx.save();ctx.translate(...tx.primary);ctx.rotate(tx.angle);ctx.scale(tx.scale,tx.scale);ctx.translate(-tx.grip[0],-tx.grip[1]);
      const ps=bundle.props.sources[item.source];
      ctx.drawImage(images[ps.repository_path],...item.region_px,0,0,item.region_px[2],item.region_px[3]);ctx.restore();
    };
    if(item)tx=transformFor(frame,item,origin);
    const behind=frame.hands.primary.depth==='behind_body';
    if(item&&behind)prop();
    body();
    if(item&&!behind)prop();
    if(item){
      // Redraw only small palm discs over handles; never redraw a square of torso.
      for(const name of ['primary',...(state.action==='two_hands'&&item.grips_px.length>1?['secondary']:[])]){
        const hand=frame.hands[name];if(hand.depth!=='front')continue;
        const pos=hand.position_px.map((v,i)=>origin[i]+v*bs);
        ctx.save();ctx.beginPath();ctx.arc(...pos,hand.foreground_radius_game_px,0,Math.PI*2);ctx.clip();body();ctx.restore();
      }
    }
    if(overlay){
      ctx.fillStyle='#fff';ctx.fillRect(63,111,3,3);
      for(const [name,color]of [['primary','#ffcb71'],['secondary','#69dcec']]){
        const p=frame.hands[name].position_px.map((v,i)=>origin[i]+v*bs);
        ctx.strokeStyle=color;ctx.beginPath();ctx.arc(...p,3,0,Math.PI*2);ctx.stroke();
      }
    }
    return {frame,item,origin,transform:tx};
  }

  function draw(){
    $('phase').textContent=state.action==='walk'?`Marcha · fase ${state.phase+1}/4`:'Pose estática · manos libres en la fuente';
    $('play').textContent=state.playing?'Pausar':'Reproducir';
    $('play').disabled=state.action!=='walk';$('step').disabled=state.action!=='walk';
    for(const c of canvases){const out=render(c.direction,c.canvas);c.info.textContent=out.item?`${out.item.label} · ${out.frame.hands.primary.depth==='behind_body'?'detrás del cuerpo':'agarre visible'}`:'Sin objeto';}
  }
  $('character').addEventListener('change',e=>{state.character=e.target.value;draw();});
  $('action').addEventListener('change',e=>{state.action=e.target.value;state.phase=0;state.playing=state.action==='walk';draw();});
  $('item').addEventListener('change',e=>{state.item=e.target.value;draw();});
  $('recommended').addEventListener('click',()=>{const item=bundle.props.objects.find(i=>i.id===state.item);if(item){state.action=item.recommended_pose;$('action').value=state.action;state.phase=0;state.playing=false;draw();}});
  $('play').addEventListener('click',()=>{state.playing=!state.playing;draw();});
  $('step').addEventListener('click',()=>{state.playing=false;state.phase=(state.phase+1)%4;draw();});
  $('zoom').addEventListener('change',e=>{$('views').style.setProperty('--zoom',e.target.value);});
  $('anchors').addEventListener('change',e=>{state.anchors=e.target.checked;draw();});
  window.equipmentPreview={bundle,images,state,render,draw,getFrame,getItem};
  const paths=new Set([...Object.values(bundle.characters).flatMap(c=>Object.values(c.sources).map(s=>s.repository_path)),...Object.values(bundle.props.sources).map(s=>s.repository_path)]);
  Promise.all([...paths].map(path=>new Promise((resolve,reject)=>{
    const im=new Image();im.onload=resolve;im.onerror=()=>reject(new Error(`No se pudo cargar ${path}`));
    images[path]=im;im.src=bundle.image_paths[path];
  }))).then(()=>{draw();document.documentElement.dataset.ready='true';$('loading').hidden=true;}).catch(e=>{$('loading').textContent=e.message;document.documentElement.dataset.ready='error';});
  setInterval(()=>{if(state.playing&&state.action==='walk'&&!document.hidden){state.phase=(state.phase+1)%4;draw();}},1000/6);
})();
