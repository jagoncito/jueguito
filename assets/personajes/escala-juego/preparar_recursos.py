from pathlib import Path
import json,shutil,base64
out=Path(__file__).resolve().parent;root=out.parents[2];catalog=json.loads((out/'sprites.json').read_text())
for name,ch in catalog['characters'].items():
 frames=ch['frames'];lines=['[gd_resource type="SpriteFrames" load_steps=%d format=3]'%(len(frames)+2),'','[ext_resource type="Texture2D" path="res://assets/personajes/escala-juego/%s" id="1"]'%ch['atlas']]
 for index,f in enumerate(frames):
  lines+=['','[sub_resource type="AtlasTexture" id="F%d"]'%index,'atlas = ExtResource("1")','region = Rect2(%s)'%(', '.join(map(str,f['region']))),'filter_clip = true']
 clips={}
 for index,f in enumerate(frames):clips.setdefault(f['action']+'-'+f['direction'],[]).append(index)
 if name=='dragon':
  for direction in catalog['directions']:
   clips['walk-'+direction]=[next(i for i,f in enumerate(frames)if f['id']==pose+'-'+direction)for pose in ['andar-a','paso-a','andar-b','paso-b']]
 animations=[]
 for action,indexes in clips.items():
  animations.append('{"frames": [%s], "loop": true, "name": &"%s", "speed": %s}'%(', '.join('{"duration": 1.0, "texture": SubResource("F%d")}'%i for i in indexes),action,'7.0'if action.startswith('walk-')else'1.0'))
 lines+=['','[resource]','animations = [\n'+',\n'.join(animations)+'\n]']
 (out/name/'animaciones.tres').write_text('\n'.join(lines)+'\n')
 idle='reposo-S'
 (out/name/'personaje.tscn').write_text(f'''[gd_scene load_steps=2 format=3]

[ext_resource type="SpriteFrames" path="res://assets/personajes/escala-juego/{name}/animaciones.tres" id="1"]

[node name="Personaje" type="Node2D"]
texture_filter = 1
metadata/height_px = {ch['height_px']}

[node name="Cuerpo" type="AnimatedSprite2D" parent="."]
position = Vector2(-64, -112)
centered = false
sprite_frames = ExtResource("1")
animation = &"{idle}"
''')
 for f in ['animaciones.tres','personaje.tscn']:shutil.copy2(out/name/f,root/'prueba/assets/personajes/escala-juego'/name/f)
# Visor autónomo de los mismos píxeles nativos del motor.
embedded={}
for name,ch in catalog['characters'].items():
 embedded[name]={**ch,'url':'data:image/png;base64,'+base64.b64encode((out/ch['atlas']).read_bytes()).decode()}
html='<!doctype html><html lang="es"><meta charset="utf-8"><title>Bītu · NPC a escala</title><style>body{background:#162c2b;color:#eddcb7;font:17px system-ui;margin:24px}canvas{image-rendering:pixelated}select{font:inherit;padding:8px;margin:8px}#panel{overflow:auto}</style><h1>Bītu · seis NPC a escala</h1><p>Ocho vistas de reposo por personaje. Fotogramas128×128, suelo64×32, misma escala y distintas estaturas.</p><select id="direction"></select><select id="zoom"><option value="1">1×</option><option value="2" selected>2×</option><option value="3">3×</option></select><div id="panel"><canvas id="view"></canvas></div><p>Para comparar también al protagonista actualizado de104 fotogramas, abrir la escena de Godot personajes.tscn o la descarga web con ?vista=personajes.</p><script>\nconst chars=DATA,dirs=[\'S\',\'SW\',\'W\',\'NW\',\'N\',\'NE\',\'E\',\'SE\'],order=[\'flavia\',\'unamahloni\',\'elfa-museo\',\'comerciante\',\'cocinero\',\'enano\'],names=[\'Flavia\',\'Unamahloni\',\'Elfa\',\'Comerciante\',\'Cocinero\',\'Enano\'];const images={},sel=document.getElementById(\'direction\'),zoom=document.getElementById(\'zoom\');for(const d of dirs)sel.add(new Option(d,d));sel.onchange=zoom.onchange=draw;\nasync function init(){for(const n of order){images[n]=new Image();images[n].src=chars[n].url;await images[n].decode();}draw();}\nfunction draw(){const z=Number(zoom.value),c=document.getElementById(\'view\');c.width=6*82*z+80;c.height=150*z+50;const x=c.getContext(\'2d\');x.imageSmoothingEnabled=false;x.fillStyle=\'#162c2b\';x.fillRect(0,0,c.width,c.height);order.forEach((n,i)=>{const f=chars[n].frames.find(f=>f.direction===sel.value),bx=64+i*82*z,by=112*z+12;x.strokeStyle=\'#647e61\';x.beginPath();x.moveTo(bx-32*z,by);x.lineTo(bx,by-16*z);x.lineTo(bx+32*z,by);x.lineTo(bx,by+16*z);x.closePath();x.stroke();x.drawImage(images[n],...f.region,bx-64*z,by-112*z,128*z,128*z);x.fillStyle=\'#eddcb7\';x.font=\'15px system-ui\';x.fillText(names[i]+\' · \'+chars[n].height_px+\' px\',bx-50,by+35*z);});}init();</script></html>'
(out/'visor.html').write_text(html.replace('DATA',json.dumps(embedded,ensure_ascii=False)),encoding='utf-8')
print('6 prefabs de NPC y visor listos; protagonista conserva su runtime actualizado')
