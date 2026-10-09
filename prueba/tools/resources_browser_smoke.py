"""Capturas y controles de los recursos en el canvas real de Godot WebGL."""
import asyncio
import io
from pathlib import Path
from PIL import Image, ImageChops
from playwright.async_api import async_playwright

PROJECT = Path(__file__).resolve().parents[1]

async def main():
    messages = []
    async with async_playwright() as p:
        browser = await p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,
            args=['--no-sandbox','--use-angle=swiftshader','--enable-unsafe-swiftshader','--disable-dev-shm-usage'])
        page = await browser.new_page(viewport={'width':1280,'height':720},device_scale_factor=1)
        page.on('console',lambda m: messages.append((m.type,m.text)))
        page.on('pageerror',lambda e: messages.append(('pageerror',str(e))))
        try:
            await page.goto('http://127.0.0.1:8765/index.html?vista=recursos',wait_until='networkidle')
            await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
            await page.wait_for_timeout(400)
            before = Image.open(io.BytesIO(await page.screenshot(path=str(PROJECT/'capturas/recursos-y-botin.png')))).convert('RGB')
            variants = [before]
            for index in [1,2]:
                await page.mouse.click(80,487)
                await page.wait_for_timeout(150)
                current = Image.open(io.BytesIO(await page.screenshot(path=str(PROJECT/'capturas'/f'recursos-arbol-{index+1}.png')))).convert('RGB')
                assert ImageChops.difference(before.crop((100,110,415,420)),current.crop((100,110,415,420))).getbbox(), 'Árbol no cambia'
                variants.append(current)
            assert ImageChops.difference(variants[1].crop((100,110,415,420)),variants[2].crop((100,110,415,420))).getbbox()
            await page.mouse.click(240,487)
            await page.mouse.click(525,487)
            await page.wait_for_timeout(150)
            after = Image.open(io.BytesIO(await page.screenshot(path=str(PROJECT/'capturas/recursos-estados.png')))).convert('RGB')
            assert ImageChops.difference(variants[2].crop((200,110,415,420)),after.crop((200,110,415,420))).getbbox(), 'Sin tocón'
            assert ImageChops.difference(before.crop((650,320,750,420)),after.crop((650,320,750,420))).getbbox(), 'Cobre sin picar'
            assert any('BITU_RESOURCES_PREVIEW_READY' in text for _,text in messages)
            assert not any(kind in {'error','pageerror'} or 'SCRIPT ERROR' in text for kind,text in messages), messages
            print('BITU_RESOURCES_BROWSER_SMOKE_OK')
        finally:
            await browser.close()

if __name__ == '__main__':
    asyncio.run(main())
