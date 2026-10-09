"""Rasteriza el registro a la escala de juego con Canvas y filtro nearest.

La generación y las revisiones gráficas se realizan con image_gen; este paso
solo empaqueta sus recortes en lienzos nativos, conservando los originales.
Requiere Playwright y Chromium. No abre ni modifica el proyecto jugable.
"""
import asyncio
import base64
import json
import os
from pathlib import Path
from playwright.async_api import async_playwright
from registrar import register

HERE=Path(__file__).resolve().parent


async def main():
    async with async_playwright() as p:
        browser=await p.chromium.launch(executable_path=os.environ.get('BITU_CHROMIUM','/usr/bin/chromium'),headless=True,args=['--no-sandbox','--disable-dev-shm-usage','--disable-crashpad-for-testing'])
        page=await browser.new_page(viewport={'width':1680,'height':1200},device_scale_factor=1)
        errors=[]
        page.on('pageerror',lambda e:errors.append(str(e)))
        html=(HERE/'vista-previa.html').read_text()
        marker='<script type="application/json" id="sprite-data">'
        start=html.index(marker)+len(marker)
        end=html.index('</script>',start)
        bundle=json.loads(html[start:end])
        # Rasterizar siempre las fuentes originales, aunque existan PNG
        # nativos de una exportación anterior.
        dragon=bundle['image_paths']['dragon']
        bundle['image_paths']={key:'data:image/png;base64,'+base64.b64encode((HERE/source['file']).read_bytes()).decode()
                               for key,source in bundle['sources'].items()}
        bundle['image_paths']['dragon']=dragon
        html=html[:start]+json.dumps(bundle,ensure_ascii=False)+html[end:]
        await page.set_content(html,wait_until='load')
        await page.wait_for_function("document.documentElement.dataset.ready==='true'",timeout=60000)
        payload=await page.evaluate('''() => {
          const p=bituSpritePreview, outputs={}, atlas=document.createElement('canvas');
          atlas.width=256;atlas.height=192;
          const ac=atlas.getContext('2d');ac.imageSmoothingEnabled=false;
          for(const [id,f] of Object.entries(p.data.frames)){
            const c=document.createElement('canvas'),house=id==='casa';
            c.width=house?f.native_canvas_px[0]:64;c.height=house?f.native_canvas_px[1]:32;
            const ctx=c.getContext('2d');ctx.imageSmoothingEnabled=false;
            if(house)p.renderFrame(ctx,id,...f.native_anchor_px);
            else if(f.family==='orilla')p.renderFrame(ctx,id,32,16);
            else p.renderWater(ctx,id,32,16);
            const pixels=ctx.getImageData(0,0,c.width,c.height);
            for(let y=0;y<c.height;y++)for(let x=0;x<c.width;x++){
              const i=(y*c.width+x)*4;
              const inside=house || Math.abs((x+.5-32)/32)+Math.abs((y+.5-16)/16)<=1;
              pixels.data[i+3]=inside && pixels.data[i+3]>=128?255:0;
            }
            ctx.putImageData(pixels,0,0);
            outputs[id]=c.toDataURL('image/png').split(',')[1];
            if(!house)ac.drawImage(c,...f.native_region_px.slice(0,2));
          }
          outputs['agua-atlas']=atlas.toDataURL('image/png').split(',')[1];
          return outputs;
        }''')
        native=HERE/'sprites';native.mkdir(exist_ok=True)
        for id,encoded in payload.items():
            target=HERE/'agua-atlas.png' if id=='agua-atlas' else native/(id+'.png')
            target.write_bytes(base64.b64decode(encoded))
        register()
        # La revisión visible debe utilizar los PNG finales, no las fuentes.
        await page.set_content((HERE/'vista-previa.html').read_text(),wait_until='load')
        await page.wait_for_function("document.documentElement.dataset.ready==='true'",timeout=60000)
        for family in ('superficie','profunda','somera','espuma'):
            await page.select_option('#family',family)
            assert await page.evaluate("!document.getElementById('water').getContext('2d').imageSmoothingEnabled")
        await page.select_option('#family','superficie')
        await page.screenshot(path=str(HERE/'revision-a-escala.png'),full_page=True)
        assert not errors,errors
        assert await page.locator('#gallery canvas').count()==24
        print('BITU_SPRITES_EXPORT_OK: 25 PNG nativos, atlas 256x192, visor sin errores.')
        await browser.close()


if __name__=='__main__':asyncio.run(main())
