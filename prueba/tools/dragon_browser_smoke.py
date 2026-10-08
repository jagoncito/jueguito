"""Revisa ocho direcciones y cinco acciones en el canvas real de Godot."""
import asyncio
import io
from pathlib import Path
from PIL import Image, ImageChops
from playwright.async_api import async_playwright
PROJECT = Path(__file__).resolve().parents[1]

async def main():
    messages = []
    async with async_playwright() as p:
        browser = await p.chromium.launch(executable_path='/usr/bin/chromium', headless=True,
            args=['--no-sandbox','--use-angle=swiftshader','--enable-unsafe-swiftshader','--disable-dev-shm-usage'])
        page = await browser.new_page(viewport={'width':1280,'height':720},device_scale_factor=1)
        page.on('console',lambda m: messages.append((m.type,m.text)))
        page.on('pageerror',lambda e: messages.append(('pageerror',str(e))))
        try:
            await page.goto('http://127.0.0.1:8765/index.html?vista=dragon',wait_until='networkidle')
            await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
            await page.wait_for_timeout(400)
            await page.evaluate('''() => {
                const chunks=[];
                const recorder=new MediaRecorder(document.querySelector('canvas').captureStream(25),{mimeType:'video/webm'});
                window.dragonRecorder=recorder;
                window.dragonVideo=new Promise(resolve=>{
                    recorder.ondataavailable=e=>{if(e.data.size)chunks.push(e.data)};
                    recorder.onstop=async()=>resolve(Array.from(new Uint8Array(await new Blob(chunks).arrayBuffer())));
                });recorder.start();
            }''')
            for key,name in [('1','reposo'),('2','marcha'),('3','minar'),('4','talar'),('5','palin')]:
                await page.keyboard.press(key)
                await page.wait_for_timeout(400 if key=='5' else 150)
                capture_name = 'dragon-animaciones.png' if key=='1' else f'dragon-{name}.png'
                before=Image.open(io.BytesIO(await page.screenshot(path=str(PROJECT/'capturas'/capture_name)))).convert('RGB')
                changes=[False]*8
                for step,wait in enumerate([180,220,350] if key!='5' else [300,850,600]):
                    await page.wait_for_timeout(wait)
                    capture_path = str(PROJECT/'capturas'/capture_name) if step==0 and key in {'3','4'} else None
                    after=Image.open(io.BytesIO(await page.screenshot(path=capture_path))).convert('RGB')
                    for i in range(8):
                        x=320*(i%4); y=320*(i//4)
                        bounds=(x+20,y+90,x+300,y+395)
                        changes[i] |= ImageChops.difference(before.crop(bounds),after.crop(bounds)).getbbox() is not None
                if key!='1':
                    assert all(changes),f'Animación congelada {name}: {changes}'
            encoded=await page.evaluate('''async()=>{window.dragonRecorder.stop();return await window.dragonVideo}''')
            (PROJECT/'capturas/dragon-animaciones.webm').write_bytes(bytes(encoded))
            # Guardar cada modo en una pose fija del mismo controlador. Los
            # screenshots pueden tardar más que un golpe en WebGL por software.
            for name in ['reposo','marcha','minar','talar','palin']:
                await page.goto(f'http://127.0.0.1:8765/index.html?vista=dragon&captura={name}',wait_until='networkidle')
                await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
                await page.wait_for_timeout(300)
                capture_name='dragon-animaciones.png' if name=='reposo' else f'dragon-{name}.png'
                await page.screenshot(path=str(PROJECT/'capturas'/capture_name))
            assert any('BITU_DRAGON_PREVIEW_READY' in text for _,text in messages),messages
            assert not any(kind in {'error','pageerror'} for kind,_ in messages),messages
            print('BITU_DRAGON_BROWSER_SMOKE_OK: 8 direcciones × 5 acciones')
        finally:
            if any(k in {'error','pageerror'} for k,_ in messages):print(messages)
            await browser.close()
if __name__=='__main__':asyncio.run(main())
