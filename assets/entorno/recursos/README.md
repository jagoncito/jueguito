# Recursos de terreno y botín

**Creación autorizada el 9 de octubre de 2026:** el usuario pidió crear los dos atlas que faltaban, adaptarlos a pixel art y escala del juego y subir esta entrega. Son fuentes nuevas; no recuperaciones de los PNG perdidos. Se conserva cada original generado sin editar y su copia idéntica dentro de la prueba.

Primera entrega integrada en la prueba Godot de Bītu. Perspectiva elevada 3/4, luz superior izquierda y transparencias reales. No modifica el dragón ni las herramientas.

| Recurso | En el terreno | Tras extraerlo | Botín distinto |
|---|---|---|---|
| Árbol | Tres siluetas, 192–208 px de alto | Tocón correspondiente, 36–38 px | Troncos cortados con corteza y anillos |
| Mena de cobre | Roca gris con vetas cobrizo-rojizas, 56×52 px aprox. | Estado picado; desaparece al terminar | Fragmento de roca con cobre, no un lingote |
| Flor de Yde | Planta de dos flores violetas, 36 px de alto | Desaparece al recoger | Una flor con tallo corto y hoja |

Referencia: suelo 64×32 px, humanoides 80 px y dragón actual 90 px. Los objetos del suelo se presentan dentro de 32×32 px, con silueta máxima 28 px; la mochila usa marcos de 64×64 px. El mismo botín se reconoce en ambas presentaciones, sin reutilizar el recurso plantado como miniatura.

## Archivos y uso

- `arboles-y-tocones.png`: tres árboles y tres tocones.
- `recursos-y-botin.png`: cobre entero/picado, Yde plantada y tres objetos de botín.
- `recursos.json`: regiones, anclajes de suelo, escala uniforme y correspondencias de objetos.

Los PNG originales generados se conservan sin recortes ni sobrescrituras. `recursos.json` registra sus huellas SHA-256, las regiones medidas y las anclas de apoyo. Ambos estados del cobre comparten escala y altura de ancla. Cada fuente mide 1536×1024: **no son hojas nativas de 32 px**. Godot utiliza `AtlasTexture`, recortes registrados y filtro nearest para representarlas a la escala indicada. Las copias en `prueba/assets/entorno/recursos/` son idénticas a estas fuentes y permiten exportar el proyecto independiente.

Los árboles alternan las tres siluetas sin introducir rotación de cámara. El clic respeta los píxeles opacos del dibujo; la copa no amplía la colisión del tronco. Talar deja el tocón transitable. Se conservan las reglas provisionales: cinco golpes/3 madera, cinco golpes/1 cobre, una extracción/1 flor, reaparición de mena/flor en 14 s y botín durante 600 s. Los árboles no regeneran hasta reiniciar.

No se asignan todavía efectos alquímicos, rarezas ni una especie arbórea definitiva.

## Verlo y comprobarlo

Abre `prueba/scenes/recursos.tscn` con F6 o añade `?vista=recursos` al navegador. Permite alternar los tres árboles, sus tocones y el estado del cobre. F5 abre la granja con estos recursos integrados.

Pruebas: `prueba/tests/resources-smoke.gd`, las regresiones existentes y `prueba/tools/resources_browser_smoke.py` / `browser_smoke.py` sobre la exportación servida en `http://127.0.0.1:8765`.

[Comparación dentro de Godot](../../../prueba/capturas/recursos-y-botin.png) · [Granja](../../../prueba/capturas/recursos-en-juego.png) · [Estados extraídos](../../../prueba/capturas/recursos-estados.png).
