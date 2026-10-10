# Primera prueba visual de Bītu

**Revisión integral del10 de octubre:** dragón de216 registros en ocho direcciones:
reposo, marcha, sprint, minería, tala, recolección, pesca y zarpazo. Diez fuentes
PNG y copias idénticas en ejecución. Dos PNG y16 registros aprobados de la
recolección conservados exactamente, junto al palín y sus tiempos.

Manos libres al desplazarse. Pico–hacha dibujado con manos/cuerpo en las poses
de trabajo, punta contra mena y filo contra tronco. Cinco golpes. Un paso físico
ajusta el apoyo antes del golpe, respetando colisiones; si queda bloqueado se
cancela sin consumir el recurso. Reposo/marcha/sprint mantienen la cresta80px;
cuatro dibujos por ciclo y una escala uniforme, sin crecer al cambiar de paso.

**Clic contextual:** recurso activo tiene prioridad; enemigo/suelo libre da un
zarpazo hacia el cursor; agua cercana desde costa lanza caña. Garras con un único
impacto frontal y alcance limitado. Maniquí al suroeste, bajo los habitantes,
para comprobar contacto/daño. Sin criaturas o IA nuevas. Los NPC no reciben daño.

Pesca: lanzamiento, picada, recoger manteniendo clic y aflojar soltándolo.
Barra superior de acercamiento y naranja de tensión. El sedal sale del extremo
registrado de la caña, también en las vistas reflejadas. Captura junto a los pies,
botín/mochila, fallo por tensión o abandono y cancelación con Esc. Caña disponible
en esta prueba; regalo narrativo, especies, mejoras y balance definitivo pendientes.

**Verificación:** ocho pruebas Godot superadas: inventario, herramienta, recursos,
entorno, dragón, acciones, extracción real y escala. Siete suites Chromium/WebGL:
ocho direcciones × ocho modos, altura reposo/arranque e impactos reales, extracción
de cobre/madera/Yde, zarpazo y pesca por clic con captura/botín/cancelación,
comparativas80/72, giros/pausa de NPC y recursos. Capturas y vídeos del canvas
renovados. El acabado artístico se revisa en juego; los tests comprueban registro,
contactos, transiciones y comportamiento, sin otorgar aprobación visual.

Descarga actual: **30.875.732 bytes**, CRC correcto y PCK idéntico al exportado.
SHA-256: `533d9e2b1c28db94be825c73f04729f450c6b82036864ec8028f19eda971a7da`. Límite GitHub por archivo:104.857.600bytes; no hace falta
dividir la entrega. Suelos de césped/tierra/arena, NPC, agua/casa e historial remoto
conservados. El ZIP contiene la partida y las revisiones ampliadas.

Revisión: `?vista=dragon`: **1 reposo,2 marcha,3 minar,4 talar,5 palín,6 parar/andar,
7 sprint,8 pesca,9 zarpazo**. Espacio: cámara lenta. `?vista=personajes` compara con
habitantes. Impactos reales: `?captura=impacto-minar&captura-impacto=1` o tala.
Pesca/zarpazo en partida: `?captura=pesca` y `?captura=zarpazo` sitúan al jugador
para la revisión, sin alterar el comportamiento de las acciones. `verificar=1`
solo emite estado de pesca en consola para que el test responda a la tensión real.

[Pesca en juego](../prueba/capturas/pesca-en-juego.png) ·
[Botín de pesca](../prueba/capturas/pesca-botin-en-juego.png) ·
[Zarpazo](../prueba/capturas/zarpazo-en-juego.png) ·
[Todas las orientaciones](../assets/personajes/dragon/README.md).

## Recursos de terreno y botín

Se integran tres variantes de árbol de 192–208 px con sus tocones; cobre entero/picado de unos 56×52 px y Yde violeta plantada de 36 px. Madera cortada, fragmento de cobre y una flor recogida tienen imágenes de botín distintas del recurso en el terreno. El botín mantiene su marco 32×32, la mochila 64×64 y el dragón de 80 px. Los PNG fuente se conservan íntegros: son atlas generados de 1536×1024, recortados mediante AtlasTexture y representados con filtro nearest, no hojas nativas de 32 px.

La selección por clic respeta el alfa del dibujo. Las tres siluetas no cambian la cámara ni la colisión de la base. El cobre cambia de aspecto al primer golpe y restaura su estado al reaparecer; talar deja un tocón transitable. Los tiempos y cantidades del prototipo no cambian. Tampoco se asignan efectos alquímicos ni rarezas a Yde.

Revisión: `prueba/scenes/recursos.tscn` con F6, o `?vista=recursos` en navegador. Compara escala con el dragón, variantes, estados, botín y mochila. [Atlas y medidas](../assets/entorno/recursos/README.md) · [Captura comparativa](../prueba/capturas/recursos-y-botin.png) · [Granja](../prueba/capturas/recursos-en-juego.png).

## Qué se puede probar

**Movimiento y agarre revisados:** cuatro dibujos de marcha por dirección, incluidos perfiles y diagonales; vistas traseras que avanzan alejándose de la cámara. La marcha sigue la distancia recorrida y se detiene al quedar bloqueado. Manos libres al caminar; pico–hacha y dedos dibujados junto al cuerpo en las poses de trabajo. El palín conserva sus proyecciones y registro por separado. Las ruinas se definen en el bloc como refugio costero con patio de llegada; ese nivel todavía no está incluido.

- Caminar con **WASD** y mantener **Shift** para el sprint provisional, con colisiones en agua, casa, bases de árboles y límites. La marcha sigue el desplazamiento real y las diagonales mantienen la velocidad normalizada.
- Ajustar el zoom con la **rueda**.
- Acercarse a las parcelas y pulsar **E** para plantar, regar o cosechar según su estado.
- Acercarse a una mena, árbol o flor y hacer **un clic izquierdo sobre ese recurso** para completar toda la extracción, sin mantener pulsado ni repetir clics. Clic en suelo no usa el recurso más cercano; clic desde lejos pide acercarte. E se conserva para las parcelas.
- Ver el pico–hacha equipado: golpear la mena con la punta y talar un árbol con el filo, con ambas manos sobre el mango y efectos de impacto. El último golpe suelta el botín; el árbol deja un tocón transitable y madera.
- Recoger objetos al pasar cerca. Los tipos de tomate se mantienen separados en la mochila.
- Mostrar u ocultar la mochila con **Tab**.
- Comparar los seis personajes con el protagonista y detener/reanudar sus movimientos con **F6**. Su colocación es temporal para esta revisión.

Los cuatro tomates junto a la orilla son **muestras de comparación**, no un ejemplo de rareza normal. Las cosechas de esta prueba dan tomate común y aumentan el contador de experiencia del tomate. Todavía no hay probabilidades de calidad ni variantes en la cosecha.

Las herramientas se indican aparte de la mochila. Huecos interactivos, requisitos y mejoras pendientes. El [palín de herborista](../assets/herramientas/palin-herborista/README.md) se equipa para la flor: pose arrodillada en cada dirección, paladas breves, extracción y recuperación. El mango se registra en la palma y el cambio de apoyo limita su escala; no desplaza al jugador ni cambia el alcance. La elevación E utiliza su nuevo dibujo de perfil, sin reutilizar la pose arrodillada. El acabado sigue siendo de prototipo.

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

**No guarda progreso**: recargar o cerrar reinicia la escena. No incluye pesca activa, navegación, servicios de habitantes, relato inicial, enemigos, combate, museo, construcción libre de parcelas ni producción gráfica definitiva. La granja usa parcelas precolocadas para esta revisión de escala; la libertad de distribución sigue siendo el diseño previsto.

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

### Comprobación de agua y casa

Integración revisada en Godot 4.6.3 y Chromium/WebGL: arranque, movimiento, límite del agua, minería, tala, Yde, botín y mochila. `tests/environment-smoke.gd` comprueba la fachada física y el paso libre por el patio; también pasan smoke, scene-smoke, resources-smoke y tool-smoke. La prueba de navegador completó el recorrido tras repetir el primer intento de Yde. PNG originales idénticos a las copias de ejecución; ZIP actualizado con CRC y paquete comprobados.
Ajuste de cinco golpes: la prueba de escena confirma que cuatro impactos conservan mena y árbol sin botín, y que el quinto completa la extracción. Descarga de navegador regenerada con este ajuste y ZIP comprobado. Las mejoras hasta un golpe quedan como dirección de diseño, todavía sin implementar.

## NPC en partida y revisión de tamaños

Seis NPC con ocho vistas cada uno, colisión en pies, giro al aproximarse e interacciónE de prueba. Protagonista nuevo216 poses. F7/F8 comparan su tamaño80/72px sin cambiar el zoom o los NPC. [Auditoría completa, funcionamiento y capturas del motor](revision-personajes-en-juego.md). Posiciones y diálogos provisionales; servicios pendientes.
