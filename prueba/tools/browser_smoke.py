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
            await page.screenshot(path=str(PROJECT / "capturas/recursos-en-juego.png"))
            await page.mouse.wheel(0,120)
            await page.wait_for_timeout(100)
            # Entrar en el alcance desde el norte, sin bajar hasta el árbol.
            await move(page, "s", 120)
            await page.mouse.click(668, camera_y(576-20, 528+24))
            await page.wait_for_timeout(180)
            await page.screenshot(path=str(PROJECT / "build/minando.png"))
            await page.wait_for_timeout(3400)
            await page.screenshot(path=str(PROJECT / "build/mineral-recogido.png"))
            assert any("BITU_PICKUP:mineral:1" in entry["text"] for entry in messages), "Cobre no recogido"
            # Árbol cercano a la orilla, aproximación desde la derecha.
            await move(page, "s", 610)
            await move(page, "a", 150)
            # La copa no decide el alcance: acercarse a la base real. El
            # número de pasos puede variar en WebGL por software.
            for attempt in range(4):
                await page.mouse.click(610, 410)
                await page.wait_for_timeout(180)
                await page.screenshot(path=str(PROJECT / "build/talando.png"))
                await page.wait_for_timeout(3400)
                if any("BITU_PICKUP:madera:3" in entry["text"] for entry in messages):
                    break
                await move(page, "s", 120)
                await move(page, "a", 50)
            await page.screenshot(path=str(PROJECT / "build/tala-final.png"))
            assert any("BITU_PICKUP:madera:3" in entry["text"] for entry in messages), "Madera no recogida"
            await page.screenshot(path=str(PROJECT / "capturas/recursos-tala.png"))
            # Reiniciar para acercarse a la flor desde el oeste.
            await page.reload(wait_until="networkidle")
            await page.wait_for_function("document.getElementById('status') === null", timeout=60000)
            await page.wait_for_timeout(500)
            await page.mouse.wheel(0,120)
            await page.wait_for_timeout(100)
            await move(page, "d", 1100)
            # Selección con zoom: comprobar la conversión de ratón a mundo.
            await page.mouse.move(700,450)
            for _ in range(2):
                await page.mouse.wheel(0,-120)
                await page.wait_for_timeout(100)
            # Corregir la aproximación con el resultado visible, no solo tiempo
            # de teclado: WebGL por software puede reducir los pasos de física.
            for attempt in range(12):
                shot = Image.open(io.BytesIO(await page.screenshot(path=str(PROJECT / "build/flor-aproximacion.png")))).convert("RGB")
                petals = [(x,y) for y in range(170,550) for x in range(360,970)
                          if purple(shot.getpixel((x,y)))]
                assert petals, "No se ve la flor para seleccionarla"
                flower_x = sum(x for x,y in petals)/len(petals)
                flower_y = sum(y for x,y in petals)/len(petals)
                if abs(flower_x-640) <= 64:
                    break
                await move(page, "d" if flower_x > 640 else "a", 100)
            assert abs(flower_x-640) <= 64, f"No se logró entrar en alcance de la flor: {flower_x:.1f}, {flower_y:.1f}"
            # Seleccionar un pétalo opaco, no el hueco entre las dos flores.
            click_x, click_y = min(petals,key=lambda p:(p[0]-flower_x)**2+(p[1]-flower_y)**2)
            # Dejar que Godot actualice el ratón antes del botón: con WebGL
            # por software, mover y pulsar en el mismo frame puede conservar
            # la posición anterior al consultar get_global_mouse_position().
            await page.mouse.move(click_x, click_y)
            await page.wait_for_timeout(180)
            await page.mouse.click(click_x, click_y, delay=80)
            await page.wait_for_timeout(500)
            await page.screenshot(path=str(PROJECT / "build/recogiendo-flor.png"))
            await page.screenshot(path=str(PROJECT / "capturas/recursos-yde.png"))
            await page.wait_for_timeout(600)
            await page.screenshot(path=str(PROJECT / "build/palin-en-tierra.png"))
            await page.wait_for_timeout(1800)
            await page.screenshot(path=str(PROJECT / "build/flor-recogida.png"))
            assert any("BITU_PICKUP:flor:1" in entry["text"] for entry in messages), "Yde no llegó a la mochila"
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


def purple(rgb):
    r, g, b = rgb
    return r > 110 and 45 < g < 175 and r > g*1.25 and b > r*1.06


if __name__ == "__main__":
    asyncio.run(main())
