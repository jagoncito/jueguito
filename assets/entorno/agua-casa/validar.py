"""Comprueba la geometría y transparencia reales de los sprites entregados."""
from pathlib import Path
import hashlib
import json
from PIL import Image

HERE=Path(__file__).resolve().parent
data=json.loads((HERE/'sprites.json').read_text())
for source in data['sources'].values():
    file=HERE/source['file']
    assert hashlib.sha256(file.read_bytes()).hexdigest()==source['sha256']
    with Image.open(file) as im:
        assert list(im.size)==source['dimensions_px'] and im.mode=='RGBA'
        alpha=im.getchannel('A')
        assert min(alpha.getextrema())==0,'La fuente debe tener transparencia real'

with Image.open(HERE/'agua-atlas.png') as atlas:
    assert atlas.size==(256,192)
    count=0
    for id,frame in data['frames'].items():
        file=HERE/frame['native_file']
        assert hashlib.sha256(file.read_bytes()).hexdigest()==frame['native_sha256']
        with Image.open(file) as im:
            alpha=im.getchannel('A')
            assert all(n==0 for i,n in enumerate(alpha.histogram()) if i not in (0,255)),'Bordes de píxel nítidos, sin halo'
            if id=='casa':
                assert im.size==(640,512)
                bounds=alpha.getbbox()
                assert bounds[2]-bounds[0]==544,'Escala uniforme de la casa'
                assert bounds[0]>0 and bounds[1]>0 and bounds[2]<640 and bounds[3]<512,'No recortar tejado ni porche'
                assert 88<=data['house']['door_height_px']<=94,'Puerta coherente con personajes de 80–90 px'
                continue
            assert im.size==(64,32)
            x,y,w,h=frame['native_region_px']
            assert atlas.crop((x,y,x+w,y+h)).tobytes()==im.tobytes(),'Atlas y PNG individual deben coincidir'
            pixels=alpha.load()
            for py in range(32):
                for px in range(64):
                    inside=abs((px+.5-32)/32)+abs((py+.5-16)/16)<=1
                    if not inside:assert pixels[px,py]==0,'Píxeles fuera del rombo 2:1'
                    elif id.startswith('agua-'):assert pixels[px,py]==255,'Hueco transparente que abriría una costura'
            if id.startswith('orilla-'):
                assert 0<alpha.histogram()[255]<1024,'La orilla debe conservar agua transparente debajo'
            count+=1
assert count==24
print('BITU_SPRITES_VALIDATION_OK: casa sin recortes, puerta proporcionada, 24 rombos sin huecos y fuentes intactas.')
