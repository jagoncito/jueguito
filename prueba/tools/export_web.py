"""Exporta datos con Godot 4.6.3 y reutiliza el runtime web incluido en el ZIP."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import hashlib
import json
import os
import re
import shutil
import subprocess

PROJECT = Path(__file__).resolve().parents[1]
ARCHIVE = PROJECT / "descargas/bitu-navegador.zip"
OUTPUT = PROJECT / "build/web"
RUNTIME_SHA256 = "26b61ce95247012ab3dca3ff51e96d1cdbff44ee91a8c20a83e150afca83f1b6"
INSTRUCTIONS = """BĪTU — Primera prueba visual

Requiere Python 3 y navegador con WebGL 2 (Chrome, Edge o Firefox actualizado).
Descomprime todo el ZIP. Ejecuta python JUGAR.py desde la carpeta bitu-navegador.
Se abrirá el navegador automáticamente. Mantén la ventana de Python abierta mientras juegas.
WASD: mover; rueda: zoom; Tab: mochila.
Clic izquierdo sobre una mena, árbol o flor cercana: completa toda la extracción.
No hace falta mantener pulsado ni repetir clics por golpe.
Para flores se equipa el palín y el personaje se arrodilla, extrae y se levanta.
E: plantar, regar o cosechar.
Dragón bípedo: ocho direcciones, cola conectada, caminar, minar, talar y palín.
Para ver ocho direcciones ampliadas, añade ?vista=dragon a la URL del juego.
Teclas de revisión: 1 reposo, 2 marcha, 3 minar, 4 talar, 5 palín.
No guarda progreso. Entorno y animaciones de prototipo.
Sin Python, usa el repositorio y Godot 4.6.3: importar prueba/project.godot y F5.
"""


def main():
    engine = os.environ.get("BITU_GODOT", "godot")
    version = subprocess.check_output([engine, "--version"], text=True).strip()
    if not version.startswith("4.6.3.stable."):
        raise RuntimeError(f"Esta exportación requiere Godot 4.6.3; disponible: {version}")
    OUTPUT.mkdir(parents=True, exist_ok=True)
    (PROJECT / "build/.gdignore").touch()
    with ZipFile(ARCHIVE) as archive:
        runtime = archive.read("bitu-navegador/web/index.wasm")
        if hashlib.sha256(runtime).hexdigest() != RUNTIME_SHA256:
            raise RuntimeError("El runtime web no coincide con la versión incluida y comprobada.")
        for name in archive.namelist():
            if name.startswith("bitu-navegador/web/") and not name.endswith("index.pck"):
                (OUTPUT / Path(name).name).write_bytes(archive.read(name))
        launcher = archive.read("bitu-navegador/JUGAR.py")
    subprocess.run([engine, "--headless", "--path", str(PROJECT), "--export-pack", "Web", str(OUTPUT / "index.pck")], check=True)
    html = (OUTPUT / "index.html").read_text()
    pattern = r"const GODOT_CONFIG = (\{[^\n]+\});"
    match = re.search(pattern, html)
    if match is None:
        raise RuntimeError("No se encuentra la configuración del contenedor web.")
    config = json.loads(match.group(1))
    config["args"] = []
    config["fileSizes"]["index.pck"] = (OUTPUT / "index.pck").stat().st_size
    config["fileSizes"]["index.wasm"] = len(runtime)
    legacy_preview = '\nif (new URLSearchParams(location.search).get("vista") === "dragon") { GODOT_CONFIG.args = ["res://scenes/dragon.tscn"]; }'
    # El runtime web no admite rutas de escena como argumentos de arranque.
    # El propio proyecto lee el selector de revisión; limpiar el contenedor anterior.
    html = html.replace(legacy_preview, "")
    html = re.sub(pattern, lambda _: "const GODOT_CONFIG = " + json.dumps(config, separators=(",", ":")) + ";", html)
    (OUTPUT / "index.html").write_text(html)
    temporary = OUTPUT.parent / "bitu-navegador.zip.tmp"
    with ZipFile(temporary, "w", ZIP_DEFLATED) as archive:
        for file in sorted(OUTPUT.iterdir()):
            if file.is_file() and not file.name.endswith(".import"):
                archive.write(file, "bitu-navegador/web/" + file.name)
        archive.writestr("bitu-navegador/JUGAR.py", launcher)
        archive.writestr("bitu-navegador/LEEME.txt", INSTRUCTIONS)
    with ZipFile(temporary) as archive:
        if archive.testzip() is not None:
            raise RuntimeError("La descarga no supera su comprobación de integridad.")
    shutil.move(temporary, ARCHIVE)
    print(f"Datos exportados y descarga actualizada: {ARCHIVE}")


if __name__ == "__main__":
    main()
