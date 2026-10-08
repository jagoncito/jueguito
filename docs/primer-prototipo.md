# Esquema global y primer bloque jugable

**Estado: propuesta global y una primera prueba visual limitada disponible.** El usuario expresa que quiere empezar a programar y posteriormente pide probar cómo se ve. La escena actual implementa un subconjunto provisional; consulta [estado real y ejecución](prueba-visual.md). El resto del alcance sigue siendo propuesta.

Tras su petición de subir lo pendiente y preparar lo siguiente, se desarrolla la recomendación de farmeo en [Siguiente bloque preparado](siguiente-bloque.md). Esa es la dirección de preparación; el contenido gráfico y los parámetros de prueba no quedan confirmados por ello.

## Qué está suficientemente definido

| Área | Base de diseño |
|---|---|
| Motor y plataforma | Godot 4; navegador en ordenador, teclado y ratón; individual. |
| Presentación | Pixel art, vista isométrica elevada, zoom ajustable. |
| Protagonista | Dragón del repositorio, bípedo y con la misma cara original; sustituye al humano anterior. Rig integrado para reposo, caminar con herramientas, minería, tala y palín; nombre, especie concreta y personalización abiertos. |
| Escala | Suelo 64 × 32; humano de referencia de unos 80 px; botín 32 × 32 e iconos de inventario 64 × 64. |
| Mundo | Archipiélago de unas 20 islas, con Bītu como hogar tranquilo y habitantes dispersos. |
| Tiempo al salir | Todo se detiene cuando el jugador deja de jugar; conservar progreso y tiempos restantes para retomar en el mismo momento. Sin avance durante la ausencia ni en pausa. Guardado todavía sin implementar. |
| Zona de comercio y museo | Comparten zona de mapa cerca de la granja; límites, accesos y posiciones concretas pendientes. |
| Accesos de la granja | Dos: camino principal hacia comercio/museo y rutas a los maestros y astillero; sendero costero hacia pesca/cocina. Posiciones y límites pendientes. |
| Inicio | Ruinas, único camino al astillero: Flavia regala la mochila y el maestro minero/herrero el pico–hacha y una regadera sencilla, e invita a visitarlo. Apertura del interior y primer barco. |
| Primer barco | Madera y metal básicos de Bītu, recolectados o comprados al comerciante con ingresos de la actividad preferida. El herrero prepara los herrajes y Flavia lo monta. Materiales concretos, cantidades, precios, duración y diseño pendientes; todavía sin implementar. |
| Evolución del barco | Primer barco pequeño con cubierta transitable; interior accesible mediante una mejora posterior en el astillero de Flavia, decidido por delegación y conforme a la preferencia del usuario. Tipo, dimensiones, coste, funciones y forma de evolución pendientes; velero y número de velas sin confirmar. |
| Conducción y cubierta | Frente al timón, WASD controla el barco. Espacio, elegido por delegación, lo detiene y suelta el timón; WASD vuelve al personaje para caminar y pescar por cubierta. Clic cercano para tomarlo y postura de pie propuestos; detalles de movimiento pendientes, todavía sin implementar. |
| Viaje rápido | Opcional, confirmado: primera llegada navegando; desbloqueo al desembarcar por primera vez y traslado conjunto de personaje y barco entre puntos descubiertos, incluidos desembarcaderos naturales. Activación, condiciones, costes y tiempo abiertos; todavía sin implementar. |
| Mapa marítimo | Bītu visible al comienzo; el resto se revela al navegar y conserva señaladas las islas y puntos de desembarco descubiertos. Extensión inicial, alcance y presentación pendientes; todavía sin implementar. |
| Escala del comienzo | Dirección de ruinas, sendero y astillero en una zona amplia; compartir mapa no reduce las distancias. Dimensiones y conexión al interior pendientes. |
| Presentación del hogar | Flavia y herrero mencionan la casa en el astillero; el comerciante la presenta después de camino y habla de un maestro muy antiguo sin revelar su especialidad. |
| Estado del hogar | Por delegación del usuario: casa abandonada pero habitable desde la llegada, estructura sólida, cama y mesa básicas; reparaciones opcionales y terreno útil despejado. Cofre oculto con semillas y carta del maestro. |
| Actividades | Minería, pesca, cultivo, herboristería, alquimia, herrería y cocina; desarrollo libre. |
| Pesca | Desafío de tensión: mantener clic izquierdo recoge sedal y soltar afloja ante tirones; barra de tensión y comportamiento por pez. Duraciones y curvas pendientes; descartadas las sugerencias posteriores de conservar siempre el avance y de tiempos 3–5/6–10 segundos. |
| Primera caña | Regalo directo del maestro de pesca/cocina al hablar con él por primera vez; hueco propio. Sin materiales, fabricación, encargo ni captura previa; práctica opcional. |
| Recursos | Zonas propias y posiciones variables; menas/flores frecuentes, vetas/arbustos menos frecuentes y mejores recompensas. |
| Herramientas | Huecos propios, selección contextual automática, permanentes y mejorables; recursos con requisitos de herramienta. |
| Botín | Objetos visibles junto a su origen, peces hacia la orilla y recogida por cercanía de lo que cabe. Sobrantes en el suelo, aviso de mochila llena y plazo original sin reiniciar. |
| Inventario | Mochila inicial de 24 huecos, pilas de hasta 1.000 («1k»), regalada por Flavia; ampliaciones compradas al comerciante por monedas, precios y tamaños pendientes. Calidad/variante y propiedades individuales diferentes separadas; herramientas/equipo con huecos propios. Cantidades exactas al vender/dividir; almacenamiento doméstico general pendiente. |
| Granja | Distribución libre, trabajo manual inicial, regadera del herrero y grifo con cisterna de agua dulce junto a la entrada; recarga completa con una interacción. Crecimiento pausado sin riego y futura automatización. |
| Cosechas sucesivas | Aceptado según cultivo: tomatera que permanece y vuelve a producir; patatas que se extraen y requieren replantar. Tomatera con número limitado de cosechas y retirada sencilla al agotarse; esperar no consume cosechas. Cinco solo es ejemplo provisional, cifra final y tiempos pendientes. Todavía sin implementar. |
| Siru en tomates | Mutación rara de la planta durante el crecimiento, ligada a la maestría en tomates; futuras cosechas Siru hasta agotarse, con calidad prístina independiente. Semillas Siru muy escasas en exploración, cofres y lugares perdidos como otra vía. Pequeña posibilidad aceptada de dejar una semilla Siru al agotarse. Probabilidades y entrega pendientes; todavía sin implementar. |
| Cocina y cosechas excepcionales | Ingredientes prístinos mejoran recetas; Siru permite preparaciones especiales. Beneficios temporales duraderos según plato/actividad, confirmados; comida opcional. Recetas, efectos específicos, duración y acumulación pendientes; no confirma Siru para nuevas familias. Cocina todavía sin implementar. |
| Aprender recetas | Maestro de pesca/cocina y exploración como vías compatibles; primeras enseñanzas gratis y otras en distintos momentos. Recetas encontradas en cofres, ruinas o lugares perdidos, incluidas raras. Recetario permanente; catálogo, condiciones, distribución y duplicados pendientes. Todavía sin implementar. |
| Recetario y elaboración | Confirmados libro con filtros y kit portátil reutilizable con hueco propio: montaje en terreno despejado, combustible al encender, preparación por lotes seleccionando ingredientes y recogida al terminar. Madera o carbón por decidir; cantidades, controles y obtención pendientes. Otras estaciones abiertas; todavía sin implementar. |
| Primeras semillas | Escondidas en un cofre de la casa con una carta del antiguo maestro que insinúa que esperaba tu llegada. Motivo y forma de saberlo abiertos; especie, cantidad, ubicación y texto exacto pendientes. Profesión del maestro oculta al jugador. |
| Colección | Calidad prístina y variante Siru diferenciadas en tomates; museo con donación definitiva y recompensa. |

Las reglas comunes permiten crear el soporte de varias familias sin inventar ahora todas las especies. Nombres, probabilidades y precios pueden incorporarse conforme se desarrollan las actividades.

## Primera entrega recomendada: base de juego y farmeo

Una pequeña zona provisional de Bītu, en la escala acordada, que permita comprobar el movimiento, la colocación y la recogida. Su distribución no convierte uno de los mapas conceptuales en definitivo.

1. Suelo isométrico con tierra, vegetación, agua, obstáculos y un espacio de granja.
2. Personaje de prueba que se mueve con WASD y cámara con zoom; gráficos temporales claramente identificados mientras faltan animaciones.
3. Interacción con una mena y una flor: acción, desaparición del recurso, botín y comienzo de reaparición dentro de su zona.
4. Botín con lienzos de 32 × 32 y mochila visible con iconos de 64 × 64. Recogida parcial aceptada: tomar lo que cabe y dejar el resto visible en el suelo con su plazo original y aviso de mochila llena.
5. Plantar, regar y cosechar tomates; experiencia específica del tomate y demostración de calidad/variante con parámetros de prueba, sin fijar rarezas definitivas.
6. Preparar un acceso de pesca para desarrollar el desafío activo en el siguiente tramo, o incluirlo si se prioriza pesca frente a agricultura.

Los cuatro PNG de tomates existentes se pueden importar ajustando su presentación; no crear imágenes nuevas por iniciativa propia. El 9 de octubre el usuario pide explícitamente adaptar el dragón existente e integrarlo como protagonista bípedo con su cara intacta. Esta excepción autoriza sus piezas y animaciones, sin reabrir la generación general. No usar a Unamahloni como protagonista.

## Primer capítulo, después de validar la base

Recuperar la orientación original con el nuevo acuerdo: ruinas → Flavia y maestro minero/herrero en el astillero, con mochila de bienvenida de Flavia, herramientas propias del herrero y menciones de ambos a la casa → comerciante de camino, que presenta la casa y habla del antiguo maestro sin revelar su especialidad → hogar y habitantes → recursos, venta y primera mejora → construcción del barco. Desde el regalo se puede picar lo básico por los caminos y en la granja; algunas primeras plantas se podrán recoger a mano antes de obtener el palín de Unamahloni. El cierre en el primer barco sigue siendo el hito recomendado. La primera navegación o una segunda isla se incorporan después según el alcance que el usuario elija. Este recorrido y la recolección manual aún no están implementados.

Combate, alquimia, cocina, museo y presentación de los maestros entrarán por tramos coherentes. No añadir una amenaza dentro del Bītu tranquilo solo para disponer de un enemigo de prueba; cualquier espacio de prueba de combate debe identificarse como provisional o situarse en una zona de peligro acordada.

## Pendientes que afectan a la primera entrega

- Confirmar prioridad de la primera entrega: base de farmeo recomendada o primer recorrido narrativo ruinas–Flavia.
- Equilibrar precios y tamaños de ampliaciones de mochila, compradas al comerciante por monedas; 24 huecos, pilas de 1.000 y separación de propiedades individuales diferentes acordados, todavía sin implementar en la prueba. Mochila llena y recogida parcial ya acordadas.
- Detalles de lanzamiento/picada y balance del desafío de tensión aceptado, si se incluye pesca en el primer bloque.
- Implementar guardado y concretar activación de pausa antes de introducir progreso destinado a conservarse. Regla acordada: todo se detiene al salir o pausar, conservando progreso y tiempos restantes.
- Tratamiento gráfico provisional y posterior producción de sprites/animaciones.

No hace falta cerrar el catálogo de las 20 islas, la historia de cada mob, todos los ingredientes, el nombre de cada pez ni las probabilidades ultraexclusivas para iniciar esta base.

## Qué debe demostrar la base

El personaje se mueve y choca donde corresponde; el zoom conserva legibilidad; las parcelas encajan; botín común y prístino se distingue; los huecos se respetan; recoger o abandonar botín no cambia el tiempo de reaparición; las apariciones mantienen su zona; los tomates conservan progreso al faltar riego. Validar el proyecto en Godot y una exportación de navegador cuando exista implementación.

Guardado local de esta propuesta. Subir a GitHub solo cuando el usuario lo pida. Referencias: [bloc principal](../DISENO.md), [terreno](terreno.md), [escala y recursos](escala-y-recursos.md).
