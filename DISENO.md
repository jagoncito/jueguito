# Bloc de diseño — Bītu y el archipiélago

Última revisión: **9 de octubre de 2026**.

**Estado: diseño en conversación y primera prueba visual limitada.** Después de expresar que quiere empezar a programar y preguntar cuándo se podría probar el aspecto, se prepara una pequeña escena provisional de Bītu. No representa el juego completo ni cierra las decisiones pendientes. [Alcance y ejecución](docs/prueba-visual.md).

Este es el documento de referencia para retomar el proyecto, también en otro chat. Las decisiones posteriores sustituyen las interpretaciones anteriores. Los detalles pendientes se decidirán con el usuario, de uno en uno.

## 1. Visión del juego

Juego **individual**, de fantasía, **íntegramente en pixel art**, con **vista desde arriba isométrica cenital**. El jugador llega a una tierra misteriosa con pocos habitantes, comienza en **Isla Bītu**, construye su primer barco y explora un archipiélago extenso.

La experiencia se centra en **farmear, mejorar, explorar y coleccionar**. Minería y pesca son especialmente importantes para el usuario. También habrá agricultura, herboristería, alquimia, herrería y cocina. Cada jugador puede dedicar tiempo a todas las profesiones o solo a las que le apetezcan.

Bucle de referencia: explorar → conseguir recursos y hallazgos → conservar piezas especiales y vender o utilizar materiales → mejorar habilidades, herramientas, casa y barco → explorar nuevos lugares.

Se busca que las mejoras se noten y que encontrar algo especial dé ilusión. La presentación concreta de ese bucle y su equilibrio siguen en diseño.

### Estilo visual y cámara — decisiones confirmadas

- **Pixel art para el juego entero:** personajes, escenarios, recursos y demás elementos visuales del juego.
- **Vista desde arriba isométrica cenital**, entendida como cámara elevada en tres cuartos dirigida hacia el suelo. Diablo IV sirve de referencia de perspectiva.
- **Cámara ajustable con zoom**, para acercar o alejar la vista. En los mapas por zonas, la cámara se desplaza al acercarse el personaje al borde visible y se detiene en los límites del mapa. Distancia inicial, margen exacto de desplazamiento, límites de zoom y comportamiento al navegar pendientes; no se ha confirmado rotación de cámara.
- **Escala común de referencia para planificar:** suelo isométrico de 64 × 32 píxeles y humano de unos 80 píxeles de alto. Tamaños por familia, resolución de pantalla y comprobación visual final pendientes. [Marco de escala para todo el juego](docs/escala-y-recursos.md).
- Tras comparar estilos, se conserva la versión pixel art de Unamahloni y se eliminan las dos variantes ilustradas del repositorio.
- **Generación general de imágenes detenida por petición del usuario.** No crear más imágenes salvo una petición explícita posterior. El entorno de la prueba usa referencias dibujadas por el motor; la petición posterior del pico–hacha autoriza ese recurso concreto, no una producción gráfica general.

### Agua y casa — referencias solicitadas el 9 de octubre

El usuario solicita perfeccionar primero los assets de agua y casa y **ver los resultados antes de subirlos a GitHub**. Autoriza generar estas propuestas concretas; la pausa de generación general se mantiene para otros recursos.

- **Agua:** referencia pixel art aportada por el usuario, con turquesas, zonas azul profundo, reflejos y espuma en los bordes. Adaptar ese lenguaje visual a la bahía costera de Bītu; el puente y las cascadas de la referencia no fijan nuevos elementos del mapa.
- **Casa:** referencia aportada de vivienda rural con paredes claras y entramado de madera, adaptada a pixel art isométrico y con un aspecto más granjero. Mantener el estado inicial abandonado pero habitable ya acordado.
- **Revisión y publicación solicitadas:** tras ver la primera propuesta conjunta, el usuario pide cambiar algún detalle y subirla a GitHub, **sin aplicarla al juego**. La [propuesta revisada](docs/referencias/agua-casa-bitu.png) simplifica el tejado, retirando las ventanas abuhardilladas, y envejece ligeramente las contraventanas. Es una referencia visual; todavía no son sprites registrados ni están integrados en Godot. Los accesorios y el paisaje no constituyen nuevas decisiones de distribución o sistemas. La petición autoriza publicar esta entrega concreta, no futuras subidas automáticas ni integración.
- **Sprites solicitados después:** el usuario aprueba la propuesta revisada y pide crear sprites de agua y casa para continuar el desarrollo, ajustando el tamaño de la casa. Preparado un [lote separado de sprites](assets/entorno/agua-casa/README.md): casa transparente en lienzo 640 × 512, silueta de unos 544 × 414 y puerta de unos 90 px; referencia técnica de suelo de 10 × 7 casillas (544 × 272), tras comprobar que la escala inicial de 8 × 6 dejaba la entrada pequeña junto al dragón. La casa se escala uniformemente. Agua: 16 variantes estáticas de 64 × 32 y ocho bordes/esquinas exteriores, con atlas, anclas y recursos Godot reutilizables. Las fuentes se conservan intactas. La medida de suelo no fija ubicación, colisión definitiva ni ampliaciones de la casa. **El usuario solicita después publicar este lote en GitHub, manteniéndolo fuera del juego.** Esta petición autoriza la subida concreta de los sprites, visor, registro y recursos; no su integración ni futuras subidas automáticas. Animación del agua, esquinas interiores e interiores del edificio pendientes.

## 2. Premisa y misterio

### Decisiones

- Es una **tierra perecedera y misteriosa**, con muy pocos habitantes. El significado exacto de «perecedera» está abierto.
- Llegaste por una razón que no recuerdas. El resto de tus recuerdos todavía no está definido.
- Comienzas en Bītu; construir el primer barco abre la exploración del archipiélago.
- Bītu suele ser tranquila: allí no suele ocurrir nada.

### Información para los creadores, oculta al jugador al principio

| Hecho de diseño | Qué conoce el jugador al principio |
|---|---|
| El protagonista **no puede morir** y reaparece en casa tras ser derrotado. | La explicación de su reaparición se reserva para más adelante. |
| En la casa abandonada vivía un **antiguo maestro granjero**. | Desconoce su especialidad. Puede oír que allí vivía un antiguo maestro. |

La causa de la reaparición, el motivo de la llegada y la identidad e historia del antiguo maestro están pendientes. Tampoco está decidido cuándo se revelan estos hechos.

### Ideas que pueden encajar, sin eventos fijados

Mapas con lugares desconocidos, nombres repetidos en ruinas y objetos, recuerdos contradictorios y objetos antiguos sorprendentemente conservados. Pueden aparecer sucesos extraños sin que todo comparta una única explicación.

La propuesta de que el mundo «pierde su historia» **no se adoptó como premisa**. Tampoco se han decidido una cuenta atrás, desaparición de islas, destrucción de progreso, condición de elegido o misión obligatoria de salvar el mundo.

## 3. Inicio en Bītu

### Dirección acordada

1. Despertar al aire libre, en el patio de unas ruinas costeras de Bītu.
2. Recorrer un único camino transitable hasta el astillero de Flavia.
3. Conocer a Flavia y al maestro minero/herrero, presente en el astillero al comienzo, y empezar a preparar la construcción del primer barco.
4. Acceder al resto de Bītu, conocer a sus habitantes y reunir recursos.
5. Construir el barco y abrir la exploración marítima.

El camino inicial conduce al astillero: no debe permitir saltarse ese primer encuentro. Se pueden incluir recovecos que regresen al mismo sendero.

**Ruinas decididas por delegación expresa del usuario:** un antiguo refugio costero parcialmente derrumbado. Muros de piedra gastada, vigas caídas y restos del tejado en los bordes; patio central abierto y transitable, con hierba baja y vegetación salina. No es una ciudad ni un templo identificado. El dragón despierta en ese patio, sin quedar encerrado en un edificio ni necesitar herramientas para salir. Las coordenadas concretas siguen pendientes.

**Uso de las ruinas:** lugar de llegada y orientación inicial, con espacio para probar movimiento y cámara sin combate obligatorio. Recovecos opcionales regresan al patio o al sendero; el único avance conduce al astillero. Más adelante podrán visitarse de nuevo para investigar las marcas antiguas y una pequeña cámara lateral cerrada, sin resolver de entrada el misterio. Pistas, acceso, recompensas y vínculo con la llegada pendientes; no se fija una profecía ni se obliga a restaurarlas. Esta elección se guarda como diseño; el nivel inicial todavía no está implementado.

**Zona inicial amplia:** se mantiene la dirección de reunir ruinas, sendero y astillero en una misma zona de mapa. El usuario aclara que compartir zona **no implica hacerla pequeña**: deberá conservar una escala amplia y distancias coherentes con el mapa conceptual de Bītu. La cámara recorre un terreno mayor que el área visible. Un único camino de avance es compatible con espacios de exploración alrededor; no reducir el comienzo a un pasillo corto ni comprimir los lugares para que quepan juntos en pantalla. Dimensiones, duración del recorrido y límites pendientes. La primera transición al salir del astillero hacia el interior es la propuesta de conexión; todavía sin implementación.

**Encuentro inicial importante, confirmado por el usuario:** el **maestro minero/herrero está en el astillero al comienzo**. Conecta con el protagonista, le cae bien y le entrega herramientas propias para poder picar y talar desde ese momento, tanto por los caminos como en la granja. En el diseño vigente, pico y hacha forman el pico–hacha combinado. **También entrega una regadera sencilla**, aceptada para comenzar con los cultivos y con su hueco propio de herramienta. Lo invita a visitar su casa, herrería y mina para aprender y mejorar. Su presencia inicial no traslada allí su hogar ni sus instalaciones. Diálogo, motivo de su estancia y otros suministros adicionales pendientes.

**Bienvenida de Flavia confirmada:** durante el encuentro inicial en el astillero, Flavia entrega la mochila al protagonista como parte de su bienvenida. El herrero mantiene el regalo de sus herramientas y Unamahloni entregará el primer palín cuando se lo visite. Diálogos, apariencia de la mochila y condiciones de sus mejoras pendientes; todavía sin implementación narrativa.

**Presentación del hogar acordada:** Flavia y el herrero mencionan la casa abandonada durante el encuentro del astillero. Después, el comerciante, de camino, se la presenta al protagonista y cuenta que allí vivía un maestro muy antiguo. Las menciones iniciales y la presentación posterior se complementan; no revelan al jugador la especialidad del antiguo dueño. Diálogos, recorrido exacto y forma de señalar o enseñar la casa pendientes; todavía sin implementación.

### Propuestas de distribución y narrativa

- Encerrar el sendero de forma natural entre mar, acantilados y vegetación.
- Abrir el paso al interior después del encuentro con Flavia, atravesando su terreno. La puerta dibujada en los mapas es una propuesta, no una mecánica definitiva.
- Encontrar marcas antiguas o llevar una pieza extraña como posible hilo de misterio. El objeto, su función y su vínculo con otras islas siguen sin confirmar.

**Pendiente:** coordenadas de aparición dentro del patio, primeros diálogos, momento de apertura del paso, tareas iniciales, tipos concretos, cantidades y costes de los materiales del barco y primera expedición. No hay una persona confirmada que te encuentre en las ruinas.

## 4. Mundo y archipiélago

### Decisiones

- Un mundo extenso de **unas 20 islas**, con algunas principales.
- Puede haber una isla especialmente grande; no necesita estar en el centro.
- Fantasía con criaturas y personajes variados. **WoW es referencia de diversidad**, sin fijar sus personajes, nombres o facciones para este mundo.
- La temática pirata no es la dirección principal.
- Habrá personajes repartidos o perdidos por el mapa, tanto amigos como enemigos.

### Distribución propuesta, todavía modificable

**Organización por zonas conectadas aceptada:** referencia Stardew Valley. Una «pantalla» significa aquí un mapa o zona, que puede ser mayor que el área visible del monitor. La granja tiene su propio mapa; al salir por un acceso se hace una transición a otro mapa, con sus propios límites. Se conserva una geografía coherente entre caminos y destinos. El usuario quiere seguir esta dinámica como base del juego completo; número, tamaños, conexiones concretas y tratamiento del mar e interiores por cerrar. La prueba actual todavía no implementa estas transiciones ni la cámara acordada.

**Dirección aceptada:** zonas de tamaños distintos, con espacios amplios de exploración y regiones marítimas grandes para evitar transiciones demasiado frecuentes. Dimensiones y conexiones concretas pendientes. Bosques con varios lugares y minas divididas en niveles o sectores son ejemplos, no distribuciones definitivas. Alternativas comentadas sin adoptar: mundo continuo con carga progresiva; combinación de zonas en tierra y mar continuo. Las zonas de mapa son diferentes de las zonas de aparición de cada recurso.

**Criterio de escala reiterado por el usuario:** agrupar varios lugares en una misma zona no exige reducir su tamaño ni sus distancias. El tamaño del terreno se decide por la geografía y la experiencia de exploración; la agrupación determina dónde ocurre una transición de mapa. Se aplica especialmente al comienzo ruinas–sendero–astillero y sirve como criterio para el resto de Bītu.

| Tipo | Cantidad propuesta | Función posible |
|---|---:|---|
| Isla especialmente grande | 1 | Exploración amplia, ruinas y encuentros aislados. |
| Islas principales | 4 | Regiones con identidad propia; Bītu podría ser una. |
| Islas pequeñas | 10 | Expediciones, recursos, pesca, enemigos y secretos. |
| Islas misteriosas | 5 | Lugares difíciles de alcanzar o descubrir y hallazgos especiales. |

La suma propuesta es 20. Regiones volcánicas, boscosas, tropicales/arrecifes y heladas son ejemplos, no biomas definitivos. Una gran isla tampoco implica una ciudad poblada.

Cada isla debería tener motivos para visitarla y volver: recursos, peces, ruinas, desafíos o coleccionables propios. Las rutas, pistas y mejoras del barco podrían facilitar el acceso a nuevos destinos. No se han fijado requisitos de desbloqueo.

## 5. Isla Bītu

**Nombre confirmado: Isla Bītu**, conservando la **ī**. Elegido por el usuario a partir del acadio y la idea de «casa».

Es la isla inicial y el lugar para construir y mejorar barcos, vender recursos y visitar a los maestros. Tiene pocos habitantes y casas dispersas, con terreno natural entre ellas. **No hay una plaza urbana ni una ciudad portuaria bulliciosa.**

Su tamaño mediano-grande es una propuesta que permite espacio natural y futuras ampliaciones. Las dimensiones exactas y su posición en el archipiélago están pendientes.

### Casas y terrenos de los maestros

El jugador visita la **casa de cada personaje**, con las instalaciones de su oficio vinculadas a ella y su terreno. Esas instalaciones pueden estar dentro, fuera, en un edificio anexo o al lado.

- **Flavia:** casa y astillero en su terreno, junto al agua.
- **Minero/herrero:** casa, mina al lado y herrería dentro o en un edificio cercano; distribución pendiente.
- **Otros maestros:** casa y espacios adecuados para sus especialidades; distribución pendiente.
- **Jugador:** casa y terreno para la granja.

No interpretar esto como talleres obligatoriamente dentro de viviendas ni como personajes que simplemente duermen en sus comercios.

El núcleo propuesto de Bītu incluye los cinco personajes de servicio originales y la pareja del comerciante a cargo del museo. Conviene reunir funciones en pocos habitantes.

**Zona compartida de comercio y museo aceptada:** ambos estarán en la misma zona de mapa, cerca de la granja. El comerciante mantiene el comercio y su pareja el museo, abandonado al comienzo. La propuesta de distribución contempla edificios separados con terreno natural entre ellos, conservando las pocas casas dispersas de Bītu. Límites, dimensiones, accesos y posición exacta de los edificios pendientes; compartir zona no exige que ocupen un mismo edificio. Acuerdo de diseño, todavía sin implementación.

**Dos accesos de la granja aceptados:** una salida al camino principal que conecta con la zona de comercio y museo y, desde ella, con las rutas hacia los demás maestros y el astillero; una segunda salida por un sendero costero que conduce hacia el hogar del maestro de pesca/cocina, siguiendo la bahía del mapa conceptual. Caminos y vegetación pueden marcar estos accesos como propuesta visual, sin imponer un cercado. Posiciones exactas, distancias, límites de mapas y zonas intermedias pendientes. No se han implementado estas conexiones.

### Mapas conceptuales guardados

- [Primera propuesta de Bītu](mapas/isla-bitu-propuesta-1.png): isla más compacta y accidentada.
- [Segunda propuesta de Bītu](mapas/isla-bitu-concepto.png): bahía amplia, terreno más abierto y silueta alargada.

**Referencia de estructura elegida por el usuario:** `mapas/isla-bitu-concepto.png`. Le gusta la amplitud de la isla, la granja conectada por caminos con todos los maestros y el comercio cercano. Se toma también como referencia para la ubicación costera de la granja, junto a la bahía. Esta elección resuelve la orientación general de la pregunta costa/interior; no hay que volver a preguntarla sin motivo.

Ambos muestran instalaciones dispersas, ruinas, camino inicial y un lugar provisional para la granja. **La distribución detallada y los límites de cada zona aún no son definitivos.** La segunda propuesta guía la estructura; el juego será pixel art. La granja dibujada debe entenderse como parte del hogar del jugador. Se adaptarán caminos, distancias, superficies y transiciones manteniendo la geografía de referencia. El museo, ausente en el dibujo, compartirá zona con el comercio cerca de la granja; su posición concreta sigue pendiente.

## 6. Personajes

### Reparto funcional indicado por el usuario

| Personaje | Función establecida | Servicios adicionales propuestos |
|---|---|---|
| Comerciante | Compraventa de recursos y venta de ampliaciones de mochila por monedas. | Suministros, intercambios, encargos y almacenamiento. |
| Pareja del comerciante | Ocuparse del museo. | Recuperarlo y estudiar la historia de los hallazgos; detalles pendientes. |
| Unamahloni, maestro alquimista/herboristero | Alquimia y recolección de plantas para ella. | Identificar plantas, enseñar recetas y mejorar utensilios. |
| Maestro minero/herrero | Minería y herrería. | Mejorar pico, fundir minerales y fabricar o mejorar equipo. |
| Maestro de pesca/cocina | Pesca y cocina. | Mejorar caña, enseñar técnicas y recetas para las capturas. |
| Flavia, constructora | Construir y mejorar barcos. | Repararlos y personalizarlos. |

Las funciones de mejora del comerciante no deben duplicar sin motivo las de los maestros. Reparación de barcos, suministros y otros servicios concretos siguen como propuestas.

También pueden existir personajes ocultos, viajeros, rivales, personas que necesitan ayuda y maestros especiales por el archipiélago. Esos ejemplos no añaden habitantes confirmados ni historias definitivas.

### Flavia — ficha confirmada

- **Nombre:** Flavia; relacionado con el latín *Flavius/flavus*, asociado a lo rubio o dorado.
- **Cabello:** rubio.
- **Oficio y hogar:** constructora de barcos, con casa y astillero en Bītu.
- **Presencia:** guerrera y femenina, fuerte y sensible. Las facetas conviven.
- **Dirección mítica y visual:** inspiración sutil de **valquiria**, con apariencia cercana a la humana y rasgos nórdicos relacionados con los barcos. No es literalmente vikinga ni se ha confirmado que sea una valquiria; naturaleza o especie concreta pendientes.
- **Carácter:** cálida, práctica y contenta con su vida. Ayuda por amabilidad.
- **Recibimiento:** puede sorprenderle tu llegada, manteniendo un trato amable.

«Guerrera» describe su presencia y carácter; no confirma pasado militar, armadura, armas ni papel de combate. No necesita un problema propio o una misión personal para justificar su ayuda. La falta de suministros y el proyecto de reparar un barco propio no son historias acordadas.

**Pendiente:** especie, edad, ropa, resto del aspecto y diálogos. Los 30–40 años, botas, ropa de trabajo y cabello recogido fueron sugerencias sin confirmar. Tampoco está establecido que te reconozca o conozca tu pasado.

Referencias visuales dentro de la dirección aceptada: trenzas sencillas, ropa práctica de lino y cuero y un pequeño adorno con motivos antiguos. El diseño definitivo y los detalles exactos siguen pendientes.

### Otros personajes

**Comerciante — rasgos confirmados:** humano, sociable y algo pícaro; disfruta negociando, rebuscando entre objetos curiosos y haciendo buenas compraventas. Cercano y expresivo, recibe bien al jugador. Esto no establece que engañe al jugador ni que sea enemigo. Su nombre, resto del aspecto e historia siguen pendientes.

**Pareja del comerciante — rasgos confirmados:** de origen élfico, curiosa y observadora; se entusiasma al descubrir detalles de piezas antiguas, coherente con su interés por el museo. Nombre, género, apariencia y pasado pendientes.

**Relación confirmada:** cotidiana y cariñosa, con gustos distintos y bromas entre ellos. No se han establecido conflictos o dramas de pareja.

**Maestro minero/herrero — rasgos confirmados:** enano, gnomo o similar; especie exacta por decidir. Tiene barba larga, es muy sabio y terco. Referencia aclarada por el usuario: **Gimli, de El señor de los anillos**, para orientar su carácter y presencia. Nombre, edad concreta, resto del aspecto e historia pendientes. Paciente y de pocas palabras fueron sugerencias anteriores, no rasgos fijados expresamente.

**Primera aparición confirmada:** en el astillero de Flavia al comenzar. Conecta con el protagonista, le entrega herramientas suyas y lo invita a visitarlo para minería y herrería. El regalo abre la extracción básica antes de recorrer el resto de Bītu. El pico–hacha combinado conserva la mejora independiente de sus extremos; no se vuelve a separar por la mención coloquial de pico y hacha. Equipamiento adicional por concretar.

Trato y hábitos confirmados:

- Enseña mediante demostraciones: cómo leer una veta, colocar el pico o trabajar el metal.
- Tiene humor seco, con alguna pulla sobre la calidad de una herramienta y reconocimiento del trabajo bien hecho. El cariño se va notando conforme se conocen.
- Se entusiasma al examinar un mineral excepcional; los hallazgos del jugador también pueden despertar su curiosidad.

Propuesta adicional: su terquedad puede expresarse en el cuidado del oficio y en defender métodos que conoce, sin fijar misiones o problemas personales.

Ejemplo provisional de voz: «La piedra avisa antes de romperse. Aprende a escucharla». No es un diálogo definitivo ni confirma capacidades sobrenaturales.

**Maestro de pesca/cocina — carácter confirmado:** tranquilo y buen conversador, con historias del mar y gusto por cocinar para los demás. Es fan de lo raro y legendario; ante una captura excepcional se entusiasma como un niño. Nombre, especie, edad, aspecto e historia concreta pendientes.

**Primer encuentro, caña confirmada:** regala una caña básica directamente al hablar con él por primera vez. No exige materiales, fabricación, encargo previo ni completar una captura para obtenerla. Puede ofrecer consejos y una práctica opcional junto a su casa; el jugador puede empezar a pescar cuando quiera. Entrega narrativa todavía sin implementar.

Es apasionado de toda la naturaleza, incluidos animales además de peces. Se interesa por la granja, la ganadería y la agricultura. **Su oficio principal sigue siendo maestro de pesca/cocina**; de forma secundaria dará consejos, a veces mágicos, para ayudar con la granja y la experiencia del juego. No sustituye la futura maestría granjera del protagonista.

Referencia indicada por el usuario: **Radagast el Pardo, de Tolkien**, como orientación para su aspecto y presencia. Hay un componente mágico en algunos consejos, pero origen, efectos y funcionamiento pendientes. No se ha establecido una clase de mago, especie concreta o historia equivalente a la de Radagast.

**Unamahloni, maestro alquimista/herboristero — rasgos confirmados:** hombre de una especie humanoide distinta de la humana. Tiene unos **50 años** y es todavía joven para su especie, cuya expectativa de vida ronda los **200 años**. Ya es maestro por su experiencia y conocimientos.

Es metódico, observador, muy curioso, tímido y religioso. **Venera a los espíritus de la naturaleza.** Lleva un cuaderno de fórmulas, estudia las propiedades de las plantas y disfruta experimentando con mezclas. Prácticas, símbolos, identidad de los espíritus, resto del aspecto e historia pendientes. No se ha establecido un vínculo con la reaparición del jugador ni poderes derivados de su fe.

**Especie confirmada: Veyari.** Forma humanoide con referencia aproximada a los humanoides del continente demoníaco de **Mushoku Tensei**. Esa referencia orienta la apariencia; no fija una raza concreta de la obra ni su historia, poderes o carácter para los Veyari.

**Apariencia confirmada:** piel grisácea azulada, orejas de forma humana, **ojos ámbar y cabello de un color similar al ámbar**. Las marcas naturales deben ser **discretas, poco llamativas**; patrón, ubicación y color por definir. El cabello blanco se descartó. Ishari y Aruven dejan de ser alternativas activas; el nombre elegido es Veyari. El fauno sugerido anteriormente no fue elegido.

Las propuestas anteriores de cabello azul petróleo o negro violáceo y ojos de dos tonos no son la dirección elegida. El anillo oscuro del iris tampoco está confirmado. **Peinado liso confirmado**; esa decisión permanece al volver al pixel art. Matiz exacto del cabello, longitud, ropa y demás detalles se podrán retomar más adelante. Ojos y cabello elegidos describen a Unamahloni; no obligan a todos los Veyari a tener esos colores.

**Personaje en pausa por petición del usuario:** dejarlo por ahora con estas decisiones y no seguir preguntando sobre él hasta que el usuario quiera retomarlo.

El usuario ha solicitado después una imagen pixel art para la futura programación. Primer recurso generado: [Unamahloni — pose quieta](assets/personajes/unamahloni-idle.png), PNG transparente de 1143 × 1376 píxeles. [Notas de uso](assets/personajes/README.md). Es una sola pose, sin animaciones; ropa y accesorios de esta imagen pueden revisarse. Se mantiene la pausa del diseño detallado de Unamahloni; no se usa su imagen como protagonista de la prueba.

Las dos variantes ilustradas se descartaron tras comparar estilos y se eliminaron. El recurso pixel art original permanece intacto como primer boceto; todavía no se ha adaptado a la cámara isométrica cenital definitiva ni al peinado liso. No se ha generado una nueva imagen para hacerlo, respetando la petición de detener la generación.

La timidez y la religiosidad son rasgos de Unamahloni, no una personalidad común obligatoria para toda su especie.

Los nombres, aspectos y relatos todavía no definidos de los personajes siguen abiertos. Los nombres propuestos anteriormente —Ena, Orun y Sila— no fueron elegidos.

## 7. Protagonista y hogar

### Personaje

- Protagonista **dragón bípedo**, confirmado el 9 de octubre al elegir el [dragón ya creado](assets/personajes/dragon-avatar/README.md). Se conserva **la misma cara**: ojos ámbar, hocico claro y sonrisa del original. Cuerpo adaptado para caminar sobre dos patas y manejar herramientas; azul grisáceo con marcas ocre y aletas naranjas.
- La llegada misteriosa es el punto de partida común.
- Esta elección sustituye al protagonista humano anterior. Nombre, especie concreta, historia y personalización del dragón siguen abiertos; no aplicar automáticamente las antiguas opciones de piel y pelo humanos.

**Integración vigente, tras la corrección solicitada:** ocho vistas dibujadas (S, SW, W, NW, N, NE, E, SE), cuerpo bípedo proporcionado y unos **90 píxeles de alto** antes del zoom. La cabeza se reajusta conservando identidad facial, paleta y expresión; las perspectivas nuevas no reutilizan literalmente los mismos píxeles. El original queda intacto como referencia. Cola unida a la pelvis y anatomía dibujadas dentro de cada pose completa: reposo, marcha, carga, golpe y recolección arrodillada. Se sustituye el montaje anterior de piezas estiradas. El dragón gira hacia **la base del recurso** antes de trabajar; el punto de contacto de la herramienta se trata aparte para evitar golpear de espaldas o atravesarse con los brazos. Herramientas registradas con las palmas, ocluidas por el cuerpo y los dedos; palín con paladas breves y cambio de apoyo al agacharse, sin mover la posición física ni aumentar el alcance. Cámara inicial de prueba a zoom 1,5, ajustable. La revisión muestra simultáneamente ocho direcciones y permite elegir reposo, marcha, minería, tala y palín. Pesca y combate siguen pendientes. El usuario autoriza esta corrección, limpieza de recursos sustituidos y subida a GitHub; no futuras subidas automáticas.

**Corrección posterior de movimiento y equipo, solicitada por el usuario:** marcha de cuatro fases distintas por cada una de las ocho direcciones (32 registros), con pies y rodillas visibles en movimiento, incluido el perfil izquierdo. Las vistas traseras muestran el avance de espaldas a la cámara, no una marcha frontal reutilizada. La animación sigue el desplazamiento real; se detiene al quedar bloqueado y conserva la velocidad normalizada en diagonales. Cada palma tiene coordenadas medidas en su fotograma y los dedos se presentan sobre el mango; las herramientas cambian de profundidad respecto al torso según la vista. Pico–hacha y palín disponen de ocho proyecciones registradas, con puntos de contacto propios. Se sustituye el atlas de marcha anterior, conservando el original del protagonista. Integración y publicación expresamente solicitadas; acabado de prototipo, no todas las animaciones definitivas.

**Siguiente bloque — perfeccionar el movimiento del protagonista:** el usuario pide revisar los desajustes al desplazarse, girar y sujetar herramientas. La lista siguiente conserva el alcance de la revisión y no autoriza generar imágenes nuevas por sí sola.

1. **Fijar la referencia visual:** escoger una pose de reposo por cada una de las ocho direcciones (S, SW, W, NW, N, NE, E y SE) y registrar tamaño, ancla de suelo, altura de la cabeza, centro del torso, cola, sombra y paleta. Comparar cada fase contra su reposo; la perspectiva puede cambiar el ancho, pero no deben cambiar arbitrariamente la escala, la cara, el tono de piel ni el punto de apoyo.
2. **Auditar el desplazamiento:** comprobar WASD cardinal, diagonales, cambios de dirección continuos, soltar una tecla, chocar con una pared y deslizarse junto a un obstáculo. La marcha debe depender del desplazamiento real, conservar velocidad diagonal normalizada, plantar los pies sin patinar ni avanzar hacia atrás y detener la animación cuando el cuerpo no avanza.
3. **Auditar los giros:** comprobar giro quieto, giro mientras camina y giro rápido entre las ocho direcciones. Hay que decidir si el juego conserva el cambio en ocho direcciones o necesita transiciones/interpolación; no crear 16 vistas hasta tomar esa decisión. En ambos casos se comprobarán ancla, cola, sombra y continuidad de cabeza/torso para que no salten de tamaño ni aparezcan líneas negras o píxeles de otra vista.
4. **Auditar las cuatro fases de marcha:** revisar contacto A, paso A, contacto B y paso B en las ocho direcciones. Comparar pelvis, rodillas, tobillos, pies, hombros y cola mediante superposición de fotogramas. El pie que soporta el peso debe quedar estable durante su apoyo y el contrario debe levantar y avanzar con una trayectoria corta y coherente; izquierda, diagonales y espalda requieren una revisión específica.
5. **Auditar el agarre sin herramienta:** las manos deben volver siempre al mismo sitio del cuerpo al parar, caminar o girar. Registrar para cada dirección la palma principal, la secundaria, el eje de la muñeca y la profundidad respecto al torso. No se deben cruzar los brazos por la espalda ni separar dedos y muñecas al cambiar de fase.
6. **Auditar el pico–hacha y el palín:** para cada una de las ocho vistas registrar punto de agarre principal, segundo agarre, eje del mango, extremo de impacto, escala, espejo permitido y capa delante/detrás. Comprobar reposo, marcha, giro, preparación, impacto y recuperación. El pico–hacha necesita una trayectoria vertical de minería y otra lateral de tala; el palín necesita una trayectoria corta al arrodillarse y levantarse. La herramienta no puede estirarse, flotar, cambiar de tamaño ni quedar horizontal únicamente por estar de perfil.
7. **Vistas o recursos que podrían faltar:** primero se auditarán los recursos existentes. Solo si una vista no puede resolver el problema con sus puntos de agarre y profundidad se preparará material adicional: hasta ocho vistas coherentes por herramienta, posibles fotogramas de transición de giro si se elige giro interpolado, y máscaras/zonas de oclusión para brazos traseros, alas, cola y dedos. No se considera suficiente generar otra hoja completa sin registrar pivotes, manos, pies, ancla y orden de capas.
8. **Registro técnico obligatorio por fotograma:** dirección, fase, región fuente aislada, ancla de suelo, pies, pelvis, hombros, manos, pivote de herramienta, agarres, punto de contacto, escala, espejo y profundidad. Las regiones deben tener margen transparente para no muestrear el fotograma vecino; el PNG original del dragón permanece intacto.
9. **Pruebas visuales antes de aceptar la corrección:** vídeo lento y capturas sobre fondo claro y oscuro de las ocho direcciones; marcha cardinal/diagonal; giros continuos; parada contra pared; pico–hacha en minería y tala; palín; vista de perfil y de espalda; cambio de herramienta durante el recorrido. Además de pruebas matemáticas de longitudes y contactos, se hará revisión humana de silueta, cara, cola, pies, manos, sombras, capas y ausencia de rayas.
10. **Orden de trabajo acordado para este bloque:** auditoría de las fuentes → decisión sobre giro → hoja de medidas → creación o corrección de las vistas que falten → integración en una prueba aislada → revisión visual conmigo antes de tocar la granja o publicar. Hasta que esa revisión no sea satisfactoria, no se subirá otra versión a GitHub.

**Primera pasada aplicada localmente (9 de octubre de 2026, sin subir):** la presentación erguida se normaliza a 90 px y la postura arrodillada conserva una altura menor intencionada; se limpian en memoria pequeños componentes desconectados de las celdas para evitar rayas negras; el pico–hacha conserva tamaño fijo, usa ángulos de transporte corregidos de perfil y sigue una trayectoria de preparación–impacto–recuperación con el impacto sincronizado al contacto; Shift activa un sprint provisional de 225 px/s. Las cuatro pruebas de Godot y la comprobación web de los cinco modos pasan. Falta la revisión del usuario sobre el acabado visual antes de considerar este bloque cerrado o publicarlo.

**Recuperación autorizada (9 de octubre de 2026):** el usuario pide trasladar esta primera pasada pendiente al proyecto local, verificarla, regenerar la descarga y subirla a GitHub conservando el historial. Esta autorización de recuperación y publicación no constituye aprobación visual ni cierra la revisión de movimiento, escala y agarres. No se recuperan los commits descartados ni se añaden sistemas o imágenes nuevos.

**Recursos completados por petición posterior (9 de octubre de 2026):** tras recuperar otro parche de 22 archivos de texto, faltaban sus dos atlas PNG. El usuario pide crearlos, adaptar pixel art y tamaño de cada recurso al juego y subir la entrega. Se crean tres variantes de árbol con sus tocones; una mena con vetas de cobre, su estado picado y una flor violeta llamada Yde en la prueba. Madera, fragmento de mineral y flor recogida usan dibujos de botín distintos. Perspectiva elevada en tres cuartos, luz superior izquierda, transparencias y recortes registrados; árboles de 192–208 px, cobre dentro de 56×52 px, flor de 36 px y botín de hasta 28 px dentro del marco de 32×32, con iconos de mochila de 64×64. Los originales nuevos se conservan intactos y se copian a la prueba. No son los atlas perdidos del hilo anterior. Nombres, especies y efectos definitivos siguen abiertos; no cambia cantidades, tiempos, colisiones ni reglas del prototipo. Esta autorización permite generar, integrar, verificar y publicar estos recursos y su descarga, sin dar por aprobada la revisión visual pendiente del protagonista.

### Casa y granja

Obtienes una **casa abandonada pero habitable, con terreno útil despejado**, que puedes mejorar y transformar poco a poco. Allí vivía el antiguo maestro granjero; su especialidad sigue oculta al jugador. El jugador puede llegar a ser **maestro granjero** algún día.

**Estado inicial decidido por delegación del usuario:** la casa se puede habitar desde la llegada. Tiene estructura sólida, paredes y tejado en buen estado, con una cama y una mesa sencillas. El abandono se expresa mediante polvo, mobiliario gastado y carpintería exterior envejecida. Las reparaciones de esos detalles son opcionales y podrán acompañar mejoras y ampliaciones; no se exige restaurar la casa antes de establecerse. Una construcción antigua puede conservar una estructura útil: fecha de construcción y tiempo desde el abandono siguen sin fijar, sin atribuir una conservación mágica ni revelar la historia del antiguo dueño. Se incorpora el cofre oculto de semillas y carta descrito abajo. Decisión de diseño, todavía sin implementación.

**Primeras semillas, dirección indicada por el usuario:** se encuentran **escondidas en la casa, en un cofre junto a una carta misteriosa del antiguo maestro**. Se adopta este hallazgo para obtener las primeras semillas; el regalo de semillas del comerciante era una propuesta anterior. El comerciante mantiene la presentación de la casa. Especie, cantidad, ubicación del cofre y texto exacto de la carta pendientes; tomate sigue siendo la propuesta inicial. La carta no debe revelar de entrada que el antiguo dueño era maestro granjero ni resolver el misterio del protagonista. Encontrar un cofre con este contenido no decide todavía su uso posterior como almacenamiento general. Todavía sin implementación.

**Intención de la carta confirmada:** debe insinuar que el antiguo maestro **esperaba la llegada del protagonista**, en vez de ser una nota genérica para cualquiera que ocupe la casa. Cómo podía saberlo, por qué lo esperaba y su relación con el protagonista siguen abiertos y ocultos al jugador. La insinuación no confirma profecías, magia, identidad del protagonista ni que el maestro siga vivo.

**Borrador de tono, texto todavía sin aceptar:**

> «No sabía cuánto tardarías en llegar. He guardado estas semillas para ti. Confío en que sabrás qué hacer con ellas.»

**Preferencia actual del usuario:** terreno útil despejado al comenzar. Rechaza añadir una hoz para limpiar maleza, por su escasa utilidad y por acercarse demasiado a Stardew Valley. No adoptar la propuesta del asistente de una limpieza inicial obligatoria. Vegetación decorativa en los bordes y cercas rotas son posibilidades visuales pendientes; el desgaste de la casa se define arriba sin comprometer su habitabilidad. La maleza no es un recurso confirmado ni necesita recetas para justificar su existencia.

**Distribución libre de la granja confirmada:** el jugador decide dónde colocar cultivos, caminos e instalaciones dentro de su terreno. Reglas de colocación, tamaños y ampliaciones pendientes. El usuario pide desarrollar cómo se organiza el suelo para encajar edificios, vegetación, recursos, mobs y ríos. [Propuesta de organización del terreno](docs/terreno.md): cuadrícula lógica isométrica, superficies de ocupación, movimiento continuo y zonas de aparición; estas soluciones técnicas son propuestas, no decisiones cerradas.

**Presentación confirmada:** Flavia y el herrero mencionan la casa en el encuentro inicial del astillero; después el comerciante, que está de camino, te la presenta y cuenta que hace tiempo vivía allí un maestro muy antiguo. La especialidad de ese maestro sigue oculta al jugador. Recorrido exacto, diálogos y forma de mostrar la casa pendientes.

Ubicación general de referencia: junto a la bahía y cerca del comercio, según `mapas/isla-bitu-concepto.png`; límites exactos, acceso a la propiedad, reparaciones y ampliaciones pendientes. La exposición doméstica no es necesaria; las colecciones tienen el museo como destino. Una isla privada cercana fue una idea anterior, no una ubicación elegida.

## 8. Profesiones y recursos

### Libertad y progreso

**Confirmado:** puedes desarrollar todas las profesiones con el mismo personaje o dedicarte solo a las que quieras. No son excluyentes.

**Base provisional que encaja al usuario:** experiencia al practicar y nuevas posibilidades al progresar; materiales y monedas para mejorar herramientas. Niveles, desbloqueos y requisitos de maestría se decidirán después.

### Inventario

**Límite confirmado: por espacios en la mochila**, no por peso. La mochila se destina a recursos y todo lo recolectable. **Herramientas y equipo tienen huecos propios**, además de otros objetos cuya identidad y distribución quedan pendientes. La capacidad inicial, el apilado y la separación de propiedades individuales se fijan abajo; ampliaciones y tratamiento de objetos recién encontrados que puedan equiparse pendientes. Disponer de una bodega separada en el barco sigue siendo una propuesta por concretar.

**Mochila inicial y mejoras confirmadas:** Flavia entrega la mochila durante su bienvenida en el encuentro inicial del astillero. El jugador la irá mejorando para ampliar su capacidad. **Las ampliaciones se compran al comerciante por monedas**, obtenidas vendiendo peces, minerales, plantas o cosechas, para progresar mediante la actividad que prefiera. El herrero conserva el regalo del pico–hacha y la regadera. La casa tendrá un cofre oculto con las primeras semillas y una carta misteriosa; capacidad y uso de almacenamiento doméstico general siguen pendientes. Diálogo, apariencia y costes pendientes; entrega narrativa y ampliaciones todavía sin implementar.

**Capacidad inicial confirmada: 24 huecos para recolectables.** La presentación propuesta es de 6 columnas × 4 filas. Primeras ampliaciones posibles a 36 y 48 huecos, todavía sin aceptar ni fijar el máximo. Herramientas y equipo conservan sus huecos aparte.

**Apilado indicado por el usuario: hasta 1.000 unidades por pila, como regla general para todos los objetos iguales.** Las cantidades de 1 a 999 se muestran como enteros y 1.000 como **«1k»**. Calidad y variante diferentes conservan pilas separadas: tomate común, prístino, Siru y Siru prístino son cuatro tipos distintos. Superar 1.000 requiere otra pila. La rareza por sí sola no justifica un límite menor. La capacidad dependerá sobre todo de la variedad y las pilas de cada recurso, aspecto a considerar al equilibrar futuras mejoras.

**Excepción aceptada:** mantener separados los ejemplares con propiedades individuales diferentes para conservar su identidad, por ejemplo equipo con mejoras distintas o peces con peso propio si se incorporan récords de pesca. Esto no confirma pesos ni récords ni cambia los huecos propios del equipo. Recursos y ejemplares equivalentes siguen el límite general de 1.000. **Presentación aceptada:** conservar la cantidad exacta en el detalle y al dividir o vender una pila, aunque el icono muestre «1k». Ejemplo: 1.200 tomates iguales ocupan dos pilas, «1k» y «200».

**Estado de implementación:** la prueba mantiene 12 huecos y pilas de hasta 50. Los acuerdos de 24/1.000 todavía no cambian el código.

### Botín y recogida

**Dirección vigente, elegida al cambiar el sistema:** el botín aparece como objetos visibles en el mundo y se recoge al acercarse. Se aplica a matar enemigos, recolectar, minar y pescar. Esta decisión sustituye la ventana de botín de referencia WoW y sus modos manual/automático; el saqueo agrupado mediante ventana y los atajos asociados dejan de ser la base.

- **Minería:** interactuar con una mena o veta, ejecutar la animación de extracción y hacer aparecer los materiales cerca de su ubicación. Los aproximadamente 2 segundos mencionados son un ejemplo, no una duración fijada.
- **Recolección:** los objetos aparecen junto a la flor o recurso cosechado.
- **Enemigos:** al derrotarlos, los objetos aparecen cerca del cadáver.
- **Pesca desde la costa:** tras conseguir la captura, el pez se acerca a la orilla cerca del personaje para poder recogerlo. Esto no sustituye el desafío de pesca acordado. Presentación de capturas desde barco pendiente.
- **Recogida automática por cercanía:** al entrar en el radio de recogida, los objetos pasan a la mochila si hay espacio. Si aparecen a los pies del personaje, se recogen prácticamente de inmediato; no requieren otro clic. Radio, animación y cantidades por objeto visible pendientes; recogida parcial y sobrantes acordados abajo.

**Tamaño de botín uniforme confirmado: 32 × 32 píxeles.** Todos los objetos de botín usan ese lienzo, incluidos minerales, flores, cosechas, peces y objetos de enemigos. Ajustar cada silueta manteniendo sus proporciones y alojar sus destellos dentro del lienzo común. Esto no iguala el tamaño de las plantas, depósitos, peces nadando ni criaturas originales. **Iconos de inventario: 64 × 64 píxeles**, también aceptados. Representaciones de museo pendientes. Estas medidas son objetivos de producción; los originales existentes aún no están adaptados.

**Desaparición y reaparición indicadas por el usuario:** al terminar de extraer una mena o recolectar una flor, el recurso desaparece como si se hubiese recogido todo y comienza su tiempo de reaparición, aunque el jugador ignore el botín. No esperar a vaciar la ventana para iniciar ese tiempo. No se ha indicado que desaparezcan recursos intactos solo por pasar de largo. Aplicación exacta a otras formas de recurso pendiente.

**Persistencia temporal confirmada para ese botín:** los objetos sin recoger de menas y flores pueden permanecer aproximadamente **10 minutos**, independientemente de la desaparición del recurso y de su tiempo de reaparición. La duración es orientativa; al agotarse, desaparece el botín restante. El cambio de presentación permite volver al lugar y recoger los objetos sin reabrir una ventana. Momento exacto de inicio del plazo y tratamiento al pausar o cerrar el juego pendientes. Plazo para cadáveres y pesca pendiente de concretar.

**Mochila llena y recogida parcial confirmadas:** se recoge automáticamente solo lo que cabe, completando pilas compatibles cuando sea posible, y el sobrante permanece visible en el suelo con un aviso breve de mochila llena. No descartar objetos ni sustituir otros para hacer sitio. La recogida parcial conserva el plazo de desaparición original del botín; no lo reinicia. Ejemplo: con 980 tomates y sin huecos libres, recoger 50 añade 20 a la pila hasta «1k» y deja 30 en el suelo. Este comportamiento básico ya existe en la prueba con sus límites provisionales de 12/50; 24/1.000 siguen sin aplicar.

**Aportaciones del asistente, todavía propuestas:** calcular el botín una sola vez; destacar rareza y calidad visualmente, especialmente Siru/prístino; aviso breve de lo obtenido sin bloquear acciones. Para pesca desde barco, situar la captura en la cubierta cerca del personaje. La propuesta de una bolsa para reabrir la ventana queda sustituida por los propios objetos visibles.

### Aparición de recursos: minería y herboristería

Regla confirmada para ambas actividades: **cada tipo de recurso tiene su propia zona de aparición y reaparición**. El recurso aparece en distintos puntos dentro de esa misma zona; no vuelve obligatoriamente a la coordenada exacta donde se recogió ni se redistribuye por cualquier lugar del mundo.

| Actividad | Forma mucho más frecuente | Forma menos frecuente, con mejores recompensas |
|---|---|---|
| Minería | Menas | Vetas |
| Herboristería | Flores | Arbustos |

La diferencia de frecuencia debe ser importante. Proporciones exactas, tiempos de reaparición, cantidades simultáneas, límites de cada zona y contenido de las recompensas pendientes. Esta regla se aplica a plantas silvestres; los cultivos de la granja se diseñan por separado.

### Herramientas y acceso a recursos

**Herramientas permanentes:** no se desgastan por uso ni requieren reparaciones periódicas. La progresión se centra en mejorarlas. Esta decisión se refiere a las herramientas; no determina la durabilidad de armas, armaduras o barcos.

**Hoz descartada por el usuario. Pico–hacha combinado aceptado:** una única herramienta con cabeza de doble función, punta de pico en un extremo y filo de hacha en el otro. **Cada extremo se mejora y cambia de aspecto de forma independiente.** Su ejemplo «pico de diamante y hacha de hierro» describe esta independencia, no confirma diamante como material del juego. Nombre definitivo, atributos, recetas, costes y niveles pendientes. Mantener la utilidad de los recursos y evitar materiales repetitivos con pocos usos. Esto no elimina los arbustos de herboristería ni sustituye herramientas de otras actividades como pesca o riego.

**Primer recurso solicitado:** [pico–hacha básico de hierro](assets/herramientas/pico-hacha/README.md), PNG transparente con mango de madera y agarre de cuero. Hierro gris estándar, sin efectos de rareza. Incluye medidas de presentación, regiones independientes de pico/mango/hacha, punto de agarre y rig Godot de prueba para minería y tala. PNG fuente de 1254 × 1254; presentación de 48,5 × 60,5 píxeles dentro de una referencia de 64 × 64, junto al humano de 80. El recurso original es una sola proyección; la corrección del dragón añade ocho perspectivas en otro atlas, agarres por fotograma y dedos sobre el mango. Acabado de animaciones y aplicación de mejoras jugables pendientes. Se conserva la revisión independiente `prueba/scenes/herramienta.tscn`.

**Integración de prueba, 8 de octubre:** tras delegar el usuario el siguiente paso técnico, el personaje empuña el pico–hacha al minar y talar. Los impactos producen efectos; el último entrega botín físico. El árbol deja un tocón transitable. Tres golpes por mena, cuatro por árbol y tres maderas son valores provisionales, no equilibrio confirmado. En esta prueba el árbol permanece talado hasta recargar; su regeneración definitiva está pendiente. La petición posterior de integrar el palín y subirlo incluye esta base jugable en la descarga actualizada.

**Control confirmado:** un clic izquierdo sobre una mena, árbol o flor cercana inicia toda la extracción; no hace falta mantenerlo pulsado ni repetir clics por golpe. El ratón elige el objetivo; la cercanía permite trabajar, sin sustituir la selección por el recurso más próximo. E se conserva para las parcelas y otras interacciones futuras. El clic izquierdo también sigue previsto para ataque; el combate no existe todavía en la prueba.

**Selección automática confirmada:** al interactuar con un recurso, el personaje utiliza la herramienta correspondiente que tiene equipada en su hueco propio; por ejemplo, el pico para una mena. No hay que seleccionarla manualmente antes de cada interacción. Animaciones, controles y tratamiento de herramientas ausentes pendientes; esta comodidad no define todavía la ejecución de la recolección ni sustituye la automatización futura de la granja.

Confirmado: ciertos recursos requieren una herramienta más avanzada para recogerlos. Puedes encontrar, por ejemplo, una veta valiosa antes de tener un pico capaz de extraerla.

Las mejoras de herramientas también aumentan velocidad y rendimiento. Así permiten trabajar mejor y acceder a nuevos materiales. Tipos de herramientas, niveles, recursos afectados, costes y requisitos exactos pendientes; esto no fija automáticamente un requisito de nivel de profesión para cada recurso.

### Minería y herrería

- Explorar minas y galerías con vetas, criaturas y secretos al profundizar.
- Encontrar rocas y vetas también al aire libre.
- Existen **rocas básicas**.
- También hay **vetas preciosas y muy valiosas en la superficie de islas difíciles y peligrosas**.

Además de las rocas básicas, habrá **menas y vetas**, con muchas más menas que vetas. Las vetas darán mejores recompensas y ambas seguirán sus zonas de aparición.

El valor depende del lugar y sus peligros, además de la profundidad. Minerales, extracción, requisitos de pico y tiempos de reaparición pendientes. Fundición y fabricación de equipo son propuestas vinculadas a herrería.

### Pesca y cocina

Pescar y coleccionar peces, incluidos hallazgos especiales en distintas aguas y momentos del día. El maestro reúne pesca y cocina.

**Acceso inicial confirmado:** primera caña básica como regalo directo del maestro al conversar por primera vez, sin requisitos de materiales ni encargo. Tiene su hueco propio de herramienta y se puede utilizar desde ese momento. Práctica guiada opcional, sin condicionar la entrega. Mejoras posteriores, materiales, costes y requisitos pendientes.

**Mecánica de pesca acordada:** lanzar la caña, esperar la picada y superar un pequeño desafío para sacar el pez. Los peces comunes serán fáciles; los raros podrán tener comportamientos distintos y una dificultad mayor.

**Desafío por tensión del sedal aceptado, conservando la propuesta original:** tras la picada, **mantener clic izquierdo recoge sedal y acerca el pez**; **soltar afloja cuando tira fuerte para evitar que escape**. Una pequeña barra muestra la tensión. Se busca acercar el pez a la orilla respondiendo a sus tirones. Comunes fáciles y raros con comportamientos distintos que aprender. Las mejoras de caña aportan mayor control y acceso a capturas más exigentes.

**Balance y detalles pendientes:** lanzamiento y respuesta inicial a la picada, curvas de tensión y acercamiento, comportamiento del avance al aflojar, duración, consecuencias exactas de fallar y propiedades por especie y caña. El usuario retira su preocupación anterior sobre la duración y pide mantener la propuesta original: quedan fuera las sugerencias posteriores de conservar siempre el avance al soltar y de duraciones de 3–5/6–10 segundos. No adoptar esas cifras ni esa simplificación como acuerdos. Pesca todavía sin implementar en la prueba.

Cebos, recetas concretas y efectos específicos de comida están por definir. **Acordado el valor culinario de las cosechas excepcionales:** los ingredientes prístinos mejoran el resultado de recetas y los Siru permiten elaborar preparaciones especiales. Esto conecta los cultivos con el maestro de pesca/cocina. No confirma Siru para todas las familias de ingredientes ni una lista de recetas. Se busca que la comida sea útil y opcional, sin exigir alimentación constante.

**Beneficios de la comida, confirmados:** los platos ofrecen **ventajas temporales duraderas según la actividad**, para prepararse antes de una expedición o una jornada de farmeo. Comer sigue siendo opcional. Mejor control al pescar o más protección durante el combate son ejemplos de efectos por concretar. Duración, intensidad, efectos específicos y acumulación pendientes; todavía sin implementar. Sus tiempos siguen la regla general de mundo detenido al salir o pausar.

**Aprendizaje de recetas, confirmado:** hay **dos vías compatibles: enseñanzas del maestro de pesca/cocina y descubrimientos al explorar**. El maestro enseña gratuitamente las primeras y también puede enseñar otras en distintos momentos de la aventura. Se encuentran recetas por el mundo, incluidas raras, en cofres, ruinas o lugares perdidos. Una vez aprendidas quedan en un **recetario permanente**. Condiciones de las enseñanzas posteriores, catálogo, distribución de recetas y tratamiento de duplicados pendientes; todavía sin implementar.

**Recetario y elaboración, confirmados:** **libro de recetas con filtros y preparación por lotes**. Elegir receta y cantidad, seleccionar ingredientes por calidad/variante y cocinar con una animación breve. Filtros concretos, controles y duración pendientes; todavía sin implementar.

**Cocina portátil confirmada:** el usuario elige la olla de viaje y acepta el funcionamiento del kit siguiente. Las demás instalaciones siguen como posibilidades por concretar.

**Kit de cocina de viaje, funcionamiento acordado:**

- Una olla con soporte plegable como herramienta permanente y reutilizable, con hueco propio separado de la mochila de recursos.
- Desplegar el kit en un terreno despejado y **gastar combustible al encender la hoguera**, pudiendo preparar varios lotes en esa sesión. El usuario menciona **madera o carbón como opciones por decidir**: no se ha elegido uno ni confirmado que ambos sean utilizables. Tipo, cantidades y controles pendientes; consumo asociado al encendido, sin mantenimiento frecuente del fuego acordado.
- Usar el libro de recetas con filtros, seleccionar receta, cantidad e ingredientes por calidad/variante, y preparar con una animación breve.
- Recoger el equipo al terminar para llevarlo a otro lugar. Persistencia y control de recogida pendientes; no perder la herramienta por usarla.
- Obtención inicial propuesta: regalo del maestro de pesca/cocina al conocerlo, junto a la enseñanza de preparaciones sencillas. Este regalo adicional todavía no está confirmado.

**Otras instalaciones de cocina, propuestas todavía abiertas:**

- Cocina o fogón propio en la casa de Bītu, mejorable con utensilios e instalaciones.
- Cocina del maestro de pesca/cocina vinculada a su casa y terreno; distribución y acceso pendientes.
- Ollas o parrillas aprovechables en algunos campamentos encontrados por el mundo, como complemento posible.
- Cocina del barco como mejora posterior, ligada a su interior accesible ya acordado.

**Compatibilidad y mejoras:** la olla permite preparaciones compatibles con ese utensilio, como sopas y guisos; una instalación con horno o parrilla podría ampliar las recetas disponibles. Catálogo por utensilio, consulta del libro fuera de estaciones, cocina doméstica/naval, obtención del kit, combustible concreto, costes, controles y mejoras todavía por concretar. Aceptar el kit no confirma todas las instalaciones propuestas ni el regalo inicial. No imponer una cocina a todas las islas.

### Agricultura

Cultivar alimentos, por ejemplo **patatas y tomates**, en la granja del jugador. Progresar hasta la maestría es un objetivo posible.

**Trabajo confirmado:** al principio plantar, regar y cosechar manualmente. Más adelante se podrá automatizar mediante mejoras. Sistemas concretos, costes y momento de desbloqueo pendientes; esta decisión se refiere a la granja y no confirma automatización de todas las profesiones.

**Cosecha según cultivo, confirmada:** algunos cultivos permanecen después de recoger su producto y vuelven a producir; otros se extraen al cosechar y requieren nueva plantación. Ejemplos de funcionamiento aceptados: **la tomatera permanece y vuelve a dar tomates; las patatas se extraen y se vuelven a plantar**. Catálogo completo y tiempos entre cosechas pendientes. La vida de la tomatera se limita por cosechas, según el acuerdo siguiente.

**Vida de la tomatera, confirmada:** **un número limitado de cosechas**, cuya cifra final se equilibrará después; **cinco sigue siendo solo un ejemplo provisional de balance**. Tras la última, la planta se agota y deja de producir; se puede retirar con una interacción sencilla y plantar de nuevo. Esperar sin cosechar no consume ese número de cosechas, y la falta de agua sigue pausando el crecimiento sin matar la planta. Límite numérico, tiempo entre cosechas y control de retirada pendientes; todavía sin implementación.

**Regadera y recarga aceptadas:** el herrero entrega la regadera sencilla en el astillero, junto al pico–hacha; ocupa un hueco propio de herramienta. Habrá **un grifo rústico junto a la entrada de la casa**, conectado a una cisterna de agua dulce, para llenarla y poder regar desde el comienzo. **Una interacción sencilla llena la regadera por completo.** Consume agua al regar y sus mejoras podrán aumentar la capacidad. Capacidad inicial, consumo por acción, controles, tiempo de recarga y escalones de mejora pendientes de balance y diseño; evitar recargas demasiado frecuentes. El grifo no exige una reparación previa para usarlo.

**Detalle pendiente de la instalación de agua:** apariencia y procedencia exacta del agua de la cisterna abiertos; el acuerdo no incorpora un sistema de gestión de reservas. La regadera equipada, su capacidad y el punto de recarga todavía no están implementados: la prueba solo permite regar las parcelas con E.

**Falta de riego confirmada:** los cultivos detienen su crecimiento, sin marchitarse ni perder el progreso acumulado. Vuelven a crecer cuando el jugador retoma el riego. Esto permite salir de expedición sin perder la plantación por no atenderla.

**Cosechas excepcionales confirmadas:** habrá productos de mejor calidad y, ocasionalmente, variantes muy raras, incorporando el coleccionismo a la agricultura. Tipos, probabilidades, condiciones de obtención y efectos de la calidad pendientes.

**Experiencia específica por cultivo:** recoger tomates da experiencia en el cultivo de tomates. Al aumentar esa habilidad, aumentan las probabilidades de obtener tomates de calidad excepcional. Después se acuerda que **el nivel de ese cultivo también interviene en la posibilidad de mutación Siru**: para la tomatera cuenta la maestría de tomates. Cada cultivo tiene su propio progreso; cultivar tomates no sube automáticamente la habilidad de cultivar patatas. Calidad y variante siguen siendo características distintas. Niveles, cantidades de experiencia, umbrales y probabilidades pendientes.

**Nombre confirmado para la máxima calidad: «Prístino»** (por ejemplo, «tomate prístino»). El resto de categorías de calidad está pendiente. Las semillas Siru se confirman después como vía de cultivo de la variante. Tomate dorado, otros tipos de semillas especiales, fertilizantes y efectos concretos en cocina o precio fueron ejemplos del asistente, no decisiones confirmadas.

**Nombre elegido para la variante rara: «Siru».** Grafía usada por el usuario para el juego; referencia lingüística: acadio **ṣīru**, «elevado, excelso, sublime». Ejemplo: «tomate Siru». Se mantiene la distinción entre variante y calidad: un ejemplar Siru podría alcanzar calidad prístina. Vías de obtención acordadas a continuación; probabilidades y aplicación del nombre a otros recursos pendientes. Aspecto del fruto aprobado en los recursos descritos después. Aurath, Náreth y Elyr fueron nombres inventados y no elegidos; no atribuirles significados históricos.

**Obtención de Siru, confirmada:** la vía principal es **una mutación rara de la planta durante el crecimiento**, con posibilidades ligadas a la maestría del jugador en ese cultivo. Una tomatera normal puede transformarse visiblemente en Siru; sus siguientes cosechas dan tomates Siru hasta agotar su vida por cosechas. La calidad de cada fruto puede ser además prístina, según la maestría. También se pueden encontrar **semillas Siru muy escasas explorando**, en botín de cofres o lugares perdidos, para cultivar la variante en la granja. Esto sustituye la propuesta de un fruto Siru aislado aparecido al cosechar una planta normal. Probabilidades, umbrales, momento y frecuencia de comprobación de la mutación, cantidades de semillas y lugares concretos pendientes; todavía sin implementar. Fertilizantes especiales y experimentación alquímica para obtener Siru siguen como alternativas comentadas, sin confirmar.

**Semilla de una planta Siru, confirmada:** **al agotarse, la planta tiene una pequeña posibilidad de dejar una semilla Siru** para otra plantación. La recompensa es ocasional, no garantizada. Probabilidad exacta y momento de entrega dentro del agotamiento/retirada pendientes; todavía sin implementar.

**Uso culinario de las cosechas excepcionales, confirmado:** los ingredientes prístinos mejoran el resultado de recetas y los Siru sirven para preparaciones especiales, conectando cultivar y coleccionar con el maestro de cocina. En el caso de los tomates, calidad prístina y variante Siru conservan sus funciones diferenciadas. Recetas concretas, efectos, grado de mejora y uso conjunto de Siru/prístino pendientes; todavía sin implementar. Este acuerdo no extiende Siru a nuevas familias de objetos.

**Recursos gráficos solicitados:** [tomate](assets/objetos/cultivos/tomate.png), [tomate prístino](assets/objetos/cultivos/tomate-pristino.png), [tomate Siru](assets/objetos/cultivos/tomate-siru.png) y [tomate Siru prístino](assets/objetos/cultivos/tomate-siru-pristino.png). Cuatro PNG transparentes pixel art de una pieza cada uno, con vista elevada en tres cuartos. [Previsualizaciones y notas de importación](assets/objetos/cultivos/README.md).

**Diseños básicos aprobados por el usuario:** tomate común rojo y tomate Siru índigo oscuro con vetas doradas. Se conservan intactos.

**Diferenciación prístina solicitada:** debe distinguirse a primera vista por brillos o detalles destacados. Las imágenes prístinas se sustituyeron por nuevas versiones: tomate rojo con contorno luminoso y grandes destellos perlados; Siru con vetas y contorno dorados más luminosos y grandes destellos de oro y blanco. Se reutilizan los mismos nombres de archivo, sin copias anteriores en la carpeta vigente. Los efectos son estáticos en el PNG y no confirman poderes mágicos jugables. El usuario autorizó generar y subir estos dos reemplazos; la generación general sigue en pausa; la prueba posterior conserva estos originales.

Catálogo, cantidades y suministro posterior de semillas comunes, parámetros de semillas Siru, frecuencia de riego, otros cuidados, tiempos de crecimiento, venta y usos culinarios están por definir. Las primeras semillas se encontrarán en el cofre oculto de la casa junto a la carta del antiguo maestro. No hay un maestro agricultor vivo adicional confirmado. Durante la ausencia se aplica la regla acordada de mundo detenido.

El maestro de pesca/cocina sí ofrecerá orientación secundaria sobre granja, agricultura y animales, incluidos consejos a veces mágicos. El usuario propone aplicar también experiencia específica por tipo de animal. Acciones que dan experiencia, productos afectados, especies y alcance del sistema de ganadería todavía deben concretarse.

### Herboristería y alquimia

**Herboristería:** recolectar plantas silvestres para alquimia durante la exploración. Es distinta de plantar alimentos en la granja; el herboristero no es el maestro de agricultura.

Habrá **flores y arbustos**, siguiendo la misma relación que menas y vetas: muchas más flores y arbustos menos frecuentes con mejores recompensas. Cada tipo tiene su zona de aparición, con posiciones variables dentro de ella.

**Flor de Yde** es un ejemplo inventado por el usuario, no una especie definitiva.

**Inicio de la recolección aceptado:** algunas primeras plantas pueden recogerse **con las manos**, para recolectar mientras se visita al comerciante, museo, herrero o pescador, antes de encontrarse con Unamahloni. Se conserva la dirección de que Unamahloni entregue el primer palín al conocerlo y enseñe mediante un pequeño encargo; especies, encargo y diálogo pendientes. El control sigue siendo un clic, con uso contextual de manos o herramienta según el recurso.

**Maestría por planta confirmada:** cada especie tiene su propia experiencia, igual que cada cultivo. El usuario propone recoger una flor y ganar **+1 en esa misma planta**; recolectar otra especie no aumenta la primera. La maestría de una especie permitirá la aparición de ejemplares prístinos al alcanzar un umbral X, con frecuencia por concretar. Común y prístino pertenecen a la misma especie y comparten su progreso. Las primeras plantas comunes se podrán recoger a mano; sus prístinas requerirán palín. Los **100 o 200 puntos son ejemplos**, no umbrales fijados. Cantidades para recolecciones con varios productos y probabilidades pendientes. El usuario duda de extender Siru a plantas y considera quedarse con prístino; sin decisión final.

**Acceso a nuevas especies mediante dos requisitos simultáneos, aclarado por el usuario:** cada planta puede exigir **herboristería general suficiente Y un palín adecuado**. Son avances independientes: farmear mucho no sustituye mejorar la herramienta y conseguir una herramienta avanzada no sustituye aprender recolectando. Una condición puede estar cumplida y la otra pendiente; se necesitan ambas. Palín básico → hierro → otros como oro son ejemplos; materiales, jerarquía exacta, costes y especies de cada escalón pendientes. Una especie nueva se empieza a practicar con su propia maestría inicial una vez cumplidos los requisitos; la maestría de las anteriores no se transfiere.

**Herboristería general y maestría específica cumplen funciones diferentes:** la general representa experiencia acumulada recolectando distintas plantas y participa en el acceso a especies más exigentes; la específica determina el progreso hacia ejemplares prístinos de esa especie. La herramienta aporta el requisito material de extracción. Se conservan los tres componentes; fue incorrecta la interpretación anterior del asistente de reemplazar la general por las mejoras del palín.

**Regla inicial recomendada, balance pendiente:** cada recolección completada da +1 a la maestría de su planta y +1 a herboristería general. Es la misma acción con dos efectos, sin experiencia por cada clic o palada ni por recoger de nuevo botín ya extraído. Cantidades por recurso, progresión de experiencia y límites finales pendientes del catálogo. Como ejemplo de requisitos, una especie podría necesitar 60 de general y palín de hierro: 100 de general con palín básico falla por herramienta; 20 de general con palín de oro falla por experiencia; 60 con hierro cumple ambos. **Estas cifras son ilustrativas**, no equilibrio definitivo. Recomendación de interfaz: mostrar por separado si se cumple habilidad y herramienta al señalar una planta.

**Recomendaciones pendientes de acuerdo:** mantener siempre plantas básicas disponibles, incluso al ganar habilidad, y aumentar gradualmente la frecuencia de prístinas. Para herboristería, empezar con común/prístino y conservar abierta la aplicación de Siru fuera de los cultivos. Habilidad, calidad y herramienta deben registrarse por separado para poder ajustar sus requisitos sin cambiar la identidad de cada especie. Estos sistemas todavía no están implementados en la prueba: la flor provisional usa el palín y no tiene habilidad ni calidad.

**Palín de herborista, nombre de trabajo:** aceptada la dirección de una pala pequeña específica para plantas y de una animación en la que el personaje se arrodilla junto a la tierra para sacar la flor, planta o recoger hojas. La acción concreta se adaptará al recurso; no todas las hojas requieren arrancar raíces. Prestaciones y requisitos pendientes. Por petición explícita del usuario, la prueba incorpora postura de rodillas, paladas y recuperación de pie al recolectar la flor; animación provisional, no todas las vistas definitivas.

**Diseño visual solicitado e integrado:** el usuario pide que el palín sea más exótico que el pico–hacha clásico. Se crea [una hoja cóncava con forma de hoja vegetal](assets/herramientas/palin-herborista/README.md), metal verde azulado con borde de bronce, nervaduras, pequeño detalle ámbar y mango de madera retorcida con correas verdes. Su apariencia no fija rareza, poderes ni un material nuevo confirmado. PNG transparente integrado con escala 1/32 y agarre registrado; la prueba guarda el pico–hacha y equipa el palín durante la recolección. La flor desaparece y comienza su reaparición al extraerla a los 1,5 segundos; la recuperación termina a los 2 segundos. Parámetros de prueba, no tiempos definitivos.

**Alquimia:** elaborar preparaciones con las plantas recolectadas. Aceptada la dirección de pociones de efecto rápido, curación, antídotos, protección breve y **mejoras**, añadidas expresamente por el usuario. Recetas, ingredientes, efectos exactos, intensidad, duración y alcance de las mejoras siguen pendientes; no fijar mejoras permanentes por esta aceptación. Plantas propias de cada isla, recetas coleccionables y variantes raras son posibilidades por valorar. Todavía sin implementación.

## 9. Navegación y exploración marítima

**Navegación libre:** conduces el barco entre islas. El mar también es espacio de exploración.

**Construcción del primer barco, acordada:** Flavia lo construye con **madera y metal básicos de Bītu**. El jugador puede reunir esos materiales o comprárselos al comerciante con monedas obtenidas al vender peces, cosechas, plantas o minerales; puede avanzar hacia la exploración desde la actividad que prefiera. **El herrero prepara los herrajes y Flavia monta el barco.** Tipos concretos de madera y metal, cantidades, precios, duración de construcción y aspecto del primer barco pendientes. Este acuerdo no fija requisitos de profesión adicionales ni está implementado en la prueba.

**Evolución y distribución:** el usuario imagina un barco bien equipado con **parte superior y parte inferior: cubierta e interior bajo cubierta**, y acepta que el primero sea pequeño porque evolucionará. Después prefiere el interior como mejora y delega la decisión: **el primer barco tendrá cubierta transitable; el interior accesible llegará mediante una mejora posterior en el astillero de Flavia**. Esta decisión sustituye la propuesta de camarote accesible desde el comienzo. Tamaño, tipo de embarcación, coste de la mejora, distribución y usos del interior pendientes; velero y número de velas sin confirmar. La forma concreta de ampliar el casco o sustituirlo sigue abierta.

**Cubierta y conducción acordadas:** se puede detener el barco, soltar el timón y caminar por la cubierta para pescar. Para conducir, el personaje debe colocarse frente al timón; desde allí **WASD controla el barco**. Al soltarlo, WASD vuelve a mover al personaje. El usuario admite estar sentado o simplemente colocado delante; postura definitiva pendiente.

**Parada elegida por delegación del usuario:** **Espacio detiene el barco y suelta el timón**, dejando al personaje junto a él y permitiendo volver a caminar y pescar con la embarcación detenida. Es una acción contextual durante la conducción; no fija controles a pie ni del esquive. Propuesta para tomar el timón: acercarse y hacer clic izquierdo sobre él, con el personaje de pie. Activación exacta, giro, aceleración, frenada, inercia y atraque por concretar; navegación todavía sin implementar.

**Viaje rápido opcional, confirmado:** la primera llegada a una isla se realiza navegando. **Al desembarcar por primera vez se desbloquea ese punto de llegada** para viajar desde el barco entre puntos descubiertos. **El personaje y su embarcación llegan juntos.** Los puntos pueden ser muelles o desembarcaderos naturales; no requieren puertos habitados en todas las islas. Activación, condiciones, costes y relación con el tiempo de juego pendientes; todavía sin implementar. La navegación manual sigue disponible para explorar el mar y buscar hallazgos.

**Mapa marítimo confirmado:** **Bītu aparece al comienzo y el resto del archipiélago se revela mientras navegas**. Las islas y puntos de desembarco descubiertos quedan señalados para futuras visitas. Extensión inicial conocida alrededor de Bītu, alcance del descubrimiento y presentación pendientes; todavía sin implementar.

Puede haber **cuevas, lugares perdidos, objetos únicos y peces especiales entre las islas**. Cuevas costeras accesibles en barco, restos de embarcaciones y lugares especiales de pesca son ejemplos por concretar. Los puntos marítimos no tienen que ser islas adicionales.

Mejoras propuestas: velocidad, capacidad de carga, resistencia y alcance; personalización de velas/casco y cambios visibles en el muelle. Materiales, precios y efectos exactos pendientes.

Detalles de los controles de navegación, viaje rápido, peligros marítimos, buceo, disposición fija o variable y reaparición de descubrimientos pendientes.

## 10. Combate y derrota

### Controles confirmados

| Acción | Control |
|---|---|
| Moverse | WASD |
| Orientar el ataque | Hacia el cursor del ratón, independiente del movimiento |
| Atacar | Clic izquierdo |
| Esquivar | Existirá; tecla y funcionamiento pendientes |

Combate **en tiempo real**. Armas, alcance, ritmo, recursos de combate y mecánicas del esquive se dejan para más adelante. No se ha elegido espada, arco, bastón ni arma inicial.

### Enemigos

Fantasía variada. Ejemplos propuestos: humanoides y facciones rivales, bestias, criaturas marinas, esqueletos, hechiceros, espíritus, gólems y elementales. Pueden variar por región.

Guardianes de recursos, jefes con trofeos, ataques a distancia y zonas que esquivar son propuestas. No hay lista definitiva de criaturas, facciones, jefes o botín.

### Derrota

- Reapareces **en tu casa** al ser derrotado.
- Pierdes **parte de los materiales que llevas sin guardar**.
- Conservas **herramientas, equipo y coleccionables especiales**.
- La penalización debe hacer que dejarse derrotar no compense como viaje rápido.

Cantidad de pérdida, clasificación de objetos, posible recuperación y casos en el mar pendientes. La imposibilidad de morir es un secreto de diseño; la explicación narrativa sigue abierta.

## 11. Ritmo, día y noche

- **Calma en Bītu y peligro durante las expediciones.**
- Farmear y explorar a tu ritmo.
- Sin obligación de comer continuamente.
- Hay **ciclo de día y noche**, con peces, plantas o criaturas disponibles en distintos momentos.
- Se puede seguir jugando de noche sin obligación de dormir.

Beneficios temporales duraderos de comida según el plato confirmados; efectos concretos y balance pendientes. Duración del ciclo, rutinas de personajes y alcance de la automatización siguen pendientes. La granja empezará manual y se automatizará más adelante. No se ha elegido usar la hora real.

**Tiempo durante la ausencia, confirmado:** **todo el mundo se detiene cuando el jugador deja de jugar**. Al cerrar o salir de la partida no avanzan cultivos, día/noche, reapariciones de recursos, plazos de botín ni automatizaciones. Se conservan el progreso y los tiempos restantes para retomar en el mismo momento al volver. El mundo en pausa tampoco avanza. No hay progreso durante la ausencia. Sistema de guardado y activación exacta de la pausa todavía por concretar e implementar; la prueba actual no guarda progreso.

## 12. Coleccionables premium y ultraexclusivos

### Lo que quiere el usuario

Coleccionar rarezas, variantes visuales especiales y piezas exclusivas o **ultraexclusivas**, con la emoción de poseer algo excepcional. Esto forma parte central de la experiencia.

«Premium» describe el carácter especial de los objetos; no se ha acordado monetización. El juego es individual. La rareza puede hacer que pocos jugadores encuentren una pieza en sus partidas, sin fijar cupos globales o un porcentaje exacto de propietarios.

### Propuestas de diseño

- Minerales, gemas, peces, plantas, recetas, trofeos o piezas decorativas.
- Variantes brillantes, doradas u otras apariencias especiales.
- Hallazgos por azar, exploración, retos y colecciones completadas.
- Piezas ultraexclusivas como objetivos de largo plazo, sin exigirlas para progresar.
- Museo aceptado por el usuario; acuarios y exposición en casa no son necesarios. Uso equipable de las piezas sigue pendiente.
- Proteger piezas frente a ventas accidentales. La protección frente a la derrota sí está confirmada.

No hay tabla de rarezas definitiva, probabilidades, eventos temporales o cantidades limitadas. «Único» todavía no determina si un objeto tiene una sola copia por partida.

### Museo y aportaciones raras

Confirmado por el usuario:

- Un museo encaja como destino de la colección.
- El museo está abandonado al principio.
- Aportar una pieza excepcionalmente rara puede resultar una decisión difícil.
- Debe haber una recompensa, además del logro de completar el museo o algo parecido.

El pez que quizá aparece una vez al año es un ejemplo del problema planteado, no una frecuencia ni un calendario confirmados. Ubicación, funcionamiento detallado y alcance del museo pendientes; su responsable está elegido abajo.

**Reparto elegido:** el comerciante tiene pareja; él se ocupa del comercio y su pareja del museo. Sus intereses son distintos y complementarios: el comerciante reconoce el valor comercial de las piezas y su pareja se interesa por su historia y conservación.

Propuesta: casa junto al museo y pequeño espacio comercial cercano, con recuperación del museo abandonado conforme avanzan los descubrimientos del jugador. Ubicación, momento de recuperación, horarios, nombres y género de la pareja pendientes. El comerciante es humano y su pareja de origen élfico; la relación cotidiana y cariñosa está definida, sin concretar todavía la distribución de su vivienda. La opción anterior de que el comerciante atienda solo ambos sitios deja de ser la base.

Esta pareja añade un sexto personaje al núcleo propuesto de Bītu, manteniendo pocos habitantes. Su inclusión y la del museo en la primera versión jugable siguen pendientes.

Propuestas para debatir: recompensa según rareza, monedas y fichas canjeables por premios especiales, reconocimiento de quién encontró la pieza y registro permanente del descubrimiento. Donaciones voluntarias y recompensas por hitos son opciones sin confirmar.

**Forma de aportar confirmada:** donación definitiva del objeto original. La pieza permanece en el museo, forma parte de la colección del jugador y queda vinculada a su nombre. Donar da una recompensa que merezca la pena; premios concretos pendientes. El préstamo recuperable se descarta como base, al no haber una necesidad establecida de recuperar el ejemplar.

Todavía no se ha decidido si las piezas ultraexclusivas hacen falta para completar el museo ni si habrá usos alternativos para ellas. No dar por hecho que el jugador está obligado a entregar su único ejemplar.

### Nota de probabilidades para el futuro equilibrio

Probabilidad de conseguir al menos una pieza tras `n` intentos independientes, con probabilidad constante `p` por intento: `1 − (1 − p)^n`.

- **0,1 % por intento:** una posibilidad entre 1.000. Tras 1.000 intentos, aproximadamente **63,2 %** de conseguir al menos una.
- **0,000001 % por intento:** una posibilidad entre **100.000.000**.

Estas cifras fueron ejemplos explicativos, no probabilidades elegidas. Ajustar rareza considerando frecuencia y duración de intentos. Probabilidad por intento y porcentaje de jugadores propietarios son cosas distintas; no hay estadísticas globales acordadas.

## 13. Primera versión: orientación, no encargo de programación

**Preparación actual:** el usuario expresa que quiere empezar a programar y pregunta por el esquema global. [Propuesta del primer bloque jugable](docs/primer-prototipo.md): base de movimiento, terreno, botín, mochila y farmeo; escoger prioridad frente al primer recorrido narrativo antes de cerrar esta entrega. La visión global permite empezar por una base sin resolver todas las especies o islas.

El usuario pide subir los acuerdos pendientes a GitHub y preparar lo siguiente mientras se ausenta. Se desarrolla la recomendación de farmeo en [Siguiente bloque preparado](docs/siguiente-bloque.md), con tareas, recursos pendientes y criterios de revisión. Esta preparación no fija el mapa definitivo ni los valores de equilibrio, y precede a la prueba visual limitada descrita después.

El usuario dijo que el siguiente esquema encaja, pero lo considera denso y quiere seguir diseñando antes de programar:

1. Ruinas → camino inicial → encuentro con Flavia.
2. Paso al interior de Bītu y presentación de sus personajes. El esquema original incluía cinco; la incorporación de la pareja del comerciante y del museo al primer tramo está por revisar.
3. Primeras acciones de minería, pesca y recolección de plantas.
4. Venta, una mejora básica de herramienta, combate con un enemigo sencillo y una poción de curación.
5. Materiales y construcción del primer barco como cierre del tramo.
6. Pequeña colección y guardado de progreso.

La navegación, primera expedición, granja desarrollada, cocina completa, jefes y resto del archipiélago requieren revisar el alcance antes de incluirlos. Las propuestas anteriores de un jefe inicial o un destino cercano no son requisitos cerrados de esta versión.

**Motor y primera plataforma confirmados:** Godot 4, con ejecución desde navegador en ordenador y controles de teclado y ratón. El juego sigue siendo individual. Una versión descargable para ordenador es una posibilidad futura, no un requisito confirmado.

La prueba visual posterior utiliza **Godot 4.6.3 y GDScript**, con exportación web sin hilos. Alojamiento y sistema definitivo de guardado pendientes; guardado local sigue siendo una propuesta. La prueba no guarda progreso ni convierte su distribución y parámetros en decisiones definitivas.

## 14. Pendientes para futuras conversaciones

No convertir esta lista en un cuestionario completo. Elegir un tema útil cada vez y conservar las respuestas anteriores.

- Recorrido inicial, diálogo con Flavia, apertura del paso y presentación de la casa.
- Nombres y rasgos visuales todavía no definidos de los personajes, respetando los caracteres acordados. Unamahloni se deja en pausa hasta que el usuario quiera retomarlo.
- Distribución definitiva de Bītu, ubicación del hogar y selección de mapa.
- Primeros materiales, economía, almacenamiento y mejoras.
- Detalles del desafío de pesca; mecánicas de extracción, cultivos, recetas y maestrías.
- Esquive, armas y enemigos; estas preguntas se aplazaron a petición del usuario.
- Duración del día, efectos nocturnos y mejoras para automatizar la granja.
- Detalles de conducción y parada del barco, viaje rápido propuesto y peligros marítimos; primera isla visitable.
- Museo: recompensas por donación definitiva, ubicación y requisitos de completado. Categorías y probabilidades de piezas especiales.
- Detalles de la penalización por derrota, incluido qué ocurre con el barco.
- Guardado, alojamiento, detalles técnicos de Godot 4 y alcance concreto de la primera implementación.
- Misterios y revelaciones, cuando tenga sentido desarrollarlos.

## 15. Ideas para ampliaciones

Propuestas sin compromiso: encargos, rumores, mapas de un cartógrafo, almacén, ayudantes y automatización, logros, decoración de la casa/granja/barco, nuevas regiones y colecciones.

Taberna, tiendas independientes y más habitantes fueron ideas tempranas. Si se retoman, deben encajar con las pocas personas y sus casas; no convertir Bītu automáticamente en una ciudad.

## 16. Continuidad y publicación

- Repositorio: **jagoncito/jueguito**, rama remota **main**.
- Mantener los acuerdos en el bloc local. **Subir a GitHub solo cuando el usuario lo pida explícitamente**, sin subidas automáticas tras cada decisión.
- Este bloc contiene el estado actual. Versiones anteriores y cambios están en el historial de Git.
- Ambos mapas son propuestas visuales; ninguna es el escenario definitivo.
- Al retomar, leer este documento y confirmar qué tema quiere desarrollar el usuario.
- Continuar diseñando hasta que el usuario indique explícitamente que se puede empezar a programar.

### Hitos

- **6 de octubre de 2026:** creación del bloc y evolución hacia archipiélago, minería, pesca, colecciones, fantasía y pixel art.
- **7 de octubre de 2026:** desarrollo de Flavia, casas y oficios, antiguo maestro granjero, controles, navegación, derrota, profesiones y ritmo; confirmado juego individual.
- **7 de octubre de 2026:** revisión completa, consolidación de decisiones y propuestas, corrección de notas antiguas y conservación de ambos mapas.
- **7 de octubre de 2026:** acordada pesca activa con lanzamiento, espera de picada y pequeño desafío de captura; dificultad y comportamiento según el pez.
- **7 de octubre de 2026:** aceptado museo, sin necesidad de acuarios domésticos. Debe recompensar las aportaciones raras además del completado; forma de aportar y recompensas exactas pendientes.
- **7 de octubre de 2026:** elegida donación definitiva del original, conservado en el museo con el nombre del jugador y recompensa. Premios y requisitos exactos pendientes.
- **7 de octubre de 2026:** confirmado museo abandonado al comienzo. En debate: comerciante como responsable o su pareja a cargo del museo, manteniendo el comercio a cargo del comerciante.
- **7 de octubre de 2026:** elegida pareja con funciones e intereses complementarios: comerciante al frente del comercio y su pareja al frente del museo. Identidades y distribución pendientes.
- **7 de octubre de 2026:** aceptado el carácter sociable y algo pícaro del comerciante, con gusto por negociar y descubrir objetos curiosos.
- **7 de octubre de 2026:** confirmado comerciante humano y pareja de origen élfico, curiosa y observadora. Relación cotidiana y cariñosa, con gustos distintos y bromas.
- **7 de octubre de 2026:** confirmado protagonista humano. Flavia tendrá una presencia mítica con rasgos nórdicos sutiles, sin ser literalmente vikinga; especie pendiente.
- **7 de octubre de 2026:** aceptada para Flavia la inspiración sutil de valquiria con apariencia cercana a la humana. Naturaleza exacta abierta.
- **7 de octubre de 2026:** definido maestro minero/herrero como enano, gnomo o similar, con barba larga, muy sabio y terco. Referencia corregida y aclarada: Gimli, de El señor de los anillos.
- **7 de octubre de 2026:** confirmado que el minero/herrero enseña haciendo, tiene humor seco con cariño creciente y se entusiasma con minerales excepcionales.
- **7 de octubre de 2026:** definido maestro de pesca/cocina tranquilo y conversador, aficionado a cocinar para otros y entusiasta de capturas raras y legendarias.
- **7 de octubre de 2026:** incorporada la referencia de Radagast el Pardo para el maestro de pesca/cocina. Aspecto exacto, especie y posible magia pendientes.
- **7 de octubre de 2026:** confirmado su interés por toda la naturaleza, animales, agricultura y ganadería. Ayudará de forma secundaria con consejos, a veces mágicos, manteniendo pesca/cocina como maestría principal. Alcance de ganadería y efectos mágicos pendientes.
- **7 de octubre de 2026:** definido alquimista/herboristero metódico, observador, curioso, tímido y religioso, aficionado a estudiar plantas y experimentar con fórmulas. Fe concreta e identidad pendientes.
- **7 de octubre de 2026:** confirmado que el alquimista/herboristero venera a los espíritus de la naturaleza. Rituales y símbolos pendientes.
- **7 de octubre de 2026:** elegido el nombre Unamahloni. Hombre humanoide de unos 50 años, joven para su especie de expectativa de vida aproximada de 200 años. Propuestos nombre Veyari y rasgos visuales, todavía sin confirmar.
- **7 de octubre de 2026:** confirmado nombre Veyari para la especie. Referencia visual: humanoides del continente demoníaco de Mushoku Tensei; marcas naturales discretas. Colores y rasgos distintivos exactos pendientes.
- **7 de octubre de 2026:** confirmadas piel grisácea azulada y orejas humanas para Unamahloni/Veyari. Retirada la propuesta de cabello blanco; nuevas opciones de cabello y ojos pendientes de elección.
- **7 de octubre de 2026:** elegidos para Unamahloni ojos ámbar y cabello de color similar. El usuario deja el personaje en pausa por ahora.
- **7 de octubre de 2026:** confirmada granja manual al comienzo, con automatización mediante mejoras más adelante. Sistemas y desbloqueos pendientes.
- **7 de octubre de 2026:** confirmadas zonas de aparición propias de cada recurso, con posiciones variables dentro de cada zona. Minería: muchas más menas que vetas, con mejores recompensas en vetas. Herboristería: misma relación entre flores y arbustos.
- **7 de octubre de 2026:** confirmado que ciertas herramientas avanzadas permiten recoger nuevos recursos, además de mejorar velocidad y rendimiento. Requisitos concretos pendientes.
- **7 de octubre de 2026:** creado a petición del usuario el primer recurso pixel art de Unamahloni, PNG transparente de una pose. Solicitada su subida a GitHub; no se ha iniciado código del juego.
- **7 de octubre de 2026:** tras comparar variantes, confirmado pixel art para todo el juego y vista desde arriba isométrica cenital. Eliminadas las dos variantes ilustradas; conservado el original pixel art. Generación de imágenes detenida por petición del usuario.
- **7 de octubre de 2026:** confirmado que los cultivos sin regar detienen su crecimiento y lo retoman al volver a regarlos; no se marchitan por falta de riego.
- **7 de octubre de 2026:** aceptadas cosechas de mejor calidad y variantes muy raras. El usuario indica guardar los acuerdos localmente y subirlos a GitHub únicamente cuando lo pida.
- **7 de octubre de 2026:** definido progreso específico por cultivo: cosechar tomates aumenta la habilidad con tomates y las probabilidades de mejor calidad. El usuario propone «Prístino» como nombre de calidad y una lógica de experiencia específica también para animales; detalles pendientes.
- **7 de octubre de 2026:** elegido «Siru» como nombre de la variante rara, inspirado en el acadio ṣīru, «elevado, excelso, sublime». Aspecto y obtención pendientes.
- **7 de octubre de 2026:** solicitados cuatro recursos pixel art independientes: tomate, tomate prístino, tomate Siru y tomate Siru prístino, con subida explícita a GitHub. Generados PNG transparentes; paleta propuesta roja para comunes e índigo con vetas doradas para Siru. Confirmado el uso de «Prístino» como máxima calidad. Programación en pausa.
- **7 de octubre de 2026:** aprobados los dos tomates básicos. A petición del usuario, sustituidos los dos prístinos por versiones con grandes destellos y contornos luminosos para diferenciarlos a primera vista; mismos nombres de archivo, cuatro imágenes vigentes y sin alterar los básicos.
- **7 de octubre de 2026:** elegidos Godot 4 y navegador como primera plataforma, para jugar en ordenador con teclado y ratón. Versión descargable como posibilidad futura. La programación continúa en pausa.
- **7 de octubre de 2026:** confirmada cámara ajustable con zoom. Controles, distancia inicial y límites pendientes.
- **7 de octubre de 2026:** elegido inventario limitado por espacios, no por peso. Capacidad, apilado y distribución pendientes.
- **7 de octubre de 2026:** confirmados huecos propios para herramientas, equipo y otros objetos por definir; mochila para recursos y todo lo recolectable.
- **7 de octubre de 2026:** aceptada selección automática de la herramienta equipada adecuada al interactuar con recursos.
- **7 de octubre de 2026:** definido botín mediante ventana pequeña para minería, cadáveres y pesca, con recogida manual o automática opcional y aviso breve. Planteados botín agrupado de cadáveres cercanos y atajo de recogida; tiempos y teclas solo ilustrativos. Tratamiento de mochila llena y persistencia quedan como propuestas por concretar.
- **7 de octubre de 2026:** aclarado que menas y flores extraídas desaparecen y comienzan su tiempo de reaparición aunque se ignore el botín; no esperar a recogerlo todo. Destino de los objetos ignorados pendiente.
- **7 de octubre de 2026:** confirmado que ese botín ignorado puede permanecer unos 10 minutos de manera independiente al recurso. Duración orientativa; acceso visual y tratamiento del plazo pendientes.
- **7 de octubre de 2026:** el usuario cambia el sistema a objetos de botín visibles cerca de cadáveres y recursos, recogidos al acercarse. Las capturas llegan a la orilla cerca del personaje. Esta decisión sustituye la ventana de botín y sus opciones anteriores; se conserva la desaparición del recurso con inicio de reaparición y el botín temporal de menas/flores.
- **7 de octubre de 2026:** aclarada y aceptada recogida automática al entrar en el radio de cercanía si hay espacio en la mochila; aparición a los pies implica recogida prácticamente inmediata.
- **7 de octubre de 2026:** confirmadas herramientas permanentes, sin desgaste por uso ni reparaciones periódicas; progresión mediante mejoras.
- **7 de octubre de 2026:** elegida distribución libre para la granja. El usuario pide planificar la división del terreno y la colocación de edificios, vegetación, recursos, criaturas y ríos; añadida una propuesta de cuadrícula y organización espacial, sin código ni nuevas imágenes.
- **7 de octubre de 2026:** recomendada, todavía sin aceptación, escala de suelo 64 × 32 y humano de referencia de 80 píxeles de alto. Tabla de tamaños y proporciones en la propuesta de terreno; originales gráficos sin modificar.
- **7 de octubre de 2026:** aceptada esa base para planificar y solicitado ampliarla a todo el juego. Añadido marco común para familias de cultivos, plantas, minerales, peces, mobs, edificios, barcos, ríos, lagos, mar, cuevas e islas. Rangos y soluciones nuevas son propuestas; no se fija catálogo completo ni se inicia implementación.
- **7 de octubre de 2026:** indicado mismo tamaño de sprite para todo el botín. Propuesto lienzo común de 32 × 32, todavía sin aceptar; mantener proporciones y destellos dentro de ese tamaño.
- **7 de octubre de 2026:** aceptados lienzos de 32 × 32 para todo el botín y 64 × 64 para iconos de inventario; siluetas proporcionadas y destellos dentro del lienzo. Originales sin modificar.
- **7 de octubre de 2026:** el usuario expresa interés en empezar a programar y pide estado del esquema global. Consolidada propuesta de primera entrega jugable, con prioridad y alcance pendientes de cerrar.
- **7 de octubre de 2026:** solicitada subida a GitHub de todos los acuerdos pendientes y preparación del siguiente bloque. Desglosada la base jugable de farmeo en tareas y criterios de revisión; comprobación técnica del motor fuera del repositorio.

- **7 de octubre de 2026:** primera prueba visual limitada para revisar el aspecto: movimiento WASD, zoom, terreno y costa provisionales, mochila, cuatro tomates originales, una mena, una flor y cultivo manual básico. Sin nueva generación artística; posteriormente el usuario pide subir la prueba a GitHub en una carpeta propia. Las cifras y la distribución de prueba no son equilibrio ni mapa definitivos.

- **7 de octubre de 2026:** petición explícita de subir la prueba a GitHub. Se organiza el proyecto en `prueba/`, con captura real, código e instrucciones; incluye una descarga de navegador para ejecutar con Python 3. No se publica todavía un sitio web. Los cuatro PNG originales se copian dentro del proyecto de prueba para que Godot pueda exportarlo como carpeta independiente.

- **8 de octubre de 2026:** aceptada la división en mapas o «pantallas» conectadas al estilo Stardew Valley: cámara que se desplaza al acercarse al borde visible, se detiene en los límites y transición al salir por un acceso. El usuario quiere mantener esta dinámica como base de todo el juego y pide comparar alternativas. Tamaños, distribución y tratamiento del mar pendientes; sin modificar código ni subir estos acuerdos todavía.

- **8 de octubre de 2026:** tras comparar alternativas, aceptada la dirección de zonas conectadas de tamaños distintos, con regiones marítimas amplias. La cantidad, dimensiones y distribución siguen pendientes. Se continúa el diseño sin implementar todavía las transiciones.

- **8 de octubre de 2026:** elegido `isla-bitu-concepto.png` como referencia de estructura. El usuario destaca la isla amplia, los caminos hacia todos los maestros desde la granja y el comercio cercano. La granja costera junto a la bahía del dibujo pasa a ser referencia general; adaptación a zonas y distribución detallada pendientes. Sin generar imágenes ni modificar código.

- **8 de octubre de 2026:** el usuario prefiere terreno despejado y descarta la hoz propuesta para maleza; considera poco útil añadir ese recurso y esa herramienta. Plantea combinar pico y hacha en una cabeza con punta de pico y filo de hacha, y pregunta por su realismo. La herramienta combinada sigue como propuesta; no modificar el prototipo aún por esta conversación.

- **8 de octubre de 2026:** aceptado el pico–hacha con mejoras y materiales visibles independientes por extremo. El usuario solicita imagen pixel art equipada con medidas y detalles necesarios para animarla, una versión básica de hierro, y su subida a GitHub. Preparados recurso transparente, metadatos, regiones de componentes y escena de revisión en Godot. Las cifras de animación son parámetros de prueba; diamante sigue siendo solo su ejemplo hipotético.

- **8 de octubre de 2026:** el usuario delega el siguiente paso técnico. Integrados pico–hacha equipado, minería por impactos, tala con tocón y botín de madera en la granja. Comprobados en Godot y navegador; alcance limitado, sin guardado ni nuevas imágenes artísticas. Parámetros y regeneración de árboles pendientes de diseño. Descarga actualizada localmente; subir solo cuando lo pida.

- **8 de octubre de 2026:** tras discutir los controles, confirmado un clic izquierdo para iniciar toda la extracción de la mena o árbol señalado, sin mantener pulsado ni repetir clics. Sustituye E para minería y tala; las demás interacciones de la prueba siguen con E. No cambia la recogida automática del botín ni autoriza combate o subida.

- **8 de octubre de 2026:** el usuario aclara que ese clic también se aplica a flores. Incorporada recolección completa por clic; E queda para parcelas. Plantea una pala pequeña específica para plantas; propuesta de palín de herborista pendiente de acuerdo, sin generación gráfica ni implementación de herramienta nueva.

- **8 de octubre de 2026:** aceptada la dirección del palín pequeño y de arrodillarse para recolectar. Solicitado un diseño exótico en pixel art; generado PNG transparente con hoja vegetal verde azulada, borde bronce y mango orgánico. Aspecto por revisar, sin animación nueva, integración ni subida a GitHub.

- **8 de octubre de 2026:** petición explícita de implementar el palín y subirlo a GitHub para probarlo. Incorporados equipamiento contextual, postura a una rodilla, movimiento de paladas, extracción y recuperación, con contacto y agarre comprobados desde ambos lados. Actualizadas descarga, captura y notas; código de minería y tala incluido en esta entrega. Continúan pendientes guardado y animaciones definitivas.

- **8 de octubre de 2026:** aceptada la combinación de primeras plantas recogibles a mano y obtención del palín de Unamahloni. El usuario plantea requisitos de habilidad y más ejemplares prístinos que exijan palín al progresar; Siru en herboristería sigue en duda, 100/200 puntos son ejemplos. Confirmado como detalle importante que el minero/herrero aparece inicialmente en el astillero, conecta con el protagonista, le regala herramientas propias y lo invita a su hogar, mina y herrería; permite picar y talar en los caminos y en la granja desde el inicio. Suministros adicionales pendientes. Acuerdos locales, sin código ni nueva subida.

- **8 de octubre de 2026:** aclarada maestría independiente por planta: recoger una flor aumenta la habilidad de esa misma especie, con aparición de prístinas a partir de X. El usuario recomienda acceso a nuevas especies mediante mejoras de palín; hierro y oro son ejemplos de escalones, pendientes de definir. Herboristería general solo se considerará con una función justificada y compatible; no adoptada como requisito. Actualizado el bloc localmente, sin programación ni subida.

- **8 de octubre de 2026:** corrección explícita del usuario: experiencia general y herramienta son requisitos independientes que se conservan y deben cumplirse simultáneamente. Puede tenerse experiencia suficiente sin palín adecuado, o buen palín con experiencia insuficiente. La maestría por especie sigue ligada a sus prístinas. El asistente debe gestionar la compatibilidad y el balance, sin sustituir un sistema por el otro. Corregido el bloc; +1 general por recolección y ejemplo de 60/hierro son recomendaciones provisionales, todavía sin código ni subida.

- **8 de octubre de 2026:** el usuario confirma que las cifras de progresión son ejemplos y deberán equilibrarse después. Al retomar la distribución de Bītu, acepta que comercio y museo compartan zona cerca de la granja. Límites, accesos y posiciones concretas pendientes. Guardado en el bloc local, sin programación ni subida.

- **8 de octubre de 2026:** al proponer ruinas, sendero y astillero en una misma zona, el usuario precisa que eso no debe hacerla pequeña. Conservada la dirección de una zona inicial amplia, con escala y distancias coherentes con el mapa conceptual. Dimensiones y conexión concreta al interior pendientes; sin programación ni subida.

- **8 de octubre de 2026:** aceptados dos accesos para la granja: camino principal hacia comercio/museo y rutas de los maestros y el astillero, y sendero costero hacia el maestro de pesca/cocina. Se conserva la bahía y la amplitud del mapa conceptual. Posiciones y límites concretos pendientes; guardado local, sin programación ni subida.

- **8 de octubre de 2026:** descartado el arcón inicial propuesto junto a la casa. El usuario prefiere recibir de Flavia o del herrero una mochila que se irá mejorando y pregunta por la capacidad. Personaje que la entrega por decidir; propuesta de 24 huecos, primeras ampliaciones a 36/48 y ejemplo de pila de 100 pendientes de aceptación y balance. La prueba conserva 12/50. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptados 24 huecos iniciales. El usuario indica apilado general de hasta 1.000 unidades, mostrando «1k» al superar 999, y pide señalar problemas posibles. Se conserva la separación por calidad/variante; propuesta pendiente de excepción para propiedades individuales diferentes y de mostrar la cifra exacta en el detalle. Ampliaciones 36/48 pendientes; la prueba conserva 12/50. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada la excepción de mantener separados los objetos con propiedades individuales diferentes y conservar cantidades exactas en el detalle al vender o dividir pilas. Los ejemplares equivalentes, incluidos raros, pueden apilarse hasta 1.000. Pesos y récords de peces siguen siendo ejemplos condicionales, no funciones confirmadas. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada recogida parcial cuando la mochila se llena: completar lo que cabe, dejar el sobrante visible en el suelo, avisar brevemente y conservar su plazo original de desaparición. Ejemplo 980 + 50: pila de 1.000 y 30 en el suelo. La prueba ya admite recogida parcial con límites 12/50; los acuerdos 24/1.000 aún no están implementados. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** confirmado que Flavia regala la mochila como parte de su bienvenida en el astillero. El herrero entrega el pico–hacha y Unamahloni el palín en su primera visita. Diálogos y mejoras pendientes; entrega narrativa sin implementar. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptado que el comerciante presente la casa de camino, con la precisión de que Flavia y el herrero también la mencionan en el astillero. El comerciante cuenta que allí vivía un maestro muy antiguo, sin revelar su especialidad al jugador. Diálogos y recorrido exactos pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario delega decidir el estado inicial de la casa, pidiendo coherencia. Elegida casa habitable al llegar, de estructura sólida con cama y mesa básicas; polvo, muebles gastados y carpintería envejecida muestran abandono. Reparaciones y ampliaciones opcionales, terreno útil despejado y sin arcón inicial. Antigüedad y duración del abandono pendientes, sin inventar una explicación mágica. Corregida la descripción antigua de terreno descuidado. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada regadera sencilla como regalo inicial del herrero junto al pico–hacha. El usuario añade un grifo o punto de agua en la entrada de la casa para llenarla. Capacidad y consumo pendientes; propuesta de grifo rústico con cisterna de agua dulce y recarga completa mediante una interacción sencilla, sin confirmar esa instalación exacta. Riego actual del prototipo sin regadera equipada ni recarga. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptados grifo rústico con cisterna de agua dulce junto a la entrada y recarga completa con una interacción sencilla. Dirección de mejoras de capacidad; valores y frecuencia de recarga por equilibrar para que no sea una tarea constante. Instalación y herramienta todavía sin implementar. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario propone primeras semillas escondidas en la casa, dentro de un cofre con una carta misteriosa del antiguo maestro. Adoptado ese hallazgo como dirección frente al regalo de semillas propuesto para el comerciante; este conserva la presentación de la casa. Especie, cantidad, ubicación del cofre, destinatario y texto de la carta pendientes. Se actualiza la antigua exclusión de un arcón inicial, sin fijar todavía almacenamiento general ni revelar la profesión del maestro. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario elige que la carta insinúe que el maestro esperaba su llegada. Motivo, forma de anticiparla y vínculo con el protagonista abiertos; no revelar especialidad del maestro ni secretos iniciales. Añadido un borrador breve de tono, pendiente de aceptación del texto exacto. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada la propuesta original de pesca por tensión: lanzar, esperar picada, mantener clic izquierdo para recoger y soltar para aflojar ante tirones, con barra de tensión y comportamiento por pez. El usuario pide olvidar su objeción sobre duración y volver a esa propuesta. Retiradas las sugerencias posteriores de progreso siempre conservado al aflojar y tiempos 3–5/6–10 segundos; duración y curvas de avance siguen pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario elige recibir la caña básica como regalo al hablar por primera vez con el maestro de pesca/cocina, evitando pedir unos materiales triviales para obtenerla. No requiere fabricación, encargo ni primera captura; la práctica puede ser opcional después. Mejora futura por definir. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptado que el comerciante venda ampliaciones de mochila por monedas, obtenidas mediante venta de peces, minerales, plantas o cosechas. Así el jugador puede avanzar con la actividad que prefiera. Precios y tamaños de mejora pendientes; los ejemplos 36/48 no quedan fijados. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada la construcción del primer barco por Flavia con madera y metal básicos de Bītu, recolectados o comprados al comerciante con ingresos de la actividad elegida. El herrero prepara los herrajes y Flavia monta el barco. Materiales concretos, cantidades, precios, duración y diseño pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario imagina un barco con parte superior e inferior y acepta comenzar con uno pequeño porque evolucionará. Registrada la dirección de cubierta e interior bajo cubierta; acceso inicial al interior, tipo, tamaño y forma de evolución pendientes. Camarote inicial accesible como propuesta, sin confirmar velero ni número de velas. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario prefiere que el interior llegue como mejora y delega la decisión. Elegido primer barco pequeño con cubierta transitable e interior accesible mediante mejora posterior en el astillero de Flavia. Sustituida la propuesta de camarote inicial; dimensiones, coste, distribución y funciones pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptado detener el barco y caminar por cubierta para pescar. El usuario concreta que se controla con WASD al colocarse frente al timón y delega el botón de parada; elegido Espacio para detenerlo y soltar el timón. Clic izquierdo cercano para tomarlo y postura de pie como propuestas. Planteado viaje rápido opcional después de visitar otras islas; recomendación de desbloquear puntos al desembarcar y trasladar personaje y barco juntos, pendiente de aprobación y detalle. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** confirmado el viaje rápido opcional entre puntos de desembarco descubiertos: primera llegada navegando, desbloqueo al desembarcar por primera vez y traslado conjunto del personaje y su barco. Muelles o desembarcaderos naturales válidos. Activación, condiciones, costes y tiempo pendientes; navegación manual disponible. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** confirmado que el mapa comienza con Bītu y revela el resto del archipiélago al navegar, conservando señaladas las islas y puntos de desembarco descubiertos. Extensión inicial, alcance y presentación pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario confirma que todo se detiene cuando deja de jugar. Fijado mundo sin avance durante la ausencia, conservando progreso y tiempos restantes para volver al mismo momento. Cultivos, día/noche, reapariciones, botín temporal y automatizaciones siguen esa regla; el guardado todavía no está implementado. Actualizado el diseño local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada cosecha según el cultivo: tomatera que permanece y vuelve a producir, y patatas que se extraen y requieren replantar. El usuario pregunta hasta cuándo duraría la tomatera. Propuesto límite por número de cosechas, con cinco como ejemplo provisional y retirada sencilla tras agotarse; duración y límite todavía sin confirmar. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada vida de la tomatera limitada por número de cosechas y retirada sencilla tras agotarse. Esperar no consume cosechas; la falta de agua pausa el crecimiento. Cinco cosechas sigue siendo una cifra provisional por equilibrar, sin fijar el límite final. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** elegida mutación rara de la planta como vía principal de Siru, dependiendo del nivel del cultivo específico. La tomatera transformada produce frutos Siru durante sus cosechas posteriores, con calidad prístina independiente. Aceptadas también semillas Siru muy escasas encontradas explorando; el usuario propone cofres y lugares perdidos como fuentes. Probabilidades, umbrales y detalles pendientes; recuperación de semillas de la propia planta todavía sin decidir. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptada pequeña posibilidad de que una planta Siru deje una semilla Siru al agotarse, permitiendo continuar su linaje de forma ocasional. Probabilidad exacta y entrega pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** confirmado valor culinario de las cosechas excepcionales: ingredientes prístinos que mejoran el resultado de recetas e ingredientes Siru para preparaciones especiales. Vinculado cultivo con el maestro de cocina. Recetas y efectos concretos pendientes; no extender Siru automáticamente a otras familias. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** confirmados beneficios temporales duraderos según el plato y la actividad, para preparar expediciones o jornadas de farmeo. Comida opcional; control al pescar y protección en combate como ejemplos por concretar. Efectos, intensidad, duración y acumulación pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptado aprender recetas tanto del maestro de pesca/cocina como explorando el mundo. El usuario precisa que el maestro puede enseñarlas a veces, más allá de las primeras gratuitas propuestas. Las aprendidas se conservan en el recetario; catálogo, condiciones de enseñanzas posteriores y distribución de hallazgos pendientes. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario propone libro de recetas con filtros al discutir cocinar por lotes y pregunta dónde se elaboran los platos, incluyendo puntos del mapa y ollas. Registrada dirección del recetario; propuestas de cocina propia, instalaciones del maestro, campamentos y futura cocina naval pendientes de aceptación. Portabilidad y requisitos de estaciones abiertos. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** el usuario prefiere la olla de viaje frente a priorizar puntos fijos de cocina y pide describirla. Propuesto kit reutilizable con hueco de herramienta, montaje en terreno despejado, pequeña cantidad de madera por sesión, cocina por lotes y recogida al terminar. Regalo del maestro y compatibilidad por utensilio como propuestas adicionales, todavía sin confirmar. Guardado local, sin programación ni subida.

- **8 de octubre de 2026:** aceptado el funcionamiento del kit portátil: herramienta reutilizable con hueco propio, montaje en terreno despejado, combustible al encender, cocina por lotes desde el libro con filtros y recogida al terminar. El usuario propone madera o carbón y deja el combustible concreto por decidir. Cantidades, controles y obtención del kit pendientes; regalo del maestro todavía como propuesta. Guardado local, sin programación ni subida.

- **9 de octubre de 2026:** aceptada la dirección de alquimia con preparaciones rápidas, curación, antídotos y protección breve; el usuario añade mejoras. Efectos y recetas por concretar; guardado local, sin implementar alquimia.
- **9 de octubre de 2026:** el usuario elige el dragón del repositorio como protagonista y solicita adaptarlo a bípedo, conservar exactamente su cara y preparar animaciones dentro del juego con herramientas. Sustituye la especie humana anterior. Se conserva intacto el PNG original y se articula un nuevo cuerpo, con vistas frontal/reflejada y de espalda, caminar, minería, tala y palín. Integración limitada a la prueba; no autoriza subida automática ni otros sistemas.
- **9 de octubre de 2026:** el usuario solicita subir a GitHub la entrega preparada: dragón bípedo, animaciones integradas, capturas y vídeo, prueba de navegador actualizada y acuerdos pendientes del bloc. Original intacto; validada la prueba en Godot y navegador. Esta petición no autoriza futuras subidas automáticas.

- **9 de octubre de 2026:** el usuario señala proporciones y cola incorrectas, falta de vistas y brazos que atraviesan la espalda al extraer. Solicita rehacer anatomía y ocho vistas como mínimo, priorizando la calidad en el juego y manteniendo los rasgos de la cara. Sustituido el rig de piezas por poses completas con cola conectada; corregida orientación hacia el suelo del recurso, independiente del impacto elevado. Integración, revisión direccional, retirada de recursos sustituidos y publicación de esta corrección autorizadas.
- **9 de octubre de 2026:** al pedir comprobar lo que quedó a medias, se detectan capturas de la granja todavía con el montaje antiguo, imágenes de minería/tala en reposo y rótulos inferiores recortados. Se completa la revisión pendiente: capturas actuales del juego, poses fijas verificadas en las ocho vistas, rótulos dentro del área visible y descarga regenerada. No cambia los acuerdos de diseño ni añade sistemas de juego.
- **9 de octubre de 2026:** el usuario delega aspecto y uso de las ruinas: elegido refugio costero derrumbado con patio abierto de llegada y posible investigación posterior, sin implementar todavía ese nivel. Solicita corregir izquierda, diagonales, marcha trasera y herramientas flotantes; autoriza nuevas vistas necesarias e integración y subida. Preparadas cuatro fases de marcha por dirección, agarres por fotograma, oclusión de dedos, profundidad según vista y ocho perspectivas de cada herramienta. Conservados controles, contactos y tiempos de extracción.

- **9 de octubre de 2026:** el usuario pide una animación de picar y talar sin giro artificial de la herramienta. Aclara que quiere un golpe natural de brazos y cuerpo, permitiendo que cambie la orientación del mango al acompañar las manos. Corrección local: eje del mango ligado a ambas palmas, carga elevada de minería y preparación lateral de tala, apoyo y recuperación. Sin nuevos sistemas ni imágenes; revisión visual pendiente, sin nueva autorización de publicación.

- **9 de octubre de 2026:** el usuario fija **cinco golpes iniciales para minería y tala**, con mejoras futuras que reduzcan la extracción hasta **un golpe**. Ajustado únicamente el número inicial en la prueba; conservados animación, 0,62 s por golpe y extracción automática por un clic. Cómo se consiguen las mejoras y sus escalones sigue pendiente; no se implementa todavía ese sistema. Guardado local, sin nueva subida.

- **9 de octubre de 2026:** el usuario amplía a **herboristería y pesca** la dirección de empezar con más esfuerzo y reducirlo mediante mejoras, tomando como referencia **cinco acciones iniciales hasta una**; permite dejarlo anotado. Registrado como objetivo de progresión, sin modificar estas actividades ahora. Qué representa una acción en recolección y cómo se aplica a la pesca por tensión del sedal quedan pendientes; no convertirlo en cinco clics obligatorios ni sustituir el sistema de pesca acordado. Los cinco golpes iniciales de minería y tala sí están ajustados en la prueba.

- **9 de octubre de 2026:** el usuario solicita generar sprites de hierba y tierra para implementarlos posteriormente. Preparado un atlas con dos variantes de cada suelo, transparencia y catálogo de recortes/anclas para presentación de referencia 64 × 32. Fuente conservada sin editar en `assets/entorno/terreno/`; todavía sin integrar en el juego. Repetición, uniones y transiciones pendientes de revisión; autorización de imágenes limitada a estos recursos, sin nueva subida.

- **9 de octubre de 2026:** tras descartar Brumara y aclarar que Bītu es la isla y el archipiélago no tiene nombre, el usuario propone **Miutu** y solicita generarlo y subir todo lo pendiente. Preparada primera propuesta visual: cuadrúpedo pequeño y redondeado, pelaje gris azulado, hocico/vientre crema, orejas anchas y cuernos claros. Leche y quesos siguen como usos propuestos; no se confirman por esta petición el conjunto de propuestas anteriores de ganadería, alimentación o cuidados. Sprite SE con altura orientativa de 48 px, sin integración ni animaciones. Autorizada esta publicación y la de los cambios locales pendientes —golpes, cinco golpes iniciales, acuerdos de progresión y hierba/tierra—, conservando las entregas posteriores de agua/casa. Revisión visual todavía pendiente; no autoriza futuros sistemas ni subidas continuas.
