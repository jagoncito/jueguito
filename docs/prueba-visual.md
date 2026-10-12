# Primera prueba visual de Bītu

**Revisión de fluidez,12 de octubre:** el usuario comunica tirones y autoriza comenzar la corrección. Terreno en bloques reutilizables con geometría agrupada y precarga incremental; cámara y movimiento continuos entre regiones exteriores. Fundido conservado en puertas. Activación e interacción por cercanía; zoom preparado antes de mostrar su nueva vista. [Diagnóstico, medidas y límites](rendimiento-isla.md). El aspecto de la isla sigue pendiente de rehacer y no se considera aprobado.

**Prueba de isla integrada — 12 de octubre de 2026.** Inicio en las ruinas del este, isla conectada con seis regiones exteriores, diez interiores accesibles con E y los seis habitantes en los patios de sus propiedades. **M** abre el mapa y la cabeza del dragón marca tu ubicación actual; dentro de un edificio señala su propiedad. **Tab** abre una mochila original de supervivencia:24 huecos, pilas de1.000 («1k»), arrastre, intercambio, división con Mayús y ordenación; herramientas aparte. Ambos menús pausan la partida. [Alcance, controles y comprobaciones](isla-y-mochila-prueba.md). La distribución es de prueba: sin guardado, narrativa, comercio, fabricación ni navegación implementados. Se conserva el conjunto vigente del dragón; esta entrega no modifica sus PNG.

**Revisión por fotogramas completos del 11 de octubre de 2026.** Se sustituyen las siete direcciones defectuosas de marcha y sus carreras por seis fases completas; NORTE conserva su marcha y sprint originales de cuatro fases. Reposo, pesca, recolección y garras mantienen sus fuentes y registros aceptados. El rig de piezas articuladas fue rechazado y se ha retirado. Las revisiones anteriores están documentadas en [su diagnóstico histórico](revision-apoyos-y-extremos.md); sus afirmaciones sobre el rig no describen esta versión.

Los nuevos dibujos utilizan celdas192×192, ancla de suelo(96,168), referencia de cuerpo80px y escala final1. El margen permite levantar y bajar el instrumento sin recortar ni reducir el personaje. Se importa la figura completa con un solo factor uniforme y nearest; no se estiran extremidades ni se giran recortes. NE/E/SE reflejan sus vistas completas correspondientes una sola vez, sin invertir el cuerpo durante una media zancada SUR. Marcha alterna contacto, apoyo y paso de cada pierna, con brazos contrarios. Carrera utiliza sus propias poses de apoyo y vuelo.

Minería y tala tienen seis fases: preparación, carga, descenso, impacto, seguimiento y recuperación. La misma herramienta combinada conserva ambos extremos: punta activa contra mena y hoja ancha activa contra árbol. Herramienta y manos están dibujadas junto al personaje; no hay giro independiente. El contacto usa un píxel visible del extremo activo. Cinco golpes, impacto0,33s y golpe0,62s; paso físico previo respetando colisiones y cancelación si no se alcanza el apoyo.

Inventario actual:38PNG activos con copias idénticas en la prueba (ocho originales y30atlas nuevos),58PNG fuente nuevos,96registros conservados y180fotogramas nuevos registrados. Los396nombres del catálogo incluyen120alias para compatibilidad; no son396dibujos distintos. Ochenta poses aceptadas tienen una línea base de píxeles y transformaciones que comprueba su conservación.

[Auditoría y movimientos de archivos](auditoria-archivos-dragon.md) · [Fuentes y sprites del dragón](../assets/personajes/dragon/README.md). La fuente de riego se conserva en referencias, sin integrar esa animación. Los PNG de NPC, terreno, casas, recursos y mapas permanecen iguales al remoto integrado.

**Clic contextual:** recurso activo tiene prioridad; enemigo/suelo libre da un zarpazo hacia el cursor; agua cercana desde costa lanza caña. Garras con un único impacto frontal y alcance limitado. Maniquí al suroeste para comprobar daño; sin criaturas ni IA nuevas y los NPC no reciben daño.

Pesca: lanzamiento, picada, recoger manteniendo clic y aflojar soltándolo; captura, botín y cancelación con Esc. Caña disponible en esta prueba, sin regalo narrativo ni balance definitivo. Recolección conserva los dos PNG,16registros, palín, gesto y tiempos aceptados. Casa con interior transitable y fundido E; los cambios remotos anteriores se conservan.

**Comprobaciones de esta entrega:** once pruebas Godot4.6.3 superadas, conservación exacta de80poses, auditoría de escala/anclas, y Chromium/WebGL para ciclos en ocho direcciones, arranque/parada, impactos reales, extracción de cobre/madera/Yde, pesca con captura/botín/cancelación y zarpazo. Capturas y vídeos del canvas renovados.

La revisión separa funcionamiento de acabado: las pruebas comprueban conservación, escala, anclas, reloj, contactos y comportamiento. No otorgan aprobación artística. Se revisan también ciclos completos, arranque/parada, cambios de dirección y golpes en el canvas de Godot.

Descarga actual de la isla: **38.248.674 bytes**, por debajo del límite de **104.857.600 bytes** por archivo. CRC verificado y PCK idéntico al exportado. SHA-256: `2feaebce6e185f3fa6fbcf408b982b7e58863f3c5a11304ca033b6a5d446e81e`. No requiere dividirse.

Revisión: `?vista=dragon`: **1 reposo,2 marcha,3 minar,4 talar,5 palín,6 parar/andar,7 sprint,8 pesca,9 zarpazo**. Espacio: cámara lenta. `?vista=personajes` compara con habitantes. Para congelar fases: `&captura=marcha-0` a `marcha-5`, o `sprint-0` a `sprint-5`; NORTE mapea sus cuatro fases conservadas. Trabajo: `&captura=minar&tiempo=0.33` o tala, con tiempos0/0,12/0,24/0,33/0,40/0,50. Impactos reales: `?captura=impacto-minar&captura-impacto=1` o tala.

[Vídeo de ciclos](../prueba/capturas/dragon-animaciones.webm) · [Arranque/parada](../prueba/capturas/dragon-parar-andar.webm) · [Minería en juego](../prueba/capturas/impacto-real-minar.png) · [Tala en juego](../prueba/capturas/impacto-real-talar.png).

## Recursos de terreno y botín

Se integran tres variantes de árbol de 192–208 px con sus tocones; cobre entero/picado de unos 56×52 px y Yde violeta plantada de 36 px. Madera cortada, fragmento de cobre y una flor recogida tienen imágenes de botín distintas del recurso en el terreno. El botín mantiene su marco 32×32, la mochila 64×64 y el dragón de 80 px. Los PNG fuente se conservan íntegros: son atlas generados de 1536×1024, recortados mediante AtlasTexture y representados con filtro nearest, no hojas nativas de 32 px.

La selección por clic respeta el alfa del dibujo. Las tres siluetas no cambian la cámara ni la colisión de la base. El cobre cambia de aspecto al primer golpe y restaura su estado al reaparecer; talar deja un tocón transitable. Los tiempos y cantidades del prototipo no cambian. Tampoco se asignan efectos alquímicos ni rarezas a Yde.

Revisión: `prueba/scenes/recursos.tscn` con F6, o `?vista=recursos` en navegador. Compara escala con el dragón, variantes, estados, botín y mochila. [Atlas y medidas](../assets/entorno/recursos/README.md) · [Captura comparativa](../prueba/capturas/recursos-y-botin.png) · [Granja](../prueba/capturas/recursos-en-juego.png).

## Qué se puede probar

**Movimiento y agarre revisados:** fotogramas completos en las vistas corregidas y poses originales en marcha/sprint NORTE; vistas traseras que avanzan alejándose de la cámara. La marcha sigue la distancia recorrida y se detiene al quedar bloqueado. Manos libres al caminar; pico–hacha y dedos dibujados junto al cuerpo en las poses de trabajo. El palín conserva sus proyecciones y registro por separado. Las ruinas se definen en el bloc como refugio costero con patio de llegada; ese nivel está incluido en la prueba de isla del12 de octubre.

- Caminar con **WASD** y mantener **Shift** para el sprint provisional, con colisiones en agua, casa, bases de árboles y límites. La marcha sigue el desplazamiento real y las diagonales mantienen la velocidad normalizada.
- Ajustar el zoom con la **rueda**.
- Acercarse a las parcelas y pulsar **E** para plantar, regar o cosechar según su estado.
- Acercarse a una mena, árbol o flor y hacer **un clic izquierdo sobre ese recurso** para completar toda la extracción, sin mantener pulsado ni repetir clics. Clic en suelo no usa el recurso más cercano; clic desde lejos pide acercarte. E se conserva para las parcelas.
- Ver el pico–hacha equipado: golpear la mena con la punta y talar un árbol con el filo, con ambas manos sobre el mango y efectos de impacto. El último golpe suelta el botín; el árbol deja un tocón transitable y madera.
- Recoger objetos al pasar cerca. Los tipos de tomate se mantienen separados en la mochila.
- Mostrar u ocultar la mochila con **Tab**.
- Comparar los seis personajes con el protagonista y detener/reanudar sus movimientos con **F6**. Su colocación es temporal para esta revisión.

Los cuatro tomates junto a la orilla son **muestras de comparación**, no un ejemplo de rareza normal. Las cosechas de esta prueba dan tomate común y aumentan el contador de experiencia del tomate. Todavía no hay probabilidades de calidad ni variantes en la cosecha.

Las herramientas se indican aparte de la mochila. Huecos interactivos implementados; requisitos y mejoras pendientes. El [palín de herborista](../assets/herramientas/palin-herborista/README.md) se equipa para la flor: pose arrodillada en cada dirección, paladas breves, extracción y recuperación. El mango se registra en la palma y el cambio de apoyo limita su escala; no desplaza al jugador ni cambia el alcance. La elevación E utiliza su nuevo dibujo de perfil, sin reutilizar la pose arrodillada. El acabado sigue siendo de prototipo.

El 8 de octubre se integra el **pico–hacha en la granja**, tras delegar el usuario el siguiente paso técnico. Los brazos acompañan la herramienta; el trabajo bloquea el movimiento hasta acabar la recuperación del golpe final. Recoger flores guarda la herramienta. Se conserva la escena independiente `prueba/scenes/herramienta.tscn`, abrir con F6, para revisar escala y componentes. Las mejoras de materiales siguen pendientes. [Medidas, agarre y uso](../assets/herramientas/pico-hacha/README.md).

## Ejecutar en tu ordenador

Instala **Godot 4.6.3 estándar**, descarga el proyecto y usa **Importar** para abrir `prueba/project.godot`. Pulsa **F5** para jugar. No hace falta Node, npm ni compilar manualmente.

Hay una [descarga de navegador ya preparada](../prueba/descargas/bitu-navegador.zip): descomprime todo y ejecuta `python JUGAR.py` dentro de `bitu-navegador` con Python 3. Abre automáticamente el navegador y mantiene el servidor local mientras la terminal esté abierta.

Para regenerar la versión de navegador sin descargar plantillas, ejecuta `python prueba/tools/export_web.py` desde la raíz del repositorio, con Godot 4.6.3 disponible. Exporta el paquete actual, reutiliza el runtime 4.6.3 incluido en el ZIP, verifica su huella y actualiza la descarga. Como alternativa, instala las plantillas de la misma versión y usa **Proyecto → Exportar → Web**. Sirve el resultado mediante HTTP; abrir el HTML con doble clic no carga WebAssembly correctamente. Se incluye una configuración sin hilos. El navegador necesita WebGL 2.

Esta entrega incluye la petición explícita del usuario de integrar el palín y subirlo a GitHub para probarlo. La publicación como sitio web sigue pendiente. [Carpeta de la prueba](../prueba/README.md).

## Parámetros provisionales

| Referencia | Valor de esta prueba |
|---|---|
| Suelo / dragón / botín / iconos | 64 × 32 / 80 de alto / 32 × 32 / 64 × 64 píxeles |
| Sector | 32 × 32 casillas |
| Mochila | 12 huecos; pilas de hasta 50 |
| Movimiento | 150 píxeles por segundo |
| Sprint provisional | 225 píxeles por segundo; Shift |
| Zoom | 0,75; 1; 1,5 inicial; 2 |
| Recogida / interacción | 29 / 47 píxeles |
| Minería / tala | 5 / 5 golpes iniciales; 0,62 segundos por golpe (3,1 s por extracción) |
| Impacto de cada golpe | A los 0,33 segundos |
| Recolección de flores / reaparición de mena y flor | 2 / 14 segundos |
| Extracción con palín / recuperación | Botín a los 1,5 s; levantarse y recuperar control a los 2 s |
| Rendimiento por mena / árbol | 1 mineral / 3 maderas |
| Árbol talado | Tocón transitable; persiste hasta recargar |
| Botín temporal de prueba | 10 minutos |
| Crecimiento de tomate / riego | 12 / 8 segundos activos |

Estos valores permiten revisar rápido, no fijan dificultad, velocidad o economía definitivas. La regeneración de árboles queda por diseñar; los diez minutos se aplican al botín de esta prueba, sin fijar ese plazo para madera en el juego completo. Sin agua se conserva el cultivo y su progreso. Se recoge lo que cabe y el resto mantiene su plazo en el suelo.

## Límites

**No guarda progreso**: recargar o cerrar reinicia la escena. Incluye pesca activa y zarpazo de prueba. No incluye navegación, servicios de habitantes, relato inicial, enemigos con IA, museo, construcción libre de parcelas ni producción gráfica definitiva. La granja usa parcelas precolocadas para esta revisión de escala; la libertad de distribución sigue siendo el diseño previsto.

## Comprobaciones

`tests/smoke.gd` comprueba capacidad y recogida parcial, separación de calidad y variante, conservación del crecimiento sin riego, reaparición dentro de la zona y conversión isométrica.

`tests/tool-smoke.gd` comprueba el registro de piezas, la sustitución independiente de sus texturas y las señales del movimiento. `tests/scene-smoke.gd` ejecuta la granja y comprueba selección por clic frente a otro recurso más cercano, alcance, clic en suelo, impactos sin entregas anticipadas ni duplicadas, tala, madera, retirada de la colisión del árbol, recolección de flores y colisión real contra el agua. También verifica el palín visible, postura arrodillada, agarre, contacto con la tierra, ambas orientaciones laterales y recuperación de pie. `tests/dragon-smoke.gd` comprueba las ocho orientaciones, el giro hacia la base del recurso aunque el impacto elevado esté en otra dirección, las poses completas sin estirar el cuerpo, agarres, contactos de pico/hacha y palín en todas las vistas y registro independiente de la escala de revisión. También verifica el sprint provisional con Shift. La prueba del dragón comprueba además seis fases por dirección corregida y cuatro en NORTE, palmas sobre píxeles dibujados, registro de dedos, perspectiva y profundidad de herramientas, desplazamiento real hacia izquierda/diagonales/espalda y parada o deslizamiento al chocar. La exportación se ha abierto en Chromium con WebGL 2, sin errores de consola; se revisaron minería, tala y flores mediante clics reales y capturas del resultado renderizado. La flor llega a la mochila con un solo clic y otro clic durante el trabajo no reinicia su recolección.

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

`python prueba/tools/dragon_browser_smoke.py` comprueba las ocho direcciones en los ocho modos de la revisión ampliada y graba el vídeo WebM real del canvas. Después guarda las capturas con una pose fija del mismo controlador y comprueba sus ocho fotogramas: reposo, paso, impacto del pico, impacto del hacha y recolección arrodillada. Comprueba también seis poses fijas de marcha y cambios en la zona de pies/rodillas de las ocho vistas, no solo en la herramienta. Esto evita publicar una imagen de reposo etiquetada como minería o tala. La revisión deja visibles los nombres inferiores y permite volver a animar con las teclas 1–5 desde una captura fija. Las capturas y el vídeo se guardan en `prueba/capturas`; no requiere descargar un grabador externo. La configuración de entorno guardada es un borrador; su publicación es independiente de esta prueba.

### Comprobación de agua y casa

Integración revisada en Godot 4.6.3 y Chromium/WebGL: arranque, movimiento, límite del agua, minería, tala, Yde, botín y mochila. `tests/environment-smoke.gd` comprueba la fachada física y el paso libre por el patio; también pasan smoke, scene-smoke, resources-smoke y tool-smoke. La prueba de navegador completó el recorrido tras repetir el primer intento de Yde. PNG originales idénticos a las copias de ejecución; ZIP actualizado con CRC y paquete comprobados.
Ajuste de cinco golpes: la prueba de escena confirma que cuatro impactos conservan mena y árbol sin botín, y que el quinto completa la extracción. Descarga de navegador regenerada con este ajuste y ZIP comprobado. Las mejoras hasta un golpe quedan como dirección de diseño, todavía sin implementar.

## NPC en partida y revisión de tamaños

Seis NPC con ocho vistas cada uno, colisión en pies, giro al aproximarse e interacciónE de prueba. Protagonista con396nombres de catálogo, incluidos alias. F7/F8 comparan su tamaño80/72px sin cambiar el zoom o los NPC. [Auditoría completa, funcionamiento y capturas del motor](revision-personajes-en-juego.md). Posiciones y diálogos provisionales; servicios pendientes.
