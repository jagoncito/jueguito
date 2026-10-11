# Fuentes anteriores del dragón

Material único conservado fuera de ejecución: `mineria.png` y `tala.png`. Sus bytes originales no se modificaron. Estos dibujos se sustituyen tras comprobar las hojas completas nuevas; no son el catálogo activo ni la referencia de movimiento aprobada.

El sprint NORTE revisado se conserva íntegro en `../../sprites/conservados/sprint-norte.png`. La marcha anterior permanece en `../../sprites/conservados/marcha.png` porque su dirección NORTE sigue siendo necesaria. Reposo, recolección, pesca y garras aceptadas también permanecen en `sprites/conservados/`. El atlas de recortes articulados rechazado y su registro se retiraron, junto con su renderizador y registrador.

`register_dragon_antes.py` lee el `registro-fuentes.json` histórico de las diez fuentes, incluidas las conservadas, y reconstruye el catálogo previo de216nombres. Solo escribe `work/bitu-fotogramas/registro-anterior/dragon-jugable-anterior.json`; no copia PNG ni altera los archivos activos. Para revisar medidas históricas desde la raíz:

```sh
python assets/personajes/dragon/referencias/anteriores/register_dragon_antes.py
```

No ejecutar este registro histórico como sustituto del compilador vigente. Las referencias, fases no utilizadas y fuentes anteriores no prueban por sí mismas una animación correcta.
