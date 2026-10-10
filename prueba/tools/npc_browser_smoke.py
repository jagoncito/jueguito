"""Capturas del motor web real: NPC en partida, cámara y escala idénticas."""
import asyncio,json,os
from pathlib import Path
from playwright.async_api import async_playwright
PROJECT=Path(__file__).resolve().parents[1]
BASE=os.environ.get('BITU_PREVIEW_URL','http://127.0.0.1:8771/index.html')
async def main():
 captures=[]
 async with async_playwright() as p:
  browser=await p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox','--use-angle=swiftshader','--enable-unsafe-swiftshader','--disable-dev-shm-usage'])
  for pose,height in [('escala-frente',80),('escala-frente',72),('escala-diagonal',80),('escala-diagonal',72),('escala-espalda',80)]:
   page=await browser.new_page(viewport={'width':1280,'height':720},device_scale_factor=1);messages=[];errors=[];ready=asyncio.Event()
   def console(m):
    messages.append(m.text)
    if 'BITU_INGAME_SCALE_CAPTURE_READY' in m.text:ready.set()
    if 'SCRIPT ERROR' in m.text or m.type=='error':errors.append(m.text)
   page.on('console',console);page.on('pageerror',lambda e:errors.append(str(e)))
   await page.goto(BASE+'?captura='+pose+'&altura='+str(height),wait_until='networkidle');await asyncio.wait_for(ready.wait(),60);await page.wait_for_function("document.getElementById('status') === null",timeout=60000);await page.wait_for_timeout(500)
   if errors:raise AssertionError('\n'.join(errors))
   file=PROJECT/'capturas'/f'npc-{pose}-{height}.png';await page.screenshot(path=str(file));captures.append({'file':str(file.relative_to(PROJECT)),'direction':pose,'dragon_height_px':height,'camera_zoom':1.5,'viewport':[1280,720],'ready_messages':[m for m in messages if 'BITU_' in m]});await page.close();print(file.name,flush=True)
  page=await browser.new_page(viewport={'width':1280,'height':720},device_scale_factor=1);ready=asyncio.Event();page.on('console',lambda m:ready.set()if 'BITU_READY' in m.text else None)
  await page.goto(BASE+'?captura=habitantes',wait_until='networkidle');await asyncio.wait_for(ready.wait(),60);await page.wait_for_function("document.getElementById('status') === null",timeout=60000);await page.wait_for_timeout(500);await page.screenshot(path=str(PROJECT/'capturas/npc-en-partida.png'));await page.close()
  page=await browser.new_page(viewport={'width':1280,'height':720},device_scale_factor=1);await page.goto(BASE,wait_until='networkidle');await page.wait_for_function("document.getElementById('status') === null",timeout=60000);await page.wait_for_timeout(500);await page.keyboard.press('F8');await page.wait_for_timeout(200);await page.keyboard.press('F7');await page.wait_for_timeout(200);before=await page.screenshot();await page.keyboard.down('d');await page.wait_for_timeout(300);await page.keyboard.up('d');after=await page.screenshot();assert before!=after,'El juego responde al movimiento';await page.close();await browser.close()
 (PROJECT/'capturas/npc-comparativa.json').write_text(json.dumps(captures,ensure_ascii=False,indent=2)+'\n')
 print('BITU_NPC_BROWSER_OK')
asyncio.run(main())
