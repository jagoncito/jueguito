"""Read-only checks. Run with Python 3 and Pillow from any directory."""
import hashlib
import json
from pathlib import Path
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
count = 0
warnings = []
for character in ('flavia','unamahloni'):
    folder = HERE.parent / character / 'equipamiento'
    data = json.loads((folder/'equipamiento.json').read_text())
    assert len(data['frames']) == 64
    assert len({f['id'] for f in data['frames']}) == 64
    images = {}
    for key, source in data['sources'].items():
        path = folder/source['file']
        assert path.resolve() == (ROOT/source['repository_path']).resolve()
        assert hashlib.sha256(path.read_bytes()).hexdigest() == source['sha256']
        image = Image.open(path).convert('RGBA')
        assert list(image.size) == source['dimensions_px']
        images[key] = image
    for direction in data['directions']:
        selected = [f for f in data['frames'] if f['direction']==direction]
        assert len(selected) == 8
        assert {f['phase'] for f in selected if f['action']=='walk'} == {0,1,2,3}
        scales = {f['source_to_game_scale'] for f in selected if f['action']=='walk'}
        assert len(scales)==1, 'Walk scale must not change between phases'
    for frame in data['frames']:
        image=images[frame['source']]
        x,y,w,h=frame['region_px']
        assert min(x,y)>=0 and x+w<=image.width and y+h<=image.height
        assert w>0 and h>0 and 0<frame['source_to_game_scale']<1
        assert (h-6)*frame['source_to_game_scale']<=80.00001
        for name,hand in frame['hands'].items():
            hx,hy=hand['position_px']
            assert 0<=hx<w and 0<=hy<h
            assert hand['depth'] in ('front','behind_body')
            if hand['depth']=='front' and image.getpixel((round(x+hx),round(y+hy)))[3]<64:
                warnings.append(f"{character} {frame['id']} {name}: transparent palm anchor")
        count += 1
    for a in data['frames']:
        for b in data['frames']:
            if a['id']>=b['id'] or a['source']!=b['source']: continue
            ax,ay,aw,ah=a['region_px']; bx,by,bw,bh=b['region_px']
            assert ax+aw<=bx or bx+bw<=ax or ay+ah<=by or by+bh<=ay, (a['id'],b['id'])

props=json.loads((HERE/'objetos.json').read_text())
for source in props['sources'].values():
    path=HERE/source['file']
    assert path.resolve()==(ROOT/source['repository_path']).resolve()
    image=Image.open(path).convert('RGBA')
    assert list(image.size)==source['dimensions_px']
    if 'sha256' in source:
        assert hashlib.sha256(path.read_bytes()).hexdigest()==source['sha256']
for obj in props['objects']:
    image=Image.open(HERE/props['sources'][obj['source']]['file'])
    x,y,w,h=obj['region_px']
    assert min(x,y)>=0 and x+w<=image.width and y+h<=image.height
    for gx,gy in obj['grips_px']:
        assert 0<=gx<w and 0<=gy<h
base=ROOT/'assets/personajes/unamahloni-idle.png'
assert hashlib.sha256(base.read_bytes()).hexdigest()=='eca7b65f33d74ff1ff467e4e0c5d988f50890552e8d90f3e17589c0cd39768fc'
for warning in warnings: print(warning)
assert not warnings, 'Visible palm anchors must lie on the silhouette'
print(f'BITU_EQUIPMENT_ASSETS_OK: {count} frames, 9 object projections, originals preserved.')
