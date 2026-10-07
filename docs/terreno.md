# Propuesta de organización del terreno

**Estado: organización propuesta; cuadrícula de referencia ensayada en una pequeña prueba visual.** El usuario ha confirmado libertad para organizar su granja y ha aceptado usar como referencia de diseño suelo de 64 × 32 y humano de unos 80 píxeles de alto, pidiendo ampliarla a todo el juego. Las dimensiones por familia y detalles de colocación requieren desarrollo y comprobación visual; esto no autoriza programación. [Marco completo de escala y recursos](escala-y-recursos.md).

## Una cuadrícula común

Usar una cuadrícula lógica de casillas, dibujada en perspectiva isométrica como rombos. Sirve para organizar terreno y colocación, y se muestra al cultivar o construir. Personajes y criaturas se mueven de forma continua sobre el terreno; no avanzan por turnos ni saltan entre casillas.

Referencia común para planificar: rombos de **64 × 32 píxeles** al zoom de referencia y humano de unos **80 píxeles de alto**. El resto de proporciones y la presentación final se comprobarán juntas. La altura de personajes, edificios y árboles se define aparte de la superficie que ocupan. Los PNG actuales son originales de gran tamaño: importarlos no los adapta automáticamente a esta escala.

### Escala común recomendada

Suelo y humano son la base aceptada para planificar; los demás tamaños son referencias propuestas y pendientes de comprobación visual. Las medidas son píxeles del recurso antes del zoom, no píxeles físicos fijos de la pantalla.

| Elemento | Referencia propuesta |
|---|---|
| Casilla de suelo | Rombo de **64 × 32 píxeles**. |
| Humano de referencia | **80 píxeles de alto**, unos **40 de ancho** para el cuerpo; tamaño aparente de otras especies según sus proporciones. |
| Fotograma de personaje | Lienzo de **128 × 128 píxeles** como base para reservar margen a herramientas y acciones. Cuerpo de tamaño constante y punto de apoyo estable; acciones que excedan el margen pueden requerir otro lienzo con el mismo anclaje. |
| Botín en el suelo | **Lienzo común de 32 × 32 confirmado**, con silueta orientativa de 16–24 y margen para destellos dentro de ese lienzo. |
| Icono de inventario | **Lienzo de 64 × 64 confirmado**, ajustando el objeto y sus destellos dentro del margen. No implica dibujarlo igual de grande en el mundo. |
| Cultivo tipo tomatera | **32–48 píxeles de alto** sobre una casilla de parcela; proporciones por especie pendientes. |
| Árbol de referencia | **160–224 píxeles de alto**; base pequeña y copa extendida, con variedades de tamaño. |
| Casa inicial de referencia | Superficie de **8 × 6 casillas**, que ocupa un rombo de **448 × 224 píxeles** de suelo. Muros y tejado añaden altura visual; no representa su tamaño de imagen total. |
| Sector de mapa | **32 × 32 casillas** como candidato de carga, sujeto a pruebas de rendimiento; no es el tamaño de una isla. |

Objetivo para la cámara normal: humano aproximadamente **8–12 % de la altura visible** de la escena, ajustado al tamaño de ventana y zoom. Permitir acercarse para apreciar detalles y alejarse para explorar; estudiar pasos de zoom que mantengan legible el pixel art. No se fija todavía una resolución de pantalla ni límites de zoom.

La referencia busca un pixel art con detalle suficiente para especies, animaciones y señales de rareza. La tomatera, el tomate caído y el icono del tomate son representaciones con tamaños diferentes, aunque compartan diseño. Los PNG existentes permanecen intactos: esta propuesta no crea exportaciones de esas dimensiones ni confirma que los originales estén ya adaptados a una cuadrícula de píxeles uniforme.

## Información separada sobre el mismo suelo

| Parte | Contenido | Función |
|---|---|---|
| Terreno base | Tierra, hierba, arena, roca, agua y desniveles. | Definir el soporte y los tipos de terreno. |
| Detalle visual | Hierba pequeña, flores decorativas, huellas, bordes y variaciones. | Dar continuidad y variedad a la superficie. |
| Ocupación fija | Edificios, troncos, rocas grandes, menas, cultivos e instalaciones. | Reservar espacio y definir qué puede colocarse. |
| Movimiento | Zonas transitables, obstáculos, accesos y puentes. | Permitir caminar y buscar rutas coherentes. |
| Elementos móviles | Personajes, mobs, botín, proyectiles y barcos. | Gestionar posición y colisiones sin reservar parcelas permanentes. |
| Zonas de juego | Terreno de la granja, regiones de recursos, encuentros y rutas protegidas. | Aplicar reglas de construcción y aparición. |

La ocupación, la colisión y el dibujo no tienen por qué compartir el mismo contorno. Una flor puede reservar un lugar de aparición sin impedir caminar. La copa de un árbol puede extenderse mucho más que su tronco. Una casa necesita entrada y acceso, además de su superficie de construcción.

## Superficie de cada elemento

Ejemplos para estudiar proporciones, no tamaños confirmados:

- Cultivo individual: **1 × 1 casilla**.
- Mena pequeña: **1 × 1**; una veta grande podría ocupar varias.
- Árbol: **1–2 casillas de base**, con copa dibujada sobre casillas vecinas.
- Casa: por ejemplo **8 × 6**, incluyendo una superficie clara de apoyo y entrada.
- Personaje o mob: posición continua, con colisión ajustada a su tamaño; no una parcela bloqueada permanentemente. La altura visible propuesta para un humano es 80 píxeles, independiente de su superficie de colisión.

Al colocar una instalación, mostrar su superficie prevista y los puntos de acceso. Validar terreno compatible, espacio disponible y accesos. Tamaños, reglas de conexión y si habrá rotación de edificios están pendientes.

## Granja con distribución libre

**Libertad confirmada:** el jugador organiza su granja. La cuadrícula propuesta permite decidir dónde colocar cultivos, caminos e instalaciones dentro de su terreno, alineando sus superficies. Diseñar parcelas, reservar pasos y reorganizar distribución debería ser sencillo.

La libertad de la granja no confirma mover casas de otros habitantes ni modificar todo el archipiélago. Relocalizar la casa del jugador, terraformación, cambios de ríos, ampliación del terreno y costes de recolocación pendientes.

## Vegetación, recursos y enemigos

- Dibujar costas, riberas y vegetación con bordes variados para dar formas naturales sobre la cuadrícula.
- Las zonas de aparición ya acordadas siguen siendo propias de cada recurso. Elegir posiciones dentro de ellas que tengan suelo compatible y espacio disponible.
- Evitar que un recurso reaparezca dentro de edificios, puentes, cultivos del jugador o accesos indispensables.
- Delimitar zonas de encuentro y rutas para criaturas como propuesta de distribución; cantidades, comportamiento y reaparición de enemigos no están decididos.
- El botín es un elemento temporal situado cerca de su origen, independiente de la casilla de aparición del recurso. No debe retrasar su tiempo de reaparición. Agrupación visual de objetos y reglas para evitar colocarlos fuera del alcance pendientes.

## Agua y desniveles

Ríos, lagos, costa y mar comparten la escala y tienen zonas de hábitat y pesca propias. [Reglas para cuerpos de agua, peces y criaturas acuáticas](escala-y-recursos.md). Registrar por separado orillas, profundidad si se elige, acceso de pesca y paso de barcos.

Representar ríos y costas como zonas continuas de terreno con riberas que conectan visualmente. Un puente combina superficie transitable, apoyo y acceso desde ambas orillas. Delimitar por separado dónde puede caminar el personaje y dónde puede navegar el barco; que un río exista no confirma que sea navegable.

Acantilados y pendientes necesitan reglas explícitas de acceso. Natación, vadeo, buceo, saltos y posibilidad de alterar cursos de agua siguen pendientes; no se añaden por elegir la cuadrícula.

## Profundidad visual y regiones

Ordenar personajes y objetos por su punto de apoyo para que se vean delante o detrás de edificios y árboles al moverse. Si una copa o tejado oculta al personaje, estudiar transparencia parcial o una silueta visible. Interiores y comportamiento definitivo de ocultación pendientes.

**Organización visible aceptada el 8 de octubre:** mapas o zonas conectadas, con referencia Stardew Valley. Cada zona puede superar lo que cabe en el monitor. La cámara se desplaza al acercarse al borde visible y se detiene en los límites del mapa; salir por un acceso conduce mediante una transición a otro mapa. Esta es la base deseada para el juego; tamaños, conexiones y tratamiento del mar e interiores pendientes. La prueba actual aún no lo implementa.

La carga técnica en sectores dentro de un mapa sigue como posibilidad independiente. Un sector técnico de 32 × 32 no determina el tamaño de una zona ni obliga a mostrar una transición. El cálculo del tiempo fuera de la zona y la continuidad del estado requieren definición y pruebas posteriores. Las zonas de aparición de recursos siguen siendo subdivisiones con una función distinta.

En Bītu, respetar las casas dispersas, pocas personas y el único recorrido inicial desde las ruinas al astillero. El usuario elige `mapas/isla-bitu-concepto.png` como referencia de estructura: isla amplia, granja junto a la bahía, comercio cercano y caminos hacia todos los maestros. Adaptar esa geografía a mapas conectados; límites de zonas, distancias y distribución detallada siguen pendientes.

## Próximo paso de validación visual

Antes de producir conjuntos de escenarios o animaciones, comprobar la escala de referencia aceptada con un pequeño esquema de personaje, casa, árbol y cultivo. No generar una imagen ni implementar ese esquema sin la petición correspondiente. La prueba visual posterior utiliza referencias temporales del motor; las imágenes artísticas se generan solo cuando el usuario las solicita.

Extender esa futura comprobación a menas/vetas, flores/arbustos, peces, mobs pequeños y grandes, barcos, ríos, lagos, puentes y más de una región. La aceptación de la escala de referencia no valida por sí sola los tamaños finales de todos esos recursos.

Documento principal: [DISENO.md](../DISENO.md). Fecha: **8 de octubre de 2026**.
