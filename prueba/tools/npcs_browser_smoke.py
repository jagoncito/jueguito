"""Comprueba y graba la comparación de personajes en la granja real."""
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
            args=['--no-sandbox', '--use-angle=swiftshader', '--enable-unsafe-swiftshader', '--disable-dev-shm-usage'])
        page = await browser.new_page(viewport={'width':1280,'height':720}, device_scale_factor=1)
        page.on('console', lambda m: messages.append((m.type,m.text)))
        page.on('pageerror', lambda e: messages.append(('pageerror',str(e))))
        try:
            await page.goto('http://127.0.0.1:8765/index.html?captura=escala-frente&altura=80', wait_until='networkidle')
            await page.wait_for_function("document.getElementById('status') === null", timeout=60000)
            await page.wait_for_timeout(200)
            assert any('BITU_NPCS_READY:6' in text for _,text in messages), messages
            # La captura remota prepara la fila y deja los giros pausados.
            await page.locator('canvas').click(position={'x':640,'y':190})
            await page.screenshot(path=str(PROJECT/'capturas/personajes-comparacion.png'))
            async with page.expect_console_message(predicate=lambda m:'BITU_NPCS_PAUSED:false' in m.text):
                await page.keyboard.press('F6')
            await page.wait_for_timeout(200)
            await page.evaluate('''() => {
                const chunks=[];
                const recorder=new MediaRecorder(document.querySelector('canvas').captureStream(25),{mimeType:'video/webm'});
                window.npcRecorder=recorder;
                window.npcVideo=new Promise(resolve=>{
                    recorder.ondataavailable=e=>{if(e.data.size)chunks.push(e.data)};
                    recorder.onstop=async()=>resolve(Array.from(new Uint8Array(await new Blob(chunks).arrayBuffer())));
                });recorder.start();
            }''')
            await page.screenshot(path=str(PROJECT/'capturas/personajes-en-juego.png'))
            await page.wait_for_timeout(6600)
            encoded=await page.evaluate('async()=>{window.npcRecorder.stop();return await window.npcVideo}')
            (PROJECT/'capturas/personajes-movimiento.webm').write_bytes(bytes(encoded))
            async with page.expect_console_message(predicate=lambda m:'BITU_NPCS_PAUSED:true' in m.text):
                await page.keyboard.press('F6')
            await page.wait_for_timeout(150)
            paused_a=Image.open(io.BytesIO(await page.screenshot())).convert('RGB')
            await page.wait_for_timeout(500)
            paused_b=Image.open(io.BytesIO(await page.screenshot())).convert('RGB')
            # Fila de captura real: seis NPC y protagonista con cámara común.
            region=(265,300,915,525)
            assert ImageChops.difference(paused_a.crop(region),paused_b.crop(region)).getbbox() is None, 'F6 no detiene los dibujos visibles'
            async with page.expect_console_message(predicate=lambda m:'BITU_NPCS_PAUSED:false' in m.text):
                await page.keyboard.press('F6')
            await page.wait_for_timeout(2600)
            moving=Image.open(io.BytesIO(await page.screenshot())).convert('RGB')
            assert ImageChops.difference(paused_b.crop(region),moving.crop(region)).getbbox() is not None, 'F6 no reanuda el movimiento visible'
            assert not any(kind in ['error','pageerror'] for kind,_ in messages),messages
            print('BITU_NPCS_BROWSER_OK: seis personajes en la granja, vídeo y pausa/reanudación visibles')
        finally:
            await browser.close()


if __name__=='__main__':
    asyncio.run(main())
