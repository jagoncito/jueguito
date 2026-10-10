# Ruinas y camino costero — fuentes visuales

Generación solicitada el 10 de octubre de 2026. El usuario solicita después generar el lote de piezas y publicarlo en GitHub. Sin integración solicitada.

- [Ruinas](referencias/ruinas-fuente.png): patio, arco, muros, columnas, escombros, pavimento, escalones y acantilado; piezas aisladas para registro posterior.
- [Recorrido largo](referencias/camino-ruinas-astillero-fuente.png): vista de conjunto desde las ruinas orientales al astillero de la bahía, con curvas, desniveles, bosque costero y calas. Incluye ejemplos separados de terreno y vegetación.
- [Explicación de zonas, cámara y preparación](../../../docs/recorrido-ruinas-astillero.md).

La vista general está a escala de planificación: la distancia jugable se construirá con suelo y módulos a escala común, sin estirar la ilustración. No está determinada todavía en casillas o minutos. Mantener un recorrido inicial único y largo, sin nuevo asentamiento intermedio. Herrería lejana; maestro enano de paso con Flavia.

Son fuentes, no atlas nativos. Deben recortarse y comprobarse escala, anclas, transparencia, uniones y colisiones. La fuente de ruinas presenta halos de color y detalles en los bordes que requieren limpieza antes de integrarla. La panorámica simplifica las estructuras: su patio no reproduce exactamente la lámina de ruinas; al construir se usará una sola versión coherente. Sus rótulos no forman parte del suelo jugable. Los tramos aislados aún no garantizan repetición sin costuras.

## Lote de 48 piezas registrado

- **16 suelos:** dos hierbas, tierra, pavimento, dos rectas, cuatro curvas, cuatro finales, pavimento con musgo y transición a hierba.
- **16 piezas de ruinas:** tres muros bajos/esquina, arco, dos columnas, dos columnas caídas, dos escombros, dintel, pedestal, dos escalones y dos muros altos.
- **16 piezas de costa:** cuatro acantilados, dos rampas, dos rocas, dos árboles, dos arbustos, hierbas, dos flores y tronco.

Tres atlas originales RGBA en `atlas/`. [Catálogo](assets.json) con regiones medidas, escala uniforme y anclas de referencia; 48 `AtlasTexture` en `texturas/` y 48 prefabs en `prefabs/`, con filtro nearest. Las imágenes no se duplican por pieza. [Galería local](index.html): descargar la carpeta completa y abrir el HTML; no necesita servidor ni dependencias. A/B identifican variantes visuales, no garantizan orientaciones opuestas.

Los prefabs pueden copiarse **con atlas y texturas**, conservando la estructura de carpetas, al proyecto Godot. No incluyen colisiones. No se han integrado en el mapa ni se ha actualizado la descarga jugable por esta entrega.

### Revisión y límites

Los 48 recursos y prefabs se comprueban con Godot. El script `tools/register_assets.py` reproduce el registro leyendo las imágenes sin modificarlas; requiere Pillow, numpy y scipy. Las fuentes no tienen celdas perfectamente regulares: se miden las siluetas principales en lugar de cortar por una cuadrícula supuesta. Los detalles desconectados pequeños no definen los límites del recorte.

**Escalas y anclas provisionales, no aprobación final de tamaño.** Los suelos tienen ancho dibujado de referencia 64 px, pero alto cercano a 40–42 px en vez de 32: no son aún un TileSet de rombos exactos 64×32. Corregir geometría/uniones antes de sustituir el suelo jugable, sin deformar por separado ancho y alto. Las piezas de acantilado necesitan verificar perfiles y altura al ensamblarse. Los halos residuales requieren limpieza y el arco debe probarse con personaje antes de fijar su entrada. Los recortes actuales permiten seleccionar piezas, pero no sustituyen la revisión artística.

Se reutilizarán el agua/orillas y el astillero ya existentes. La longitud del camino la define la construcción del escenario, no el número de dibujos ni el tamaño de estas hojas. Sin números finales de casillas o minutos.
