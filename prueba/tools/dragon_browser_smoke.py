"""Revisa ocho direcciones y seis acciones en el canvas real de Godot."""
import asyncio
import io
import json
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
            await page.locator('canvas').click(position={'x':640,'y':80})
            await page.evaluate('''() => {
                const chunks=[];
                const recorder=new MediaRecorder(document.querySelector('canvas').captureStream(25),{mimeType:'video/webm'});
                window.dragonRecorder=recorder;
                window.dragonVideo=new Promise(resolve=>{
                    recorder.ondataavailable=e=>{if(e.data.size)chunks.push(e.data)};
                    recorder.onstop=async()=>resolve(Array.from(new Uint8Array(await new Blob(chunks).arrayBuffer())));
                });recorder.start();
            }''')
            for key,name in [('1','reposo'),('2','marcha'),('3','minar'),('4','talar'),('5','palin'),('7','sprint'),('8','pesca'),('9','zarpazo')]:
                expected_mode={'1':'REPOSO','2':'MARCHA','3':'MINAR','4':'TALAR','5':'PALÍN','7':'SPRINT','8':'PESCA','9':'ZARPAZO'}[key]
                async with page.expect_console_message(
                    predicate=lambda m: f'BITU_DRAGON_MODE:{expected_mode}' in m.text,
                    timeout=15000):
                    # Mantener una tecla varios frames evita perder down/up
                    # entre frames de WebGL por software durante la carga.
                    await page.keyboard.down(key)
                    await page.wait_for_timeout(200)
                    await page.keyboard.up(key)
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
            for name in ['reposo','marcha','minar','talar','palin','sprint','pesca','zarpazo']:
                capture_messages = len(messages)
                await page.goto(f'http://127.0.0.1:8765/index.html?vista=dragon&captura={name}',wait_until='networkidle')
                await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
                await page.wait_for_timeout(300)
                states = [json.loads(text.split('BITU_DRAGON_CAPTURE_READY:',1)[1])
                          for _,text in messages[capture_messages:]
                          if 'BITU_DRAGON_CAPTURE_READY:' in text]
                expected_pose = {'reposo':'reposo','marcha':'andar-a',
                                 'minar':'golpe','talar':'golpe-talar','palin':'arrodillado','sprint':'sprint-a','pesca':'pesca-recoger','zarpazo':'zarpazo-golpe'}[name]
                expected_frames = [f'{expected_pose}-{direction}'
                                   for direction in ['S','SW','W','NW','N','NE','E','SE']]
                assert states and states[-1] == {'mode':name,'frames':expected_frames}, states
                capture_name='dragon-animaciones.png' if name=='reposo' else f'dragon-{name}.png'
                await page.screenshot(path=str(PROJECT/'capturas'/capture_name))
            # Regresión de piernas: las cuatro fases deben cambiar el dibujo
            # en su zona, no aprobar solo porque se mueve la herramienta.
            walk_images=[]
            for phase,pose in [('a','andar-a'),('paso-a','paso-a'),('b','andar-b'),('paso-b','paso-b')]:
                first_message=len(messages)
                await page.goto(f'http://127.0.0.1:8765/index.html?vista=dragon&captura=marcha-{phase}',wait_until='networkidle')
                await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
                states=[json.loads(text.split('BITU_DRAGON_CAPTURE_READY:',1)[1])
                        for _,text in messages[first_message:] if 'BITU_DRAGON_CAPTURE_READY:' in text]
                assert states and states[-1]['frames']==[f'{pose}-{d}' for d in ['S','SW','W','NW','N','NE','E','SE']],states
                walk_images.append(Image.open(io.BytesIO(await page.screenshot(
                    path=str(PROJECT/'build'/f'dragon-fase-{phase}.png')))).convert('RGB'))
            for i in range(8):
                x=320*(i%4);y=320*(i//4)
                # Parte baja del cuerpo: pies y rodillas, excluyendo el mango.
                bounds=(x+95,y+247,x+220,y+293)
                assert all(ImageChops.difference(walk_images[phase].crop(bounds),walk_images[(phase+1)%4].crop(bounds)).getbbox()
                           for phase in range(4)),f'Piernas congeladas en dirección {i}'
            assert any('BITU_DRAGON_PREVIEW_READY' in text for _,text in messages),messages
            assert not any(kind in {'error','pageerror'} for kind,_ in messages),messages
            print('BITU_DRAGON_BROWSER_SMOKE_OK: 8 direcciones × 8 acciones')
        finally:
            if any(k in {'error','pageerror'} for k,_ in messages):print(messages)
            await browser.close()
if __name__=='__main__':asyncio.run(main())
