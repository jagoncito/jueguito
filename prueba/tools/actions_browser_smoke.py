"""Prueba clics reales de zarpazo y pesca en Chromium/WebGL."""
import asyncio,json
from pathlib import Path
from playwright.async_api import async_playwright
PROJECT=Path(__file__).resolve().parents[1]

async def main():
    messages=[]
    state={"tension":0.25}
    async with async_playwright() as p:
        browser=await p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--use-angle=swiftshader','--enable-unsafe-swiftshader','--disable-dev-shm-usage'])
        page=await browser.new_page(viewport={'width':1280,'height':720})
        def console(m):
            messages.append((m.type,m.text))
            if 'BITU_FISH_STATE:' in m.text: state.update(json.loads(m.text.split('BITU_FISH_STATE:',1)[1]))
        page.on('console',console)
        page.on('pageerror',lambda e:messages.append(('pageerror',str(e))))
        async def open_capture(name):
            await page.goto('http://127.0.0.1:8765/index.html?captura='+name+'&verificar=1',wait_until='networkidle')
            await page.wait_for_function("document.getElementById('status') === null",timeout=60000)
            await page.wait_for_timeout(300)
        async def click(x,y):
            await page.mouse.move(x,y)
            await page.mouse.down()
            await page.wait_for_timeout(220)
            await page.mouse.up()
        def observed(marker,start=0): return any(marker in t for _,t in messages[start:])
        try:
            await open_capture('zarpazo')
            mark=len(messages)
            async with page.expect_console_message(predicate=lambda m:'BITU_CLAW_HIT:2' in m.text,timeout=15000):
                await click(605,425)
            await page.screenshot(path=str(PROJECT/'capturas/zarpazo-en-juego.png'))
            await page.wait_for_timeout(700)
            await click(700,465)
            await page.wait_for_timeout(700)
            assert observed('BITU_CLAW_START',mark),'Clic vacío no atacó'
            assert sum('BITU_CLAW_HIT:' in t for _,t in messages[mark:])==1,'Zarpazo al aire o clic duplicado dañó otra vez'
            await open_capture('pesca')
            mark=len(messages)
            async with page.expect_console_message(predicate=lambda m:'BITU_FISH_CAST' in m.text,timeout=15000):
                await click(672,476)
            await page.screenshot(path=str(PROJECT/'capturas/pesca-lanzamiento-en-juego.png'))
            if not observed('BITU_FISH_BITE',mark):
                await page.wait_for_event('console',predicate=lambda m:'BITU_FISH_BITE' in m.text,timeout=20000)
            held=False
            snapshot=None
            for step in range(240):
                if observed('BITU_FISH_FINISH:',mark):break
                should_hold=state['tension']<0.65 if held else state['tension']<0.30
                if should_hold!=held:
                    await (page.mouse.down() if should_hold else page.mouse.up())
                    held=should_hold
                if snapshot is None and state.get('progress',0)>0.1 and not held:
                    snapshot=asyncio.create_task(page.screenshot(path=str(PROJECT/'capturas/pesca-en-juego.png')))
                await page.wait_for_timeout(150)
            await page.mouse.up()
            if snapshot:await snapshot
            assert observed('BITU_FISH_FINISH:true',mark),messages[mark:]
            if not observed('BITU_PICKUP:pez:1',mark):
                await page.wait_for_event('console',predicate=lambda m:'BITU_PICKUP:pez:1' in m.text,timeout=15000)
            await page.keyboard.down('Tab');await page.wait_for_timeout(150);await page.keyboard.up('Tab')
            await page.wait_for_timeout(300)
            await page.screenshot(path=str(PROJECT/'capturas/pesca-botin-en-juego.png'))
            mark=len(messages)
            await click(672,476)
            await page.keyboard.down('Escape');await page.wait_for_timeout(150);await page.keyboard.up('Escape')
            await page.wait_for_timeout(250)
            assert observed('BITU_FISH_FINISH:false',mark),'Esc no canceló'
            assert not any(k in {'error','pageerror'} or 'SCRIPT ERROR' in t for k,t in messages),messages
            print('BITU_ACTIONS_BROWSER_SMOKE_OK: zarpazo, captura real, botín y cancelar')
        finally:
            await browser.close()

if __name__=='__main__':asyncio.run(main())
