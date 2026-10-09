# Primera prueba visual de Bītu

**Entrega de recursos (9 de octubre de 2026):** integrados los 22 archivos de texto recuperados, conservando la revisión anterior del dragón y el sprint. Por petición explícita del usuario se han creado los dos atlas que faltaban, adaptados al juego. No son los PNG perdidos: las regiones, anclas, escalas y huellas se han vuelto a medir sobre estas fuentes nuevas. Los originales están en `assets/entorno/recursos/`, con copias idénticas en la prueba. La generación, integración y subida de esta entrega están autorizadas; la aprobación visual del protagonista sigue pendiente.

**Verificación de esta entrega:** importación con Godot 4.6.3 y cinco pruebas superadas: inventario, herramientas, escena, dragón (con `--fixed-fps 60`) y recursos. Las dos revisiones en Chromium/WebGL 2 pasan: variantes, tocón, daño del cobre y recogida real por clic de cobre, madera y Yde, sin errores de consola. La descarga se ha regenerado, su ZIP pasa la comprobación de integridad y el runtime coincide con Godot 4.6.3. PNG originales y copias idénticos, regiones dentro de los atlas, escalas uniformes y anclas comprobadas. La revisión ampliada deja espacio para el árbol más alto sin solapar rótulos. Las pruebas web ajustan la aproximación al tronco y los pétalos ante el ritmo variable de WebGL por software; las reglas de interacción se conservan.

Una pequeña escena para revisar **el aspecto y la escala**. El terreno, la casa y los cultivos siguen siendo referencias temporales dibujadas por Godot. Árboles, cobre y flor de Yde usan ahora atlas pixel art registrados. Los cuatro tomates son PNG originales. El dragón protagonista bípedo tiene ahora ocho vistas y anatomía reajustada por petición del usuario; conserva rasgos faciales y paleta. El PNG de referencia original sigue intacto. Presentación con vecino más cercano.

La [ficha del dragón](../assets/personajes/dragon-avatar/README.md) registra siete atlas con poses completas y una altura erguida normalizada de 90 px en el juego. Cola y extremidades están dibujadas en cada pose, sin piezas estiradas. Marcha, carga, golpe y palín se revisan en ocho direcciones con `prueba/scenes/dragon.tscn` (F6), o `?vista=dragon` en la exportación web. Teclas **1 reposo, 2 marcha, 3 minar, 4 talar, 5 palín**; vista ampliada ×2. Orientación hacia el suelo del recurso, separada de la altura del impacto. Las celdas de atlas se limpian en memoria de pequeños componentes desconectados para evitar rayas de otros fotogramas; los PNG fuente permanecen intactos. Riego con regadera, pesca y combate todavía sin animaciones propias.

## Recursos de terreno y botín

Se integran tres variantes de árbol de 192–208 px con sus tocones; cobre entero/picado de unos 56×52 px y Yde violeta plantada de 36 px. Madera cortada, fragmento de cobre y una flor recogida tienen imágenes de botín distintas del recurso en el terreno. El botín mantiene su marco 32×32, la mochila 64×64 y el dragón unos 90 px. Los PNG fuente se conservan íntegros: son atlas generados de 1536×1024, recortados mediante AtlasTexture y representados con filtro nearest, no hojas nativas de 32 px.

La selección por clic respeta el alfa del dibujo. Las tres siluetas no cambian la cámara ni la colisión de la base. El cobre cambia de aspecto al primer golpe y restaura su estado al reaparecer; talar deja un tocón transitable. Los tiempos y cantidades del prototipo no cambian. Tampoco se asignan efectos alquímicos ni rarezas a Yde.

Revisión: `prueba/scenes/recursos.tscn` con F6, o `?vista=recursos` en navegador. Compara escala con el dragón, variantes, estados, botín y mochila. [Atlas y medidas](../assets/entorno/recursos/README.md) · [Captura comparativa](../prueba/capturas/recursos-y-botin.png) · [Granja](../prueba/capturas/recursos-en-juego.png).

## Qué se puede probar

**Movimiento y agarre revisados:** cuatro dibujos de marcha por dirección, incluidos perfiles y diagonales; vistas traseras que avanzan alejándose de la cámara. La marcha sigue la distancia recorrida y se detiene al quedar bloqueado. Mangos sobre palmas medidas, dedos delante del mango y herramientas delante/detrás del torso según la vista. Pico–hacha y palín cuentan con ocho proyecciones propias. Las ruinas se definen en el bloc como refugio costero con patio de llegada; ese nivel todavía no está incluido.

- Caminar con **WASD** y mantener **Shift** para el sprint provisional, con colisiones en agua, casa, bases de árboles y límites. La marcha sigue el desplazamiento real y las diagonales mantienen la velocidad normalizada.
- Ajustar el zoom con la **rueda**.
- Acercarse a las parcelas y pulsar **E** para plantar, regar o cosechar según su estado.
- Acercarse a una mena, árbol o flor y hacer **un clic izquierdo sobre ese recurso** para completar toda la extracción, sin mantener pulsado ni repetir clics. Clic en suelo no usa el recurso más cercano; clic desde lejos pide acercarte. E se conserva para las parcelas.
- Ver el pico–hacha equipado: golpear la mena con la punta y talar un árbol con el filo, con ambas manos sobre el mango y efectos de impacto. El último golpe suelta el botín; el árbol deja un tocón transitable y madera.
- Recoger objetos al pasar cerca. Los tipos de tomate se mantienen separados en la mochila.
- Mostrar u ocultar la mochila con **Tab**.

Los cuatro tomates junto a la orilla son **muestras de comparación**, no un ejemplo de rareza normal. Las cosechas de esta prueba dan tomate común y aumentan el contador de experiencia del tomate. Todavía no hay probabilidades de calidad ni variantes en la cosecha.

Las herramientas se indican aparte de la mochila. Huecos interactivos, requisitos y mejoras pendientes. El [palín de herborista](../assets/herramientas/palin-herborista/README.md) se equipa para la flor: pose arrodillada en cada dirección, paladas breves, extracción y recuperación. El mango se registra en la palma y el cambio de apoyo limita su escala; no desplaza al jugador ni cambia el alcance. La elevación E conserva la pose baja porque el fotograma generado de elevación no mantenía correctamente su perfil. El acabado sigue siendo de prototipo.

El 8 de octubre se integra el **pico–hacha en la granja**, tras delegar el usuario el siguiente paso técnico. Los brazos acompañan la herramienta; el trabajo bloquea el movimiento hasta acabar la recuperación del golpe final. Recoger flores guarda la herramienta. Se conserva la escena independiente `prueba/scenes/herramienta.tscn`, abrir con F6, para revisar escala y componentes. Las mejoras de materiales siguen pendientes. [Medidas, agarre y uso](../assets/herramientas/pico-hacha/README.md).

## Ejecutar en tu ordenador

Instala **Godot 4.6.3 estándar**, descarga el proyecto y usa **Importar** para abrir `prueba/project.godot`. Pulsa **F5** para jugar. No hace falta Node, npm ni compilar manualmente.

Hay una [descarga de navegador ya preparada](../prueba/descargas/bitu-navegador.zip): descomprime todo y ejecuta `python JUGAR.py` dentro de `bitu-navegador` con Python 3. Abre automáticamente el navegador y mantiene el servidor local mientras la terminal esté abierta.

Para regenerar la versión de navegador sin descargar plantillas, ejecuta `python prueba/tools/export_web.py` desde la raíz del repositorio, con Godot 4.6.3 disponible. Exporta el paquete actual, reutiliza el runtime 4.6.3 incluido en el ZIP, verifica su huella y actualiza la descarga. Como alternativa, instala las plantillas de la misma versión y usa **Proyecto → Exportar → Web**. Sirve el resultado mediante HTTP; abrir el HTML con doble clic no carga WebAssembly correctamente. Se incluye una configuración sin hilos. El navegador necesita WebGL 2.

Esta entrega incluye la petición explícita del usuario de integrar el palín y subirlo a GitHub para probarlo. La publicación como sitio web sigue pendiente. [Carpeta de la prueba](../prueba/README.md).

## Parámetros provisionales

| Referencia | Valor de esta prueba |
|---|---|
| Suelo / dragón / botín / iconos | 64 × 32 / unos 90 de alto / 32 × 32 / 64 × 64 píxeles |
| Sector | 32 × 32 casillas |
| Mochila | 12 huecos; pilas de hasta 50 |
| Movimiento | 150 píxeles por segundo |
| Sprint provisional | 225 píxeles por segundo; Shift |
| Zoom | 0,75; 1; 1,5 inicial; 2 |
| Recogida / interacción | 29 / 47 píxeles |
| Minería / tala | 3 / 4 golpes; 0,62 segundos por golpe |
| Impacto de cada golpe | A los 0,33 segundos |
| Recolección de flores / reaparición de mena y flor | 2 / 14 segundos |
| Extracción con palín / recuperación | Botín a los 1,5 s; levantarse y recuperar control a los 2 s |
| Rendimiento por mena / árbol | 1 mineral / 3 maderas |
| Árbol talado | Tocón transitable; persiste hasta recargar |
| Botín temporal de prueba | 10 minutos |
| Crecimiento de tomate / riego | 12 / 8 segundos activos |

Estos valores permiten revisar rápido, no fijan dificultad, velocidad o economía definitivas. La regeneración de árboles queda por diseñar; los diez minutos se aplican al botín de esta prueba, sin fijar ese plazo para madera en el juego completo. Sin agua se conserva el cultivo y su progreso. Se recoge lo que cabe y el resto mantiene su plazo en el suelo.

## Límites

**No guarda progreso**: recargar o cerrar reinicia la escena. No incluye pesca activa, navegación, habitantes, relato inicial, enemigos, combate, museo, construcción libre de parcelas ni producción gráfica definitiva. La granja usa parcelas precolocadas para esta revisión de escala; la libertad de distribución sigue siendo el diseño previsto.

## Comprobaciones

`tests/smoke.gd` comprueba capacidad y recogida parcial, separación de calidad y variante, conservación del crecimiento sin riego, reaparición dentro de la zona y conversión isométrica.

`tests/tool-smoke.gd` comprueba el registro de piezas, la sustitución independiente de sus texturas y las señales del movimiento. `tests/scene-smoke.gd` ejecuta la granja y comprueba selección por clic frente a otro recurso más cercano, alcance, clic en suelo, impactos sin entregas anticipadas ni duplicadas, tala, madera, retirada de la colisión del árbol, recolección de flores y colisión real contra el agua. También verifica el palín visible, postura arrodillada, agarre, contacto con la tierra, ambas orientaciones laterales y recuperación de pie. `tests/dragon-smoke.gd` comprueba las ocho orientaciones, el giro hacia la base del recurso aunque el impacto elevado esté en otra dirección, las poses completas sin estirar el cuerpo, agarres, contactos de pico/hacha y palín en todas las vistas y registro independiente de la escala de revisión. También verifica el sprint provisional con Shift. La prueba del dragón comprueba además las cuatro fases distintas por dirección, palmas sobre píxeles dibujados, registro de dedos, perspectiva y profundidad de herramientas, desplazamiento real hacia izquierda/diagonales/espalda y parada o deslizamiento al chocar. La exportación se ha abierto en Chromium con WebGL 2, sin errores de consola; se revisaron minería, tala y flores mediante clics reales y capturas del resultado renderizado. La flor llega a la mochila con un solo clic y otro clic durante el trabajo no reinicia su recolección.

**Verificación de la recuperación (9 de octubre de 2026):** inventario, herramientas y escena pasan con Godot 4.6.3. La prueba del dragón pasa con `--fixed-fps 60`; en tiempo real puede fallar al muestrear «Impacto completo del cuerpo», como ya ocurrió sobre la base anterior al parche. La descarga regenerada pasa las comprobaciones en Chromium de la granja y las ocho direcciones en cinco acciones, sin errores de consola. Se registra esta diferencia de ejecución sin dar por aprobado el acabado visual. La recuperación y subida de esta primera pasada han sido solicitadas expresamente por el usuario.
`tests/resources-smoke.gd` añade comprobaciones de doce recortes, transparencia, anclajes y escala, clic sobre píxeles opacos, variantes de árbol, tocón, daño y reaparición del cobre, botín dentro de 32×32 e iconos de 64×64. Se ejecuta sobre los atlas nuevos creados para esta entrega.

```sh
cd prueba
godot --headless --editor --path . --import
godot --headless --path . --script res://tests/smoke.gd
godot --headless --path . --script res://tests/tool-smoke.gd
godot --headless --path . --script res://tests/scene-smoke.gd
godot --headless --fixed-fps 60 --path . --script res://tests/dragon-smoke.gd
godot --headless --path . --script res://tests/resources-smoke.gd
godot --headless --path . --quit-after 120
python tools/export_web.py
```

En el entorno cloud, anteponer a cada comando Godot:

```sh
env XDG_DATA_HOME=/workspace/.local/godot/data XDG_CONFIG_HOME=/workspace/.local/godot/config XDG_CACHE_HOME=/workspace/.cache/godot
```

Las carpetas deben existir. Aplicar también estas variables al comando Python de exportación, que inicia Godot. No cambiar `HOME`. Para repetir la revisión web en cloud, sirve `prueba/build/web` en el puerto 8765 y ejecuta `python prueba/tools/browser_smoke.py` desde la raíz; requiere Playwright, Pillow y Chromium. Guarda las comprobaciones en `prueba/build` y actualiza las nuevas capturas `recursos-en-juego.png`, `recursos-tala.png` y `recursos-yde.png`. Selecciona un pétalo opaco y comprueba mediante eventos del juego la recogida de cobre, madera y Yde. `python prueba/tools/resources_browser_smoke.py` comprueba en WebGL las tres variantes, el tocón y el cobre picado y guarda la comparación terreno/botín/mochila. Ambas revisiones han pasado en esta entrega, sin errores de consola.

`python prueba/tools/dragon_browser_smoke.py` comprueba las ocho direcciones en los cinco modos de la revisión ampliada y graba el vídeo WebM real del canvas. Después guarda las capturas con una pose fija del mismo controlador y comprueba sus ocho fotogramas: reposo, paso, impacto del pico, impacto del hacha y recolección arrodillada. Comprueba también cuatro poses fijas de marcha y cambios en la zona de pies/rodillas de las ocho vistas, no solo en la herramienta. Esto evita publicar una imagen de reposo etiquetada como minería o tala. La revisión deja visibles los nombres inferiores y permite volver a animar con las teclas 1–5 desde una captura fija. Las capturas y el vídeo se guardan en `prueba/capturas`; no requiere descargar un grabador externo. La configuración de entorno guardada es un borrador; su publicación es independiente de esta prueba.
