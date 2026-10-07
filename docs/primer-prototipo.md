# Esquema global y primer bloque jugable

**Estado: propuesta concreta de alcance.** El usuario expresa que quiere empezar a programar y pregunta por el estado del esquema global. Este documento resume la preparación y plantea la primera entrega para cerrar su alcance; no describe una implementación existente.

Tras su petición de subir lo pendiente y preparar lo siguiente, se desarrolla la recomendación de farmeo en [Siguiente bloque preparado](siguiente-bloque.md). Esa es la dirección de preparación; el contenido gráfico y los parámetros de prueba no quedan confirmados por ello.

## Qué está suficientemente definido

| Área | Base de diseño |
|---|---|
| Motor y plataforma | Godot 4; navegador en ordenador, teclado y ratón; individual. |
| Presentación | Pixel art, vista isométrica elevada, zoom ajustable. |
| Escala | Suelo 64 × 32; humano de referencia de unos 80 px; botín 32 × 32 e iconos de inventario 64 × 64. |
| Mundo | Archipiélago de unas 20 islas, con Bītu como hogar tranquilo y habitantes dispersos. |
| Inicio | Ruinas, único camino al astillero de Flavia, apertura del interior y primer barco. |
| Actividades | Minería, pesca, cultivo, herboristería, alquimia, herrería y cocina; desarrollo libre. |
| Recursos | Zonas propias y posiciones variables; menas/flores frecuentes, vetas/arbustos menos frecuentes y mejores recompensas. |
| Herramientas | Huecos propios, selección contextual automática, permanentes y mejorables; recursos con requisitos de herramienta. |
| Botín | Objetos visibles junto a su origen, peces hacia la orilla y recogida por cercanía si cabe. |
| Inventario | Mochila por espacios para recolectables; herramientas, equipo y otros objetos con huecos propios. |
| Granja | Distribución libre, trabajo manual inicial, crecimiento pausado sin riego y futura automatización. |
| Colección | Calidad prístina y variante Siru diferenciadas en tomates; museo con donación definitiva y recompensa. |

Las reglas comunes permiten crear el soporte de varias familias sin inventar ahora todas las especies. Nombres, probabilidades y precios pueden incorporarse conforme se desarrollan las actividades.

## Primera entrega recomendada: base de juego y farmeo

Una pequeña zona provisional de Bītu, en la escala acordada, que permita comprobar el movimiento, la colocación y la recogida. Su distribución no convierte uno de los mapas conceptuales en definitivo.

1. Suelo isométrico con tierra, vegetación, agua, obstáculos y un espacio de granja.
2. Personaje de prueba que se mueve con WASD y cámara con zoom; gráficos temporales claramente identificados mientras faltan animaciones.
3. Interacción con una mena y una flor: acción, desaparición del recurso, botín y comienzo de reaparición dentro de su zona.
4. Botín con lienzos de 32 × 32 y mochila visible con iconos de 64 × 64. Recoger únicamente lo que cabe y dejar el resto es la solución propuesta, pendiente de cerrar.
5. Plantar, regar y cosechar tomates; experiencia específica del tomate y demostración de calidad/variante con parámetros de prueba, sin fijar rarezas definitivas.
6. Preparar un acceso de pesca para desarrollar el desafío activo en el siguiente tramo, o incluirlo si se prioriza pesca frente a agricultura.

Los cuatro PNG de tomates existentes se pueden importar ajustando su presentación; no crear imágenes nuevas por iniciativa propia. El aspecto del protagonista y otros recursos pendientes necesita una decisión posterior de producción gráfica. No usar a Unamahloni como protagonista por ser el único personaje ilustrado.

## Primer capítulo, después de validar la base

Recuperar la orientación original: ruinas → Flavia → hogar y habitantes → recursos, venta y primera mejora → construcción del barco. El cierre en el primer barco sigue siendo el hito recomendado. La primera navegación o una segunda isla se incorporan después según el alcance que el usuario elija.

Combate, alquimia, cocina, museo y presentación de los maestros entrarán por tramos coherentes. No añadir una amenaza dentro del Bītu tranquilo solo para disponer de un enemigo de prueba; cualquier espacio de prueba de combate debe identificarse como provisional o situarse en una zona de peligro acordada.

## Pendientes que afectan a la primera entrega

- Confirmar prioridad de la primera entrega: base de farmeo recomendada o primer recorrido narrativo ruinas–Flavia.
- Elegir comportamiento de mochila llena y número inicial de huecos; las cifras de prueba no son equilibrio definitivo.
- Interacciones y minijuego de pesca, si se incluye esa actividad en el primer bloque.
- Guardado y comportamiento al pausar/cerrar antes de introducir progreso destinado a conservarse.
- Tratamiento gráfico provisional y posterior producción de sprites/animaciones.

No hace falta cerrar el catálogo de las 20 islas, la historia de cada mob, todos los ingredientes, el nombre de cada pez ni las probabilidades ultraexclusivas para iniciar esta base.

## Qué debe demostrar la base

El personaje se mueve y choca donde corresponde; el zoom conserva legibilidad; las parcelas encajan; botín común y prístino se distingue; los huecos se respetan; recoger o abandonar botín no cambia el tiempo de reaparición; las apariciones mantienen su zona; los tomates conservan progreso al faltar riego. Validar el proyecto en Godot y una exportación de navegador cuando exista implementación.

Guardado local de esta propuesta. Subir a GitHub solo cuando el usuario lo pida. Referencias: [bloc principal](../DISENO.md), [terreno](terreno.md), [escala y recursos](escala-y-recursos.md).
