"""Compara intervalos de presentación con el mismo teclado/zoom, sin telemetría de juego.
Ejecutar tras exportar y servir prueba/build/web en localhost:8765.
Chromium por software: comparación reproducible, no FPS del equipo del usuario.
"""
import asyncio,json,sys
from pathlib import Path
from playwright.async_api import async_playwright
async def run():
 async with async_playwright() as p:
  browser=await p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--use-angle=swiftshader','--enable-unsafe-swiftshader','--disable-dev-shm-usage'])
  page=await browser.new_page(viewport={'width':1280,'height':720})
  errors=[];page.on('pageerror',lambda e:errors.append(str(e)))
  url=sys.argv[2] if len(sys.argv)>2 else 'http://127.0.0.1:8765/index.html?lugar=tienda'
  await page.goto(url,wait_until='networkidle')
  await page.wait_for_function("document.getElementById('status')===null",timeout=90000)
  await page.wait_for_timeout(1500)
  await page.evaluate("""window.perfFrames=[];window.perfRunning=true;let last=performance.now();function step(t){if(!window.perfRunning)return;window.perfFrames.push(t-last);last=t;requestAnimationFrame(step)}requestAnimationFrame(step)""")
  await page.keyboard.down('Shift');await page.keyboard.down('d');await page.wait_for_timeout(6000);await page.keyboard.up('d')
  await page.mouse.wheel(0,200);await page.keyboard.down('w');await page.wait_for_timeout(6000);await page.keyboard.up('w');await page.keyboard.up('Shift')
  values=await page.evaluate('window.perfRunning=false;window.perfFrames')
  values=sorted(values);n=len(values)
  result={'environment':'Chromium SwiftShader, same route and viewport; not user hardware','frames':n,'median_ms':values[n//2],'p95_ms':values[int(n*.95)],'max_ms':values[-1],'over_50ms':sum(v>50 for v in values),'errors':errors}
  if len(sys.argv)>1: Path(sys.argv[1]).write_text(json.dumps(result,indent=2))
  print(json.dumps(result,indent=2),flush=True)
  await browser.close()
asyncio.run(run())
