"""Capture the actual first axe/ore impact and verify idle/start height."""
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
        page = await browser.new_page(viewport={'width':1280,'height':720}, device_scale_factor=1)
        page.on('console', lambda m: messages.append((m.type, m.text)))
        page.on('pageerror', lambda e: messages.append(('pageerror', str(e))))
        try:
            shots = []
            for pose in ['reposo', 'marcha-a']:
                await page.goto(f'http://127.0.0.1:8765/index.html?vista=dragon&captura={pose}', wait_until='networkidle')
                await page.wait_for_function("document.getElementById('status') === null", timeout=60000)
                await page.wait_for_timeout(200)
                shots.append(Image.open(io.BytesIO(await page.screenshot())).convert('RGB'))
            for i in range(8):
                x=320*(i%4); y=320*(i//4)
                bounds=(x+40,y+90,x+300,y+345)
                tops=[]
                for shot in shots:
                    patch=shot.crop(bounds)
                    rows=[y for y in range(patch.height) if any(patch.getpixel((x,y))!=(21,35,42) for x in range(patch.width))]
                    assert rows, ('Cuerpo ausente',i)
                    tops.append(rows[0])
                assert abs(tops[0]-tops[1])<=1, ('Cambia altura real al arrancar',i,tops)
            # Record the transition review in the actual Godot canvas.
            await page.goto('http://127.0.0.1:8765/index.html?vista=dragon', wait_until='networkidle')
            await page.wait_for_function("document.getElementById('status') === null", timeout=60000)
            await page.locator('canvas').click(position={'x':640,'y':80})
            async with page.expect_console_message(predicate=lambda m:'BITU_DRAGON_MODE:PARAR / ANDAR' in m.text):
                await page.keyboard.down('6')
                await page.wait_for_timeout(150)
                await page.keyboard.up('6')
            await page.evaluate('''() => {
                const chunks=[];
                const recorder=new MediaRecorder(document.querySelector('canvas').captureStream(25),{mimeType:'video/webm'});
                window.reviewRecorder=recorder;
                window.reviewVideo=new Promise(resolve=>{
                    recorder.ondataavailable=e=>{if(e.data.size)chunks.push(e.data)};
                    recorder.onstop=async()=>resolve(Array.from(new Uint8Array(await new Blob(chunks).arrayBuffer())));
                });recorder.start();
            }''')
            await page.wait_for_timeout(4200)
            encoded=await page.evaluate('async()=>{window.reviewRecorder.stop();return await window.reviewVideo}')
            (PROJECT/'capturas/dragon-parar-andar.webm').write_bytes(bytes(encoded))
            for action in ['minar','talar']:
                await page.goto(f'http://127.0.0.1:8765/index.html?captura=impacto-{action}&captura-impacto=1',wait_until='networkidle')
                await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
                await page.wait_for_timeout(400)
                mark=len(messages)
                click=(620,430) if action == 'minar' else (605,420)
                await page.mouse.move(*click)
                await page.wait_for_timeout(250)
                await page.mouse.click(*click,delay=250)
                for _ in range(100):
                    ready=[text for _,text in messages[mark:] if 'BITU_IMPACT_CAPTURE_READY:' in text]
                    if ready:
                        break
                    await page.wait_for_timeout(100)
                await page.screenshot(path=str(PROJECT/'capturas'/f'impacto-real-{action}.png'))
                assert ready and f'"action":"{action}"' in ready[-1], (action,messages[mark:])
            assert not any(kind in ['error','pageerror'] for kind,_ in messages),messages
            print('BITU_IMPACT_BROWSER_OK: altura reposo/arranque constante y golpe sobre árbol/mena reales')
        finally:
            await browser.close()


if __name__=='__main__':
    asyncio.run(main())
