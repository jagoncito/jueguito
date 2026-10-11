"""Registra coordenadas y empaqueta fuentes existentes, sin dibujar imágenes."""
from pathlib import Path
import json,hashlib,shutil,subprocess,os,tempfile
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'assets/mundo/isla-bitu';RUNTIME=ROOT/'prueba/assets/mundo/isla-bitu'
OUT.mkdir(parents=True,exist_ok=True);(OUT/'sprites').mkdir(exist_ok=True)
BUILDINGS={
 'flavia':('assets/entregas/completar-bitu/referencias/flavia-casa-exterior-fuente.png',[0,0,1536,1024],.45,[520,855],[[260,690],[735,820],[1370,700],[1370,530],[850,330],[260,510]]),
 'pareja':('assets/entregas/completar-bitu/referencias/pareja-vivienda-exterior-fuente.png',[0,0,1536,1024],.46,[1000,965],[[160,715],[580,835],[760,785],[1110,940],[1450,760],[1450,610],[830,330],[160,520]]),
 'alquimista':('assets/entorno/casa-alquimista/referencias/casa-alquimista-exterior-fuente.png',[0,0,1536,1024],.46,[560,915],[[90,680],[780,925],[1460,805],[1460,585],[920,390],[90,530]]),
 'tienda':('assets/entorno/tienda-bitu24h/referencias/tienda-exterior-fuente.png',[0,0,1536,1024],.48,[570,860],[[130,650],[940,910],[1440,795],[1440,565],[820,330],[130,490]]),
 'museo':('assets/entorno/museo/referencias/museo-exterior-fuente.png',[0,0,1536,1024],.48,[585,870],[[110,620],[1170,925],[1450,820],[1450,610],[850,370],[110,470]]),
 'herreria':('assets/entorno/mina-herreria/referencias/herreria-vivienda-exterior-fuente.png',[0,0,1536,1024],.44,[1025,965],[[110,695],[400,775],[860,870],[1150,930],[1470,800],[1470,560],[860,340],[110,500]]),
 'pescador':('assets/entorno/parcela-cocinero-pescador/referencias/choza-exterior-fuente.png',[0,0,1536,1024],.40,[940,955],[[285,765],[755,915],[1230,830],[1230,595],[860,410],[285,540]]),
 'astillero':('assets/entorno/astillero/referencias/astillero-exterior-fuente.png',[30,0,1490,670],.48,[625,600],[[320,405],[840,475],[1415,560],[1450,475],[1000,235],[320,225]]),
 'mina':('assets/entorno/mina-herreria/referencias/mina-exterior-fuente.png',[0,0,1536,1024],.44,[895,865],[[150,750],[560,940],[1120,985],[1400,750],[1400,510],[920,260],[310,360]]),
}
PROP_SOURCES={
 'cama':('assets/entregas/completar-bitu/referencias/flavia-casa-interior-fuente.png',[8,814,172,177],.62),
 'armario':('assets/entregas/completar-bitu/referencias/flavia-casa-interior-fuente.png',[236,805,86,176],.62),
 'cofre':('assets/entregas/completar-bitu/referencias/flavia-casa-interior-fuente.png',[326,870,110,110],.62),
 'mesa':('assets/entregas/completar-bitu/referencias/flavia-casa-interior-fuente.png',[443,848,216,143],.62),
 'chimenea':('assets/entregas/completar-bitu/referencias/flavia-casa-interior-fuente.png',[686,809,166,192],.62),
 'cocina':('assets/entregas/completar-bitu/referencias/flavia-casa-interior-fuente.png',[855,816,163,194],.62),
 'sillon':('assets/entregas/completar-bitu/referencias/flavia-casa-interior-fuente.png',[1025,858,113,139],.62),
 'cama-doble':('assets/entregas/completar-bitu/referencias/pareja-vivienda-interior-fuente.png',[108,783,217,191],.62),
 'biblioteca':('assets/entregas/completar-bitu/referencias/pareja-vivienda-interior-fuente.png',[616,786,145,188],.62),
 'escritorio':('assets/entregas/completar-bitu/referencias/pareja-vivienda-interior-fuente.png',[772,808,198,164],.62),
 'cajon':('assets/entorno/astillero/referencias/astillero-exterior-fuente.png',[393,846,154,149],.50),
 'barril':('assets/entorno/astillero/referencias/astillero-exterior-fuente.png',[281,866,104,126],.50),
 'tablones':('assets/entorno/astillero/referencias/astillero-exterior-fuente.png',[558,857,234,145],.50),
}
jobs=[];catalog={'version':1,'buildings':{},'props':{},'sources':{}}
for id,(name,region,factor,entry,foundation) in BUILDINGS.items():
 src=ROOT/name;out=OUT/'sprites'/f'{id}.png';jobs.append({'source':str(src),'region':region,'scale':factor,'output':str(out)})
 native_entry=[round((entry[i]-region[i])*factor) for i in range(2)]
 # La entrada de mina es un portal seguro delante de la boca, no un agujero
 # transitable en la colisión exterior. El astillero usa el umbral del taller.
 local_foundation=[[round((p[i]-entry[i])*factor) for i in range(2)] for p in foundation]
 front=local_foundation[:4] if id in ['pareja','herreria'] else local_foundation[:3]
 catalog['buildings'][id]={'file':f'sprites/{id}.png','entry':native_entry,'foundation':local_foundation,'front':front,'source':name,'source_region':region,'uniform_scale':factor}
for id,(name,region,factor) in PROP_SOURCES.items():
 out=OUT/'sprites'/f'prop-{id}.png';jobs.append({'source':str(ROOT/name),'region':region,'scale':factor,'output':str(out)})
 catalog['props'][id]={'file':f'sprites/prop-{id}.png','size':[round(region[2]*factor),round(region[3]*factor)],'source':name,'region':region,'scale':factor}
for j in jobs:
 name=str(Path(j['source']).relative_to(ROOT));catalog['sources'][name]={'bytes':Path(j['source']).stat().st_size,'sha256':hashlib.sha256(Path(j['source']).read_bytes()).hexdigest()}
temporary=tempfile.TemporaryDirectory(prefix='bitu-isla-')
manifest=Path(temporary.name)/'bake.json';manifest.write_text(json.dumps({'jobs':jobs}))
env=dict(os.environ)
subprocess.run(['godot','--headless','--path',str(ROOT/'prueba'),'--script','res://tools/bake_island_assets.gd','--',str(manifest)],env=env,check=True)
(OUT/'edificios.json').write_text(json.dumps(catalog,ensure_ascii=False,indent=2)+'\n')
RUNTIME.mkdir(parents=True,exist_ok=True);shutil.copytree(OUT,RUNTIME,dirs_exist_ok=True)
ruins=ROOT/'assets/entorno/ruinas-camino';target=ROOT/'prueba/assets/entorno/ruinas-camino'
for sub in ['atlas','texturas','prefabs']:shutil.copytree(ruins/sub,target/sub,dirs_exist_ok=True)
shutil.copyfile(ruins/'assets.json',target/'assets.json')
print('REGISTRO_ISLA',len(catalog['buildings']),'edificios',len(catalog['props']),'muebles; fuentes intactas')

temporary.cleanup()
