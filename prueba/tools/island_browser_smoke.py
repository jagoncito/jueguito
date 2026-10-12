"""Revisión de la isla y los menús en el canvas real, con teclado y ratón."""
import asyncio,json
from pathlib import Path
from playwright.async_api import async_playwright

ROOT=Path(__file__).resolve().parents[2]
CAPTURES=ROOT/'prueba/capturas'
SITES=json.loads((ROOT/'assets/mundo/isla-bitu/isla.json').read_text())['sites']

async def ready(page,url):
    await page.goto(url,wait_until='networkidle')
    await page.wait_for_function("document.getElementById('status') === null && window.bituReviewState && window.bituReviewState.terrain.ready",timeout=60000)
    await page.wait_for_timeout(250)

async def state(page):
    return await page.evaluate('window.bituReviewState')

async def wait(page,expression):
    await page.wait_for_function(expression,timeout=15000)

async def press(page,key):
    await page.keyboard.down(key);await page.wait_for_timeout(350);await page.keyboard.up(key)

async def drag(page,source,destination,split=False):
    s=await state(page)
    canvas=await page.locator('canvas').bounding_box()
    def center(index):
        x,y,w,h=s['slots'][index]['rect']
        return canvas['x']+(x+w/2)*canvas['width']/s['viewport'][0],canvas['y']+(y+h/2)*canvas['height']/s['viewport'][1]
    start=center(source);end=center(destination)
    if split:await page.keyboard.down('Shift')
    await page.mouse.move(*start);await page.mouse.down();await page.wait_for_timeout(140)
    for step in range(1,11):
        t=step/10;await page.mouse.move(start[0]+(end[0]-start[0])*t,start[1]+(end[1]-start[1])*t);await page.wait_for_timeout(35)
    await page.wait_for_timeout(100);await page.mouse.up()
    if split:await page.keyboard.up('Shift')
    await page.wait_for_timeout(350)

async def main():
    messages=[]
    async with async_playwright() as p:
        browser=await p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--use-angle=swiftshader','--enable-unsafe-swiftshader','--disable-dev-shm-usage'])
        page=await browser.new_page(viewport={'width':1280,'height':720})
        page.on('console',lambda m:messages.append((m.type,m.text)))
        page.on('pageerror',lambda e:messages.append(('error',str(e))))
        try:
            await ready(page,'http://127.0.0.1:8765/index.html?verificar=1')
            start=await state(page)
            assert start['player']==[3520,1880] and not start['backpack'] and not start['map']
            await page.screenshot(path=str(CAPTURES/'isla-ruinas.png'))
            await press(page,'m');await wait(page,'window.bituReviewState.map && window.bituReviewState.paused')
            before=await state(page)
            await page.mouse.click(15,300);await page.wait_for_timeout(350)
            after=await state(page)
            assert after['player']==before['player'] and not after['busy'], 'El overlay debe consumir clics y pausar'
            await page.screenshot(path=str(CAPTURES/'isla-mapa.png'))
            await press(page,'m');await wait(page,'!window.bituReviewState.map && !window.bituReviewState.paused')
            await page.keyboard.down('d');await page.wait_for_timeout(550);await page.keyboard.up('d')
            await page.wait_for_timeout(200);await press(page,'m');await wait(page,'window.bituReviewState.map')
            moved=await state(page)
            assert moved['position'][0]>before['position'][0]+30 and moved['head'][0]>before['head'][0]+2,'La cabeza del mapa debe seguir la posición real'
            await press(page,'Escape');await wait(page,'!window.bituReviewState.paused')
            await ready(page,'http://127.0.0.1:8765/index.html?verificar=1&muestra=mochila')
            await press(page,'Tab');await wait(page,'window.bituReviewState.backpack && window.bituReviewState.paused')
            stocked=await state(page);assert len(stocked['slots'])==24 and stocked['slots'][0]['quantity']=='1k'
            initial_counts=stocked['counts']
            await drag(page,0,23)
            await wait(page,"window.bituReviewState.slots[23].amount===1000 && window.bituReviewState.slots[0].amount===0")
            await drag(page,23,22,True)
            await wait(page,"window.bituReviewState.slots[23].amount===500 && window.bituReviewState.slots[22].amount===500")
            assert (await state(page))['counts']==initial_counts,'Arrastrar/dividir conserva cantidades y calidades'
            await page.mouse.move(15,300);await page.wait_for_timeout(500)
            await page.screenshot(path=str(CAPTURES/'mochila.png'))
            await page.set_viewport_size({'width':900,'height':640});await page.wait_for_timeout(500)
            sized=await state(page);x,y,w,h=sized['bag_rect'];vw,vh=sized['viewport']
            assert x>=0 and y>=0 and x+w<=vw+2 and y+h<=vh+2,'Mochila contenida en pantalla pequeña'
            await page.screenshot(path=str(CAPTURES/'mochila-pantalla-pequena.png'))
            await page.set_viewport_size({'width':1280,'height':720})
            await press(page,'Escape');await wait(page,'!window.bituReviewState.paused')
            for site in SITES[1:]:
                id=site['id']
                await ready(page,f'http://127.0.0.1:8765/index.html?verificar=1&lugar={id}')
                # Zoom solo de cámara: revisar fachadas enteras con el mismo tamaño de sprites.
                await page.mouse.wheel(0,200)
                await wait(page,'window.bituReviewState.zoom<1.5 && window.bituReviewState.terrain.ready')
                await page.wait_for_timeout(350)
                await page.screenshot(path=str(CAPTURES/f'isla-{id}.png'))
                print('ENTER_REVIEW',id,flush=True)
                await page.keyboard.down('w')
                try:
                    await page.wait_for_function('(p)=>Math.hypot(window.bituReviewState.player[0]-p[0],window.bituReviewState.player[1]-p[1])<43',arg=site['point'],timeout=5000)
                finally: await page.keyboard.up('w')
                await page.wait_for_timeout(250)
                await press(page,'e');await wait(page,'window.bituReviewState.indoors')
                await page.wait_for_timeout(250)
                await page.screenshot(path=str(CAPTURES/f'isla-interior-{id}.png'))
                await press(page,'m');await wait(page,'window.bituReviewState.map')
                at=await state(page)
                assert at['position']==site['point'],'Dentro del edificio el mapa sigue situándote en su propiedad'
                await press(page,'Escape');await wait(page,'!window.bituReviewState.paused')
                await page.keyboard.down('s');await page.wait_for_timeout(250);await page.keyboard.up('s');await page.wait_for_timeout(100)
                await press(page,'e');await wait(page,'!window.bituReviewState.indoors')
            errors=[text for kind,text in messages if kind=='error' or 'SCRIPT ERROR' in text]
            assert not errors,errors
            print('BITU_ISLAND_BROWSER_OK: cabeza del mapa móvil, mochila24/1k, arrastre/división, pantalla pequeña y10interiores')
        finally:
            if any(kind=='error' for kind,_ in messages):print(messages[-20:])
            await browser.close()

if __name__=='__main__':asyncio.run(main())
