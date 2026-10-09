"""Browser verification only; screenshot output is a review capture, not an edited asset."""
import asyncio
import base64
import json
import tempfile
from pathlib import Path
from playwright.async_api import async_playwright, Error as BrowserError

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
CAPTURES=Path(tempfile.mkdtemp(prefix='bitu-equipment-review-'))

async def main():
    html=(HERE/'vista-previa.html').read_text()
    start=html.index('<script type="application/json" id="equipment-data">')+len('<script type="application/json" id="equipment-data">')
    end=html.index('</script>',start)
    bundle=json.loads(html[start:end])
    for path in bundle['image_paths']:
        bundle['image_paths'][path]='data:image/png;base64,'+base64.b64encode((ROOT/path).read_bytes()).decode()
    html=html[:start]+json.dumps(bundle)+html[end:]
    html=html.replace('<script src="compositor.js"></script>','<script>'+(HERE/'compositor.js').read_text()+'</script>')
    async with async_playwright() as p:
        browser=await p.chromium.launch(executable_path='/usr/bin/chromium',headless=True,args=['--no-sandbox','--disable-dev-shm-usage','--disable-crashpad-for-testing'])
        page=await browser.new_page(viewport={'width':1400,'height':1100})
        errors=[]
        page.on('pageerror',lambda error:errors.append(str(error)))
        await page.set_content(html,wait_until='load')
        await page.wait_for_function("document.documentElement.dataset.ready === 'true'")
        assert await page.locator('canvas').count()==8
        checks=await page.evaluate('''() => {
          const p=equipmentPreview, results=[];
          p.state.playing=false;
          for(const character of ['flavia','unamahloni'])for(const action of ['idle','one_hand','two_hands','consume','walk'])for(const item of ['none','book','flask','mallet','tomato','pico','palin'])for(let phase=0;phase<(action==='walk'?4:1);phase++){
            Object.assign(p.state,{character,action,item,phase});
            for(const canvas of document.querySelectorAll('canvas')){
              const out=p.render(canvas.dataset.direction,canvas,false);
              if(out.item){
                const tx=out.transform,g=tx.project(out.item.grips_px[0]);
                if(Math.hypot(g[0]-tx.primary[0],g[1]-tx.primary[1])>1e-8)throw Error('Primary grip detached');
                if(action==='two_hands'&&out.item.grips_px.length>1){const s=tx.project(out.item.grips_px[1]);if(Math.hypot(s[0]-tx.secondary[0],s[1]-tx.secondary[1])>1e-8)throw Error('Secondary grip detached');}
                if(tx.corners.some(c=>c.some(v=>v<0||v>128)))results.push({character,action,item,phase,direction:canvas.dataset.direction,corners:tx.corners});
              }
              if(canvas.getContext('2d').imageSmoothingEnabled)throw Error('Smooth filtering');
            }
          }
          return results;
        }''')
        print('OUT_OF_FRAME',json.dumps(checks))
        assert not checks,'Equipped object must fit within 128×128'
        for character,item,action in [('flavia','mallet','one_hand'),('unamahloni','book','two_hands'),('unamahloni','flask','consume')]:
            await page.select_option('#character',character)
            await page.select_option('#action',action)
            await page.select_option('#item',item)
            await page.evaluate('equipmentPreview.state.playing=false;equipmentPreview.draw()')
            await page.screenshot(path=str(CAPTURES/f'{character}-{item}-revision.png'),full_page=True)
        await page.select_option('#action','walk')
        await page.click('#play')
        before=await page.evaluate("document.querySelector('canvas').toDataURL()")
        await page.click('#step')
        after=await page.evaluate("document.querySelector('canvas').toDataURL()")
        assert before!=after,'Walk phases must actually change drawing'
        assert not errors,errors
        print('BITU_EQUIPMENT_BROWSER_OK: 896 combinations; both grips, eight directions, walking, nearest filtering and controls.')
        # Also verify actual relative image/script paths when opened directly.
        local=await browser.new_page()
        try:
            await local.goto((HERE/'vista-previa.html').as_uri(),wait_until='load')
            await local.wait_for_function("document.documentElement.dataset.ready === 'true'")
            assert await local.locator('canvas').count()==8
            print('BITU_EQUIPMENT_LOCAL_FILE_OK: local images/scripts load without a server.')
        except BrowserError as error:
            if 'ERR_BLOCKED_BY_ADMINISTRATOR' not in str(error): raise
            original=(HERE/'vista-previa.html').read_text()
            a=original.index('<script type="application/json" id="equipment-data">')+len('<script type="application/json" id="equipment-data">')
            b=original.index('</script>',a)
            original_bundle=json.loads(original[a:b])
            for repo_path,relative in original_bundle['image_paths'].items():
                assert (HERE/relative).resolve()==(ROOT/repo_path).resolve()
                assert (HERE/relative).is_file()
            assert (HERE/'compositor.js').is_file()
            print('BITU_EQUIPMENT_LOCAL_PATHS_OK: paths exist; direct file navigation skipped by managed browser policy.')
        print(f'Review captures: {CAPTURES}')
        await browser.close()

asyncio.run(main())
