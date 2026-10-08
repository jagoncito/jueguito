"""Renderiza y graba la revisión real del dragón exportada por Godot."""
import asyncio
import io
from pathlib import Path
from PIL import Image, ImageChops
from playwright.async_api import async_playwright

PROJECT = Path(__file__).resolve().parents[1]


async def main():
    messages = []
    async with async_playwright() as playwright:
        browser = await playwright.chromium.launch(
            executable_path="/usr/bin/chromium", headless=True,
            args=["--no-sandbox", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--disable-dev-shm-usage"])
        context = await browser.new_context(
            viewport={"width": 1280, "height": 720}, device_scale_factor=1)
        page = await context.new_page()
        page.on("console", lambda message: messages.append((message.type, message.text)))
        page.on("pageerror", lambda error: messages.append(("pageerror", str(error))))
        try:
            await page.goto("http://127.0.0.1:8765/index.html?vista=dragon", wait_until="networkidle")
            await page.wait_for_function("document.getElementById('status') === null", timeout=60000)
            await page.wait_for_timeout(350)
            # Grabar el canvas después de cargar: vídeo real, sin volver a dibujar assets.
            await page.evaluate("""() => {
                const chunks = [];
                const recorder = new MediaRecorder(document.querySelector('canvas').captureStream(25), {mimeType: 'video/webm'});
                window.dragonRecorder = recorder;
                window.dragonVideo = new Promise(resolve => {
                    recorder.ondataavailable = event => { if (event.data.size) chunks.push(event.data); };
                    recorder.onstop = async () => resolve(Array.from(new Uint8Array(await new Blob(chunks).arrayBuffer())));
                });
                recorder.start();
            }""")
            first = await page.screenshot(path=str(PROJECT / "capturas/dragon-animaciones.png"))
            await page.wait_for_timeout(1300)
            second = await page.screenshot()
            first_image = Image.open(io.BytesIO(first)).convert("RGB")
            second_image = Image.open(io.BytesIO(second)).convert("RGB")
            # Verificar cambios renderizados en las cinco acciones, no solo el título.
            for bounds in [(450,100,800,340),(860,100,1230,340),
                           (30,400,400,670),(450,400,800,670),(860,400,1230,670)]:
                delta = ImageChops.difference(first_image.crop(bounds), second_image.crop(bounds))
                assert delta.getbbox() is not None, f"Animación congelada en {bounds}"
            await page.wait_for_timeout(3000)
            encoded = await page.evaluate("""async () => {
                window.dragonRecorder.stop();
                return await window.dragonVideo;
            }""")
            (PROJECT / "capturas/dragon-animaciones.webm").write_bytes(bytes(encoded))
            assert any("BITU_DRAGON_PREVIEW_READY" in text for _, text in messages), messages
            assert not any(kind in {"error", "pageerror"} for kind, _ in messages), messages
            print("BITU_DRAGON_BROWSER_SMOKE_OK")
        finally:
            if any(kind in {"error", "pageerror"} for kind, _ in messages):
                print(messages)
            await context.close()
            await browser.close()


if __name__ == "__main__":
    asyncio.run(main())
