"""Capture the actual first axe/ore impact and verify idle/start pixels."""
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
                assert ImageChops.difference(shots[0].crop(bounds),shots[1].crop(bounds)).getbbox() is None, ('Idle/start changes visible body', i)
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
                await page.goto('http://127.0.0.1:8765/index.html?captura-impacto=1',wait_until='networkidle')
                await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
                await page.wait_for_timeout(400)
                await page.mouse.wheel(0,120)
                await page.wait_for_timeout(100)
                mark=len(messages)
                if action == 'minar':
                    await move(page,'s',120)
                    await page.mouse.move(668,468)
                    await page.wait_for_timeout(150)
                    await page.mouse.click(668,468,delay=80)
                else:
                    # Lado sureste: el personaje queda delante del tronco,
                    # permitiendo ver el filo en vez de ocultarlo tras la copa.
                    await move(page,'s',900)
                    await move(page,'a',150)
                    for _ in range(5):
                        await page.mouse.move(610,410)
                        await page.wait_for_timeout(150)
                        await page.mouse.click(610,410,delay=80)
                        await page.wait_for_timeout(500)
                        if any('BITU_IMPACT_CAPTURE_READY:' in text for _,text in messages[mark:]):
                            break
                        await move(page,'s',100)
                        await move(page,'a',50)
                for _ in range(30):
                    ready=[text for _,text in messages[mark:] if 'BITU_IMPACT_CAPTURE_READY:' in text]
                    if ready:
                        break
                    await page.wait_for_timeout(100)
                assert ready and f'"action":"{action}"' in ready[-1], (action,messages[mark:])
                await page.screenshot(path=str(PROJECT/'capturas'/f'impacto-real-{action}.png'))
            assert not any(kind in ['error','pageerror'] for kind,_ in messages),messages
            print('BITU_IMPACT_BROWSER_OK: reposo/arranque idénticos y golpe sobre árbol/mena reales')
        finally:
            await browser.close()


async def move(page, key, milliseconds):
    await page.keyboard.down(key)
    await page.wait_for_timeout(milliseconds)
    await page.keyboard.up(key)
    await page.wait_for_timeout(60)


if __name__=='__main__':
    asyncio.run(main())
