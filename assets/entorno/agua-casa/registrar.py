"""Registra las fuentes originales y prepara el visor; no modifica imágenes."""
from pathlib import Path
from PIL import Image
import base64
import hashlib
import json

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]


def register():
    sources = {}
    for key, file in [('house', 'casa-fuente.png'), ('water', 'agua-fuente.png'), ('shore', 'orillas-fuente.png')]:
        with Image.open(HERE / file) as im:
            im.verify()
        with Image.open(HERE / file) as im:
            sources[key] = {'file': file, 'dimensions_px': list(im.size),
                            'sha256': hashlib.sha256((HERE/file).read_bytes()).hexdigest()}
    frames = {}
    box = (103, 16, 1373, 982)
    scale = 544 / (box[2] - box[0])
    anchor = [320 / scale, 1139]
    frames['casa'] = {
        'source': 'house', 'region_px': [box[0], box[1], box[2]-box[0], box[3]-box[1]],
        'anchor_px': anchor, 'scale': scale,
        'visible_size_px': [544, (box[3]-box[1])*scale],
        'native_canvas_px': [640,512], 'native_anchor_px': [368,496],
    }
    families = {
        'superficie': {'base_color': '#117e91', 'label': 'Agua turquesa'},
        'profunda': {'base_color': '#07536b', 'label': 'Agua profunda'},
        'somera': {'base_color': '#27999e', 'label': 'Agua somera'},
        'espuma': {'base_color': '#117e91', 'label': 'Reflejos y espuma'},
        'orilla': {'base_color': '#117e91', 'label': 'Orillas'},
    }
    with Image.open(HERE / 'agua-fuente.png') as im:
        for row, family in enumerate(list(families)[:4]):
            for col in range(4):
                cell = (col*384, row*256, (col+1)*384, (row+1)*256)
                alpha = im.crop(cell).getchannel('A')
                bound = alpha.point(lambda v: 255 if v >= 128 else 0).getbbox()
                assert bound, (row,col)
                x,y,right,bottom = bound
                w,h = right-x,bottom-y
                frames[f'agua-{family}-{col}'] = {
                    'source': 'water', 'family': family,
                    'region_px': [cell[0]+x,cell[1]+y,w,h],
                    'anchor_px': [w/2,h/2], 'target_size_px': [64,32],
                    'native_region_px': [col*64,row*32,64,32],
                }
    ids = ['borde-no','borde-ne','borde-se','borde-so',
           'esquina-arriba','esquina-derecha','esquina-abajo','esquina-izquierda']
    # Registrar el plano completo, no la caja del banco visible. De ese modo
    # arena y espuma conservan su posición respecto al agua transparente.
    planes = [(10,178,370,250), (394,178,374,250), (778,178,374,250), (1158,178,370,250),
              (10,579,370,272), (394,579,374,272), (778,579,374,272), (1158,579,370,272)]
    for index,(name,plane) in enumerate(zip(ids,planes)):
        x,y,w,h=plane
        frames[f'orilla-{name}']={
            'source':'shore', 'family':'orilla', 'region_px':[x,y,w,h],
            'anchor_px':[w/2,h/2], 'target_size_px':[64,32],
            'native_region_px':[(index%4)*64,(4+index//4)*32,64,32],
        }
    dragon_path=ROOT/'assets/personajes/dragon-avatar/dragon-jugable.json'
    dragon=json.loads(dragon_path.read_text())['frames']['reposo-S']
    reference={
        'file': '../../../assets/personajes/dragon-avatar/'+dragon['file'],
        'region_px':dragon['region'],
        'anchor_px':[dragon['anchor'][0]-dragon['region'][0],dragon['anchor'][1]-dragon['region'][1]],
        'scale':dragon['scale'],
        'use':'Referencia existente de escala en el visor, sin cambios al personaje.',
    }
    data={
        'version':1, 'status':'Sprites de desarrollo independientes; sin integración en el juego.',
        'reference':{'ground_tile_px':[64,32],'humanoid_height_px':80,'dragon_height_px':90,'filter':'nearest'},
        'house':{
            'footprint_tiles':[10,7], 'footprint_projection_px':[544,272],
            'footprint_cells':[[0,0],[10,0],[10,7],[0,7]], 'placement_anchor_cells':[10,7],
            'door_world_offset_px':[(991-box[0]-anchor[0])*scale,(867-box[1]-anchor[1])*scale],
            'door_height_px':round(209*scale,1),
            'note':'Reserva técnica de escala incluyendo porche y acceso. No fija la futura colisión ni ubicación del edificio.',
        },
        'sources':sources,'families':families,'frames':frames,'reference_character':reference,
        'water':{
            'native_atlas_px':[256,192], 'static_variants':16, 'shore_overlays':8,
            'animated':False, 'geometry':'Rombo 64x32, recorte geométrico y composición sobre fondo por familia.',
            'normalization':'Solo el plano de terreno se normaliza a 2:1; la casa conserva escala uniforme.',
            'coverage':'Cuatro bordes y cuatro esquinas exteriores. No incluye todavía esquinas interiores ni un autotile completo.',
        },
    }
    native_house=HERE/'sprites/casa.png'
    native_atlas=HERE/'agua-atlas.png'
    native_ready=native_house.is_file() and native_atlas.is_file()
    if native_ready:
        with Image.open(native_house) as im:
            native_ready=list(im.size)==frames['casa']['native_canvas_px']
    if native_ready:
        data['native_sources']={
            'house':{'file':'sprites/casa.png','dimensions_px':[640,512],'anchor_px':[368,496]},
            'water':{'file':'agua-atlas.png','dimensions_px':[256,192],'tile_px':[64,32]},
        }
        for id,frame in frames.items():
            file='sprites/'+id+'.png'
            frame['native_file']=file
            frame['native_sha256']=hashlib.sha256((HERE/file).read_bytes()).hexdigest()
        for source in data['native_sources'].values():
            source['sha256']=hashlib.sha256((HERE/source['file']).read_bytes()).hexdigest()
    (HERE/'sprites.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
    bundle=dict(data)
    bundle['image_paths']={}
    viewer_sources={key+'_native':source for key,source in data['native_sources'].items()} if native_ready else sources
    for key,source in viewer_sources.items():
        bundle['image_paths'][key]='data:image/png;base64,'+base64.b64encode((HERE/source['file']).read_bytes()).decode()
    bundle['image_paths']['dragon']='data:image/png;base64,'+base64.b64encode((HERE/reference['file']).resolve().read_bytes()).decode()
    js=(HERE/'visor.js').read_text()
    html='''<!doctype html><html lang="es"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Bītu · Sprites de casa y agua</title><style>
*{box-sizing:border-box}body{margin:0;background:#17221f;color:#f1ead4;font:16px system-ui}main{max-width:1600px;margin:auto;padding:24px}h1{margin:0 0 8px}h2{margin:0 0 12px;font-size:20px}p{line-height:1.5;color:#bac8b7}header{margin-bottom:22px}.tools{display:flex;gap:18px;flex-wrap:wrap;align-items:center;margin:20px 0}select,button{font:inherit;color:#f1ead4;background:#2b3d34;border:1px solid #76825c;border-radius:6px;padding:7px}label{display:flex;gap:8px;align-items:center}.views{display:grid;grid-template-columns:1fr 1fr;gap:20px}.card{min-width:0;background:#233129;padding:20px;border:1px solid #485d43;border-radius:12px}.canvas-wrap{overflow:auto}canvas{image-rendering:pixelated;max-width:none;background:repeating-conic-gradient(#25392e 0 25%,#2c4035 0 50%) 0/16px 16px;display:block}#gallery{display:grid;grid-template-columns:repeat(auto-fit,minmax(148px,1fr));gap:16px}#gallery article{background:#28382e;padding:12px;border-radius:8px}#gallery canvas{margin:auto}#gallery p{font-size:12px;margin:8px 0 0;text-align:center}small{color:#bad0ae}@media(max-width:1050px){.views{grid-template-columns:1fr}}a{color:#edd397}</style>
<main><header><h1>Bītu · Casa y agua</h1><p>Sprites a escala para el desarrollo. Visor independiente: no modifica la partida ni la escena jugable.</p><p id="loading">Cargando sprites…</p></header>
<div class="tools"><label>Zoom <select id="zoom"><option value="1">×1 · tamaño de juego</option><option value="2">×2</option><option value="3">×3</option></select></label><label><input id="guides" type="checkbox" checked> Mostrar suelo y entrada</label><label>Agua <select id="family"><option value="superficie">Turquesa</option><option value="profunda">Profunda</option><option value="somera">Somera</option><option value="espuma">Reflejos y espuma</option></select></label><button id="variation">Cambiar variantes</button></div>
<div class="views"><section class="card"><h2>Casa · comparación con el dragón</h2><div class="canvas-wrap"><canvas id="house" width="720" height="680"></canvas></div><p>Suelo reservado: 10 × 7 casillas, 544 × 272 px. Entrada de unos 90 px; casa escalada sin deformación.</p></section><section class="card"><h2>Agua · composición de 9 × 9 casillas</h2><div class="canvas-wrap"><canvas id="water" width="640" height="390"></canvas></div><p>Rombos de 64 × 32 px. Variantes estáticas; los bordes se dibujan como capas transparentes.</p><small>Este lote contiene cuatro bordes y cuatro esquinas exteriores. La animación y las esquinas interiores se podrán ampliar después.</small></section></div>
<section class="card" style="margin-top:20px"><h2>24 piezas de agua y orilla · ampliadas ×2</h2><div id="gallery"></div></section></main>
<script type="application/json" id="sprite-data">BUNDLE</script><script>CODE</script></html>'''
    # Insertar el script antes de las imágenes: CODE puede aparecer por azar
    # dentro de datos PNG codificados en base64.
    html=html.replace('CODE',js).replace('BUNDLE',json.dumps(bundle,ensure_ascii=False))
    (HERE/'vista-previa.html').write_text(html)
    print('Registro y visor preparados:',len(frames),'sprites.')


if __name__=='__main__':
    register()
