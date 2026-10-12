# Tirones de la isla — revisión del 12 de octubre de 2026

El usuario rechaza el aspecto general de la entrega y comunica tirones constantes. Esta revisión corrige primero la preparación del terreno y las interrupciones del movimiento. No presenta el paisaje ni los interiores como terminados.

## Causas y cambios

El terreno anterior reconstruía de golpe toda la ventana de casillas al avanzar la cámara. Cada casilla nueva comprobaba caminos, costa y río; además se recalculaban polígonos y UV para dibujarla. La zona visible reunía cientos o miles de casillas, especialmente con zoom alejado. Las pruebas de funciones anteriores no midieron suficientemente estos picos.

Ahora se divide el terreno en bloques de 256×256 unidades. Cada bloque conserva su geometría, agrupada por textura mediante ArrayMesh; desplazarse o volver a un bloque cargado no reconstruye sus casillas. La preparación de bloques próximos se reparte entre fotogramas con objetivo de 1,5 ms y un máximo de dos bloques completados por fotograma. Una casilla o el cierre de una malla pueden exceder ligeramente ese objetivo; no es un límite garantizado de todo el fotograma.

Al arrancar, la vista inmediata se completa antes de mostrar la partida; el margen de 384 unidades se prepara por adelantado. El zoom exterior se aplica cuando su próxima vista está lista, mientras el personaje puede seguir moviéndose. Esto evita mostrar huecos durante una expansión brusca de cámara. Se conservan hasta 128 bloques, descartando primero los lejanos; los necesarios para cubrir una ventana excepcionalmente grande tienen prioridad sobre ese límite. Las cachés pequeñas de material/costa siguen creciendo con las casillas visitadas; no se afirma memoria totalmente constante.

El exterior conserva coordenadas y cámara continuas. Cambiar de región modifica su nombre, sin fundido ni detener al personaje. El fundido sigue en las puertas. Edificios, recursos y personajes se activan por proximidad a la cámara, con margen suficiente para sus fachadas y colisiones; no desaparecen por estar al otro lado de una frontera de región. La búsqueda de interacción utiliza esa lista cercana. Los límites del exterior son los del mundo, en vez de sujetar la cámara al rectángulo de cada región.

Fuentes, PNG del dragón y NPC, distribución, capacidades de mochila, tiempos de acciones y contenido del juego se conservan. Cambios en `island_terrain.gd`, nuevo `island_terrain_chunk.gd`, `island_game.gd`, selección de candidatos en `main.gd` y telemetría opcional de revisión en `menus.gd`.

## Comprobación

- `tests/terrain-streaming-smoke.gd`: recorrer terreno con dos niveles de zoom, comprobar bloques listos antes de alcanzar la vista, reutilización sin reconstrucción, precarga y tamaño de caché.
- `tests/island-smoke.gd`: cruzar una frontera con movimiento real y verificar que ningún fotograma activa una transición o deshabilita al jugador; conservar inventario, puertas, colisiones, mina, pesca y botín.
- Regresiones de la granja anterior, acciones y mochila tras cambiar la búsqueda de candidatos.
- `tools/island_browser_smoke.py`: arranque, indicador del mapa, pausa, mover/dividir pilas, ventana pequeña, zoom preparado y diez entradas/salidas con teclado y ratón en Chromium/WebGL.
- `tools/measure_island_browser.py`: mismo recorrido desde BITU24H, seis segundos corriendo a derecha y seis al norte después de alejar el zoom; intervalos de requestAnimationFrame. Se sirve la exportación antes de ejecutarlo. Admite archivo JSON de salida y URL como segundo argumento.

Las mediciones de navegador se ejecutan secuencialmente, sin otras pruebas gráficas simultáneas. El entorno usa Chromium con SwiftShader, gráficos por software: sirve para comparar ambas versiones, pero no reproduce la GPU del usuario ni certifica 60 FPS. Los intervalos de presentación del navegador tampoco son un perfil completo de cada subsistema de Godot.

## Resultados medidos

Prueba nativa aislada: las ventanas nuevas del terreno anterior consumieron38,0–43,6 ms en preparar/dibujar sus comandos; la preparación incremental nueva tuvo un pico de 2,399 ms durante el recorrido y conservó 114 bloques/7.296 casillas. La vista inicial se prepara al arrancar y está excluida de ese pico incremental. Son costes de estas tareas, no tiempos de fotograma completos ni FPS garantizados.

Chromium 1280×720, SwiftShader, mismo teclado/zoom y versiones servidas por separado:

| Intervalo de presentación | Antes | Después |
|---|---:|---:|
| Mediana | 200,0ms | 116,6ms |
| Percentil 95 | 333,4ms | 166,8ms |
| Máximo de la muestra | 400,0ms | 250,0ms |
| Fotogramas registrados | 66 | 114 |

La comparación mejora, pero los intervalos del entorno por software siguen siendo altos. No equivale a certificar fluidez en el equipo del usuario. Las dos ejecuciones terminaron sin errores de JavaScript. También pasó la revisión Chromium/WebGL de mapa, mochila, zoom y diez puertas, además de las cinco pruebas nativas de esta revisión: terreno, isla, escena anterior, acciones y mochila.

## Pendiente

Confirmar la fluidez en el navegador del usuario después de publicar la prueba; no dar todos los tirones por resueltos solo por estas mediciones. El trabajo visual de ruinas–astillero, paisaje e interiores sigue pendiente. La revisión actual no añade contenido ni sistemas de progresión.
