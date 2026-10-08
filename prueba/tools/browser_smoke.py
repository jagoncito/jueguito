"""Revisión real de movimiento, minería y tala en la exportación web local."""
import asyncio
import json
import io
from pathlib import Path
from PIL import Image
from playwright.async_api import async_playwright

PROJECT = Path(__file__).resolve().parents[1]


async def main():
    messages = []
    async with async_playwright() as playwright:
        browser = await playwright.chromium.launch(
            executable_path="/usr/bin/chromium", headless=True,
            args=["--no-sandbox", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--disable-dev-shm-usage"])
        page = await browser.new_page(viewport={"width": 1280, "height": 720}, device_scale_factor=1)
        page.on("console", lambda message: messages.append({"type": message.type, "text": message.text}))
        page.on("pageerror", lambda error: messages.append({"type": "pageerror", "text": str(error)}))
        try:
            await page.goto("http://127.0.0.1:8765/index.html", wait_until="networkidle")
            await page.wait_for_function("document.getElementById('status') === null", timeout=60000)
            await page.wait_for_timeout(500)
            await page.screenshot(path=str(PROJECT / "build/entrada.png"))
            # Entrar en el alcance desde el norte, sin bajar hasta el árbol.
            await move(page, "s", 120)
            await page.mouse.click(668, camera_y(576-20, 528+24))
            await page.wait_for_timeout(180)
            await page.screenshot(path=str(PROJECT / "build/minando.png"))
            await page.wait_for_timeout(2300)
            await page.screenshot(path=str(PROJECT / "build/mineral-recogido.png"))
            # Árbol cercano a la orilla, aproximación desde la derecha.
            await move(page, "s", 610)
            await move(page, "a", 150)
            await page.mouse.click(610, 410)
            await page.wait_for_timeout(180)
            await page.screenshot(path=str(PROJECT / "build/talando.png"))
            await page.wait_for_timeout(2800)
            await page.screenshot(path=str(PROJECT / "build/tala-final.png"))
            # Reiniciar para acercarse a la flor desde el oeste.
            await page.reload(wait_until="networkidle")
            await page.wait_for_function("document.getElementById('status') === null", timeout=60000)
            await page.wait_for_timeout(500)
            await move(page, "d", 1100)
            # Selección con zoom: comprobar la conversión de ratón a mundo.
            await page.mouse.move(700,450)
            for _ in range(2):
                await page.mouse.wheel(0,-120)
                await page.wait_for_timeout(100)
            shot = Image.open(io.BytesIO(await page.screenshot())).convert("RGB")
            petals = [(x,y) for y in range(170,550) for x in range(360,970)
                      if shot.getpixel((x,y)) == (191,154,194)]
            assert petals, "No se ve la flor para seleccionarla"
            await page.mouse.click(sum(x for x,y in petals)/len(petals), sum(y for x,y in petals)/len(petals))
            await page.wait_for_timeout(500)
            await page.screenshot(path=str(PROJECT / "build/recogiendo-flor.png"))
            await page.wait_for_timeout(600)
            await page.screenshot(path=str(PROJECT / "build/palin-en-tierra.png"))
            await page.wait_for_timeout(1800)
            shot = Image.open(io.BytesIO(await page.screenshot(path=str(PROJECT / "build/flor-recogida.png")))).convert("RGB")
            assert any(shot.getpixel((x,y)) == (197,164,199)
                       for y in range(80,460) for x in range(980,1250)), "La flor no llegó a la mochila"
            assert any("BITU_READY" in entry["text"] for entry in messages), "No arrancó Bītu"
            assert not any(entry["type"] in {"error", "pageerror"} for entry in messages), messages
            print("BITU_BROWSER_SMOKE_OK")
        finally:
            (PROJECT / "build/browser-log.json").write_text(json.dumps(messages, ensure_ascii=False, indent=2))
            await browser.close()


async def move(page, key, milliseconds):
    await page.keyboard.down(key)
    await page.wait_for_timeout(milliseconds)
    await page.keyboard.up(key)
    await page.wait_for_timeout(60)


def camera_y(world_y, player_y):
    return 360 + world_y - (player_y - 100)


if __name__ == "__main__":
    asyncio.run(main())
