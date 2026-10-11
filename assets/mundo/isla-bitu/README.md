# Isla Bītu — datos y sprites utilizados

`isla.json` define el exterior jugable: costa, río, puentes, muelles, senderos, seis regiones, once lugares y comienzo en ruinas. `edificios.json` registra nueve fachadas completas y trece muebles reutilizados, junto con coordenadas, escala uniforme, huellas y SHA-256/bytes de cada fuente anterior.

Los22PNG de `sprites/` son importaciones nativas de fuentes existentes; no reemplazan ni alteran esas fuentes. Copia de ejecución sincronizada en `prueba/assets/mundo/isla-bitu/`. Ruinas y casa original se reutilizan desde sus registros anteriores.

Para reproducir la importación: desde raíz, `python prueba/tools/register_island.py`, con Godot4.6.3 disponible y directorios XDG escribibles. La transformación gráfica la realiza `prueba/tools/bake_island_assets.gd`: recorte, escala uniforme nearest y eliminación de alfa de fondo casi transparente. No se estiran piezas ni se generan ilustraciones.

El registro no regenera la geografía. Conservar `isla.json` al ajustar el arte. [Alcance, controles y límites de la prueba](../../../docs/isla-y-mochila-prueba.md).
