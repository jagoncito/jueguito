# Escala y recursos para todo el archipiélago

**Estado: marco de diseño, sin implementación.** Referencia de trabajo aceptada tras la recomendación: suelo isométrico de **64 × 32 píxeles** y humano de unos **80 píxeles de alto**. El usuario pide que sirva para todo el juego. Los rangos por familia, formas de organización y soluciones que se describen aquí son propuestas para desarrollar; no fijan el catálogo de especies, mapas, probabilidades ni todas las mecánicas.

## 1. Una escala, tamaños diferentes

Compartir tamaño de píxel, perspectiva y proporciones. Cada recurso tiene cinco medidas distintas:

| Medida | Qué representa |
|---|---|
| Tamaño visible | Silueta del objeto, planta, personaje o criatura. |
| Lienzo o fotograma | Imagen con espacio para movimiento, extremidades y efectos. |
| Superficie de apoyo | Casillas necesarias para colocar un objeto fijo o edificio. |
| Colisión | Parte que afecta al movimiento, ataques o navegación. |
| Alcance de interacción | Distancia para cosechar, extraer, pescar, hablar o recoger botín. |

No hacer que la colisión ocupe toda la imagen: una copa, cuernos, alas o destellos pueden sobresalir de la base. Las distancias de interacción y combate se definirán al diseñar esas acciones, no a partir del borde transparente del PNG.

En cada animación conservar el tamaño del cuerpo y un punto de apoyo estable. Los 128 × 128 píxeles son una referencia de fotograma para humanoides, no una obligación para peces, árboles, edificios o criaturas gigantes. El icono de inventario es otra representación: **lienzo confirmado de 64 × 64**, con tamaño del objeto adecuado para reconocerlo.

**Botín uniforme, decisión posterior del usuario:** todos los objetos que aparecen para recoger utilizan el mismo tamaño de sprite, con **lienzo común confirmado de 32 × 32**, siluetas ajustadas de forma proporcional y destellos dentro del margen. Esto incluye las capturas de peces: su tamaño como botín no fija su tamaño real ni el de una posible representación nadando. No estirar una silueta para llenar el cuadrado. La aceptación de las medidas no adapta automáticamente los PNG originales existentes.

Para nuevos elementos, aplicar la referencia de su familia y discutir excepciones o familias nuevas; no hace falta pedir una medida desde cero por cada nombre. El usuario puede revisar cualquier referencia al desarrollar un recurso concreto.

**Protagonista elegido después:** dragón bípedo, reajustado por petición del usuario para mejorar proporciones y cola. Altura erguida aproximada de **90 px** antes del zoom, próxima a la referencia humana de 80 px; menor al arrodillarse. Ocho vistas y poses completas, con escala uniforme por atlas y anclas de suelo registradas. La identidad de la cara se conserva al redibujar las perspectivas; original intacto como referencia. Colisión circular de radio 7 en (0,-3). PNG fuente grandes con AtlasTexture y vecino más cercano: no son sprites nativos de 128 × 128. Herramienta equipada a 0,72 de su escala de revisión (unos 35 × 44 px). [Ficha y revisión jugable](../assets/personajes/dragon-avatar/README.md).

## 2. Familias y proporciones

**Registro direccional del protagonista:** cuatro fases distintas de marcha por vista, todas escaladas uniformemente y apoyadas en un ancla de suelo. La palma y el recorte de dedos se registran en cada fotograma; las ocho perspectivas del equipo conservan su propio agarre y contactos. No igualar la caja de una herramienta de perfil con su vista frontal ni estirar brazos para alcanzar un mango. La marcha se sincroniza con la distancia recorrida, también en diagonales y al deslizarse contra obstáculos.

Rangos orientativos, en píxeles del recurso antes del zoom. Los cultivos citados además de patata y tomate son ejemplos de formas posibles, no nuevas especies confirmadas.

| Familia | Tamaño visible orientativo | Apoyo y reglas espaciales |
|---|---|---|
| Cultivo bajo, tipo patata | 16–32 de alto. | Parcela habitual de 1 × 1; fruto cosechado separado de la planta. |
| Cultivo medio, tipo tomatera | 32–48 de alto. | 1 × 1 como referencia; mantener legible el estado de crecimiento. |
| Cultivo alto o trepador | 48–96 de alto. | Soporte y accesos propios si se elige esa familia. |
| Cultivo extendido o fruto grande | Silueta según especie. | Admitir parcelas de varias casillas; 2 × 2 es un ejemplo. |
| Flor silvestre | 16–40 de alto. | Pequeña superficie dentro de su zona de aparición. |
| Arbusto recolectable | 48–96 de alto. | 1 × 1 o 2 × 2 según planta; dibujo y colisión independientes. |
| Roca básica o mena | 24–64 de alto. | Habitualmente 1 × 1; rocas grandes admiten varias casillas. |
| Veta grande | 48–128 de alto, anchura variable. | Superficie de varias casillas o adherida a pared; acceso para extraer. |
| Todo el botín | Lienzo común confirmado de 32 × 32. | Silueta proporcionada, destellos contenidos y posición accesible cerca de su origen. |
| Pez capturado como botín | Mismo tamaño de sprite que los demás objetos recogibles. | Tamaño biológico por especie separado; natación y presentación de museo pueden usar otras proporciones. |
| Criatura pequeña | Cuerpo de 24–48 de alto. | Colisión y movimiento adecuados a su tamaño y hábitat. |
| Humanoide habitual | Cuerpo de 64–96 de alto. | Humano de referencia 80; especies conservan proporciones propias. |
| Criatura grande | Cuerpo de 128–192 de alto. | Espacio de maniobra y fotogramas mayores cuando hagan falta. |
| Criatura colosal | Cuerpo de 192–384 o más. | Sin límite arbitrario de lienzo; prever rutas, arena y visibilidad. |
| Árbol | 160–224 de alto como referencia. | Tronco de base pequeña, copa extendida; otras especies pueden variar. |
| Casa de referencia | Suelo de 8 × 6 casillas. | 448 × 224 de proyección de suelo; paredes y tejado añaden altura. |
| Taller, museo o astillero | Según instalaciones y accesos. | Combinar superficies; un astillero debe relacionar tierra y agua. |
| Barco | Según clase y tamaño del casco. | Colisión de casco, giro, pasos navegables y atraque; no copiar la colisión del personaje. |

Una rareza no obliga a aumentar el tamaño. Un pez diminuto, una flor o un mob pequeño pueden ser extraordinariamente raros. También puede haber criaturas grandes comunes. Los tamaños de jefes y sus arenas son posibilidades, no enemigos confirmados.

## 3. Cultivos y plantas silvestres

Preparar una ficha por cultivo con su nombre, superficie de parcela, imágenes de crecimiento, estado cosechable, cosecha obtenida y reglas pendientes de definir. Secuencia gráfica propuesta: siembra, brote, crecimiento y listo para cosechar; el número de etapas depende de la especie. Recolección única o repetida se decide por cultivo.

La falta de riego pausa el crecimiento y conserva el progreso; no añadir un estado de muerte por falta de agua. La experiencia por cultivo, por ejemplo tomates, aumenta las probabilidades de máxima calidad. Cantidades de experiencia, niveles y probabilidades siguen pendientes. La automatización futura actúa sobre las tareas acordadas sin exigir otra escala del mapa.

Herboristería tiene otra ficha: flor o arbusto silvestre, zona de aparición propia, ingrediente obtenido y usos alquímicos por decidir. Flores mucho más frecuentes que arbustos, con mejores recompensas en estos últimos. No usar la habilidad de cultivar tomates como requisito automático de recoger hierbas.

Reservar superficies ampliables para soportes o instalaciones si se eligen más adelante. Animales de granja pueden usar las familias de criatura y fichas de producción, pero el alcance de la ganadería y sus acciones de experiencia sigue abierto.

## 4. Minería

Separar roca básica, mena y veta como formas de recurso. Cada tipo mantiene su zona de aparición; menas mucho más frecuentes que vetas y vetas con mejores recompensas. Contemplar ubicaciones exteriores y subterráneas, incluidas vetas valiosas en superficies peligrosas.

Cada ficha de recurso especificará superficie, posición de apoyo, lugares compatibles, herramienta requerida y botín posible. Rareza, dureza, valor y tamaño son características distintas: un mineral valioso puede estar en un depósito pequeño. Requisitos, minerales concretos y cifras pendientes.

Estado espacial: disponible, interacción de extracción y recurso desaparecido. En las menas, iniciar el tiempo de reaparición al terminar de extraer aunque no se recoja el botín. Las siguientes apariciones cambian de posición dentro de su zona, respetando la ocupación y los accesos. El botín temporal es independiente del recurso y no bloquea ese tiempo.

## 5. Ríos, lagos, costa y mar

Usar la misma escala de terreno para las cuatro familias de agua. Proponer estas zonas de hábitat:

| Zona | Información que conviene poder distinguir |
|---|---|
| Río | Orillas, ancho del cauce, tramos, entradas a otros cuerpos de agua y cruces. |
| Lago | Orilla, interior, accesos de pesca y posibles subzonas. |
| Costa | Tierra firme, orilla, muelles, bahías y salida al mar. |
| Mar entre islas | Rutas navegables, aguas abiertas, lugares especiales y acceso a costas o cuevas. |

Registrar profundidad y agua dulce/salada como datos de hábitat propuestos si ayudan a diferenciar peces. Corrientes, mareas, clima, vadeo, natación y efectos de profundidad no se convierten en mecánicas confirmadas por registrar zonas.

El aspecto del agua, sus posibilidades de pesca y la navegación son reglas separadas. Un lago puede permitir pescar sin admitir el barco; un río estrecho puede necesitar puente. La decisión concreta corresponde a cada zona. El barco necesita paso para todo el casco, maniobra y acceso al muelle.

Un puente requiere suelo transitable por encima, riberas conectadas y representación de lo que pasa por debajo. Usar información de altura y conexiones cuando haya puentes o desniveles; una simple marca de casilla ocupada no basta para dos superficies superpuestas.

## 6. Peces y criaturas acuáticas

Ficha propuesta por especie de pez: apariencia, tamaño biológico, representación nadando si se utiliza, icono de inventario, hábitats, momentos del día, comportamiento del desafío, botín y condición de colección. La captura recogible utiliza el tamaño de sprite uniforme acordado. Cebo, clima, temporadas y probabilidades solo se añaden si se acuerdan. La referencia hipotética de un pez anual no fija un calendario.

La pesca conserva lanzamiento, espera de picada y desafío activo. No hace falta poblar el agua con un sprite por cada pez potencial: se puede representar el lugar de pesca y crear la captura al lograrla. Sombras, bancos o peces nadando pueden añadir ambientación si se decide.

La captura desde tierra llega a una posición de orilla cerca del personaje. Evitar colocarla en agua inaccesible, debajo de un puente o al otro lado de una pared. Desde barco, la cubierta cercana sigue siendo la propuesta pendiente de concretar. La recogida por cercanía es automática si hay espacio.

Una criatura marina enemiga necesita movimiento acuático, colisión y ataques propios. Ser acuática no la convierte automáticamente en pez capturable. Tamaño máximo de capturas, destinos de ejemplares enormes y enemigos marinos concretos pendientes.

## 7. Habitantes, animales y mobs raros

Compartir perspectiva, luz de referencia y escala, pero permitir proporciones y anatomías diferentes. Separar humanoides, cuadrúpedos, criaturas voladoras y acuáticas para definir apoyo, sombras y animaciones. La representación de altura para seres voladores no decide por sí sola qué obstáculos o ataques atraviesan.

Ocho direcciones son la recomendación para protagonista y enemigos móviles; cuatro o menos pueden bastar para personajes con funciones limitadas. Cada ficha indica acciones necesarias: reposo, movimiento, ataque, daño, derrota, esquive o trabajo según su papel. No producir todas esas acciones para cada especie indiscriminadamente. Animaciones asimétricas requieren comprobar si se pueden reflejar.

Para encuentros raros, guardar identidad, zona elegible, condiciones de aparición, comportamiento y recompensas como campos a decidir. No fijar tasas, temporizadores ni listas de especies. Apariencia especial puede depender de silueta, marcas, paleta o efectos; conservar legibilidad de ataques y selección aunque sea una criatura excepcional.

Dimensionar pasos y espacios de combate según los habitantes que puedan usarlos. Una criatura grande no debe aparecer encerrada en un pasillo de humano. Bītu conserva su calma; no poblarla de enemigos por aplicar las mismas reglas espaciales al resto de islas.

## 8. Islas, cuevas y regiones

Ficha propuesta por isla o región: identidad, tamaño, accesos, terreno, cuerpos de agua, habitantes, recursos, zonas de encuentros, secretos y conexiones. El archipiélago conserva unas 20 islas y la posible isla grande fuera del centro; este marco no selecciona su reparto definitivo ni sus biomas.

La escala del mundo se mantiene al viajar entre islas. El mapa general puede representarse a otra escala como interfaz, pero el personaje, un tomate y un árbol deben conservar proporciones cuando cambia el lugar jugable.

Admitir costa, interior, minas, cuevas y otros lugares conectados con puntos de entrada y retorno estables. Sectores de 32 × 32 casillas son una propuesta de carga, no el límite de una isla. La continuidad marítima y cómo se muestran las transiciones requieren validación futura.

Mantener fuera de pantalla la información necesaria: recursos recogidos, cambios del terreno de la granja, crecimiento, botín temporal y tiempos pendientes. Descargar un sector no debería reiniciar sus recompensas ni su reaparición. Regla confirmada después: todo el mundo se detiene al salir de la partida o pausarla; no avanza durante la ausencia. Conservar progreso y tiempos restantes para retomar al volver. Duración del ciclo, activación exacta de la pausa y sistema de guardado todavía pendientes de implementación.

Separar ubicación e identidad del recurso: una mena reaparece en otra posición de su zona, pero no se convierte en un objeto de otra isla. Las zonas de aparición no equivalen a sectores de carga y pueden cruzar varios de ellos. Generación fija o procedural sigue abierta.

## 9. Calidad, variantes y colección

Preparar por familia qué características admite: especie o tipo, variante, calidad, tamaño y otros datos acordados. Esas características son independientes. La habilidad específica del tomate está confirmada; no extender automáticamente ese mismo progreso a minería o pesca.

Prístino es máxima calidad; Siru es el nombre elegido para la variante rara del ejemplo de tomate. No llamar Siru a todos los peces, minerales o mobs raros sin elegirlo. Tampoco añadir calidad prístina a criaturas vivas por defecto.

Obtención de Siru en tomates acordada después: mutación rara de la planta durante el crecimiento, ligada a la maestría específica, con cambio visual de la tomatera y cosechas posteriores Siru hasta agotar su vida. También semillas Siru muy escasas encontradas explorando, en cofres o lugares perdidos. Aceptada además una pequeña posibilidad de dejar una semilla Siru al agotarse. Prístino conserva su eje de calidad independiente. Probabilidades, umbrales, momentos de comprobación y entrega de la semilla final pendientes; no convertirlo en una regla general para otras familias. Todavía sin implementar.

Conservar el mismo tamaño de píxel en variantes, con cambios de color, marcas y destellos que sean visibles en el suelo y en inventario. Los actuales tomates básicos están aprobados y los prístinos tienen brillos destacados. Una aparición rara no necesita bloquear el juego con una ventana.

El museo puede vincular cada pieza a su identidad y descubrimiento, conservando donación definitiva y recompensa pendientes de concretar. Una representación del ejemplar en su colección no requiere mantener una criatura viva a tamaño real en el escenario del museo. No añadir acuarios ni exposición doméstica obligatoria.

## 10. Objetos elaborados, equipo e instalaciones

Todas las profesiones utilizan la misma referencia gráfica. Separar el objeto en inventario, su representación como botín y su uso en una acción o instalación:

| Familia | Recursos que conviene prever | Reglas de diseño vigentes |
|---|---|---|
| Cocina | Ingredientes, alimentos preparados, utensilios y lugar de trabajo. | Kit portátil reutilizable con hueco propio, combustible al encender y cocina por lotes desde libro con filtros; combustible concreto pendiente. Prístino mejora recetas y Siru permite preparaciones especiales, sin extender Siru a otras familias. Comida opcional con ventajas duraderas; recetas aprendidas del maestro y explorando. Catálogo, efectos y balance pendientes. |
| Alquimia | Plantas, ingredientes, preparados, recipientes y mesa o espacio de trabajo. | Herboristería silvestre diferenciada de agricultura; recetas y efectos concretos pendientes. |
| Herrería | Minerales, materiales procesados si se eligen, herramientas, equipo y forja. | Mejoras con requisitos pendientes; herramientas permanentes sin desgaste. |
| Agricultura | Semillas, etapas de cultivo, cosechas, herramientas e instalaciones futuras. | Distribución libre, trabajo manual inicial y automatización posterior. |
| Pesca | Cañas, capturas, posibles cebos y representaciones de lugares de pesca. | Desafío activo acordado; cebos y mejoras concretas por definir. |
| Construcción naval | Casco, componentes visibles, instalaciones de astillero y muelle. | Construir y mejorar barcos; atributos, piezas y reparaciones por concretar. |
| Equipo y herramientas | Icono, aspecto equipado y animaciones necesarias. | Huecos propios; no asumir desgaste de armas o armaduras por la regla de herramientas. |
| Museo | Iconos o representaciones de piezas y elementos del edificio. | Donación definitiva del original con recompensa; colección y recuperación del museo por concretar. |

Una mejora puede cambiar el aspecto de una herramienta, barco o casa conservando el punto de apoyo. Si crece la superficie ocupada, prever terreno disponible y accesos antes de aplicar la ampliación. No confundir aumento de capacidad de una bodega con obligación de aumentar físicamente el casco.

Para equipo visible, decidir más adelante entre animaciones específicas y piezas combinables; esta escala permite estudiar ambas opciones. Una armadura o arma encontrada como botín necesita representación en el suelo aunque luego use un hueco propio al equiparse. Reglas para guardarla antes de equiparla siguen pendientes.

**Caso posterior confirmado: pico–hacha con extremos mejorables por separado.** Su primer [recurso básico de hierro](../assets/herramientas/pico-hacha/README.md) incluye regiones independientes de pico, mango y hacha, registro de agarre y rig Godot de revisión. Tamaño presentado de 48,5 × 60,5 dentro de la referencia equipada de 64 × 64, junto al humano de 80; PNG fuente de 1254 × 1254. Se conserva el original y se ajusta la presentación en el motor. Es una proyección con movimientos de prueba; no cierra las vistas ni animaciones de todos los equipos.

Las instalaciones de los maestros respetan sus casas y terrenos: astillero en la propiedad de Flavia, mina junto al minero/herrero y espacios de profesión dentro, fuera o en anexos según el diseño final. El marco no convierte Bītu en una plaza comercial.

## 11. Preparación de recursos y validación futura

Por recurso, acordar: identidad, familia, escala, punto de apoyo, superficie y colisión cuando procedan, acciones y estados necesarios, nombres de archivos y relaciones con objetos obtenidos. Fichas reutilizables permiten añadir especies o islas sin cambiar la escala común.

Para suelo, preparar piezas de terreno, variaciones y transiciones de bordes: riberas, esquinas, costas, caminos y desniveles. Para edificios, prever bases, entradas y elementos que puedan ocultar al personaje. Elementos muy grandes pueden necesitar dibujos divididos para ordenar correctamente la profundidad.

Conservar PNG transparentes para objetos y personajes; filtrado por vecino más cercano y márgenes para efectos. Mantener un punto de apoyo estable entre direcciones y fotogramas. Los primeros bocetos y objetos son referencias visuales grandes; el protagonista dispone después de atlas de poses completas. Ninguno se convierte automáticamente en una exportación normalizada a estas medidas.

Futuras comprobaciones, una vez autorizadas: personaje junto a cultivo, arbusto, árbol y casa; criatura grande en un paso; botín común y raro con varios niveles de zoom; pesca en río, lago y costa; puente con superficies superpuestas; recursos al cargar y descargar sectores. Medir rendimiento de Godot 4 en navegador con contenido representativo antes de fijar densidad y distancias de carga.

Este documento no crea una primera versión con todo el contenido. Existe una prueba visual limitada descrita en [prueba visual](prueba-visual.md); el alcance completo sigue pendiente. No se generan imágenes nuevas ni se suben cambios salvo petición explícita.

Referencias: [diseño vigente](../DISENO.md), [organización del terreno](terreno.md), [tomates existentes](../assets/objetos/cultivos/README.md). Fecha: **8 de octubre de 2026**.
