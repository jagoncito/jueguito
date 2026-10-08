# Bloc de diseño — Bītu y el archipiélago

Última revisión: **8 de octubre de 2026**.

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

1. Despertar en unas ruinas costeras de Bītu.
2. Recorrer un único camino transitable hasta el astillero de Flavia.
3. Conocerla y empezar a preparar la construcción del primer barco.
4. Acceder al resto de Bītu, conocer a sus habitantes y reunir recursos.
5. Construir el barco y abrir la exploración marítima.

El camino inicial conduce al astillero: no debe permitir saltarse ese primer encuentro. Se pueden incluir pequeños recovecos que regresen al mismo sendero.

### Propuestas de distribución y narrativa

- Encerrar el sendero de forma natural entre mar, acantilados y vegetación.
- Abrir el paso al interior después del encuentro con Flavia, atravesando su terreno. La puerta dibujada en los mapas es una propuesta, no una mecánica definitiva.
- Encontrar marcas antiguas o llevar una pieza extraña como posible hilo de misterio. El objeto, su función y su vínculo con otras islas siguen sin confirmar.

**Pendiente:** punto exacto de aparición, primeros diálogos, momento de apertura del paso, tareas iniciales, materiales del barco y primera expedición. No hay una persona confirmada que te encuentre en las ruinas.

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

El núcleo propuesto de Bītu incluye los cinco personajes de servicio originales y la pareja del comerciante a cargo del museo. La ubicación exacta de todos ellos sigue abierta. Conviene reunir funciones en pocos habitantes.

### Mapas conceptuales guardados

- [Primera propuesta de Bītu](mapas/isla-bitu-propuesta-1.png): isla más compacta y accidentada.
- [Segunda propuesta de Bītu](mapas/isla-bitu-concepto.png): bahía amplia, terreno más abierto y silueta alargada.

**Referencia de estructura elegida por el usuario:** `mapas/isla-bitu-concepto.png`. Le gusta la amplitud de la isla, la granja conectada por caminos con todos los maestros y el comercio cercano. Se toma también como referencia para la ubicación costera de la granja, junto a la bahía. Esta elección resuelve la orientación general de la pregunta costa/interior; no hay que volver a preguntarla sin motivo.

Ambos muestran instalaciones dispersas, ruinas, camino inicial y un lugar provisional para la granja. **La distribución detallada y los límites de cada zona aún no son definitivos.** La segunda propuesta guía la estructura; el juego será pixel art. La granja dibujada debe entenderse como parte del hogar del jugador. Se adaptarán caminos, distancias, superficies y transiciones manteniendo la geografía de referencia. La ubicación del museo, ausente en el dibujo, sigue pendiente.

## 6. Personajes

### Reparto funcional indicado por el usuario

| Personaje | Función establecida | Servicios adicionales propuestos |
|---|---|---|
| Comerciante | Vender recursos y gestionar mejoras por concretar. | Suministros, intercambios, encargos y mejoras de inventario o almacenamiento. |
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

Trato y hábitos confirmados:

- Enseña mediante demostraciones: cómo leer una veta, colocar el pico o trabajar el metal.
- Tiene humor seco, con alguna pulla sobre la calidad de una herramienta y reconocimiento del trabajo bien hecho. El cariño se va notando conforme se conocen.
- Se entusiasma al examinar un mineral excepcional; los hallazgos del jugador también pueden despertar su curiosidad.

Propuesta adicional: su terquedad puede expresarse en el cuidado del oficio y en defender métodos que conoce, sin fijar misiones o problemas personales.

Ejemplo provisional de voz: «La piedra avisa antes de romperse. Aprende a escucharla». No es un diálogo definitivo ni confirma capacidades sobrenaturales.

**Maestro de pesca/cocina — carácter confirmado:** tranquilo y buen conversador, con historias del mar y gusto por cocinar para los demás. Es fan de lo raro y legendario; ante una captura excepcional se entusiasma como un niño. Nombre, especie, edad, aspecto e historia concreta pendientes.

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

- Protagonista **humano y personalizable**, con nombre y aspecto elegidos por el jugador.
- La llegada misteriosa es el punto de partida común.
- Propuesta para empezar: pocas opciones de piel, pelo y ropa, ampliables después. Opciones exactas y amplitud del editor pendientes; la especie humana está confirmada.

### Casa y granja

Obtienes una **casa abandonada con un terreno descuidado**, que puedes reparar y transformar poco a poco. Allí vivía el antiguo maestro granjero. El jugador puede llegar a ser **maestro granjero** algún día.

**Preferencia actual del usuario:** terreno útil despejado al comenzar. Rechaza añadir una hoz para limpiar maleza, por su escasa utilidad y por acercarse demasiado a Stardew Valley. No adoptar la propuesta del asistente de una limpieza inicial obligatoria. Vegetación decorativa en los bordes, casa deteriorada y cercas rotas son posibilidades visuales para expresar abandono, pendientes de diseño; la maleza no es un recurso confirmado ni necesita recetas para justificar su existencia.

**Distribución libre de la granja confirmada:** el jugador decide dónde colocar cultivos, caminos e instalaciones dentro de su terreno. Reglas de colocación, tamaños y ampliaciones pendientes. El usuario pide desarrollar cómo se organiza el suelo para encajar edificios, vegetación, recursos, mobs y ríos. [Propuesta de organización del terreno](docs/terreno.md): cuadrícula lógica isométrica, superficies de ocupación, movimiento continuo y zonas de aparición; estas soluciones técnicas son propuestas, no decisiones cerradas.

**Flavia o el comerciante** pueden presentarte la casa y contar que hace tiempo vivía allí un antiguo maestro, sin revelar de entrada su especialidad. El comerciante puede estar de camino; no se ha elegido quién lo hace, el recorrido ni el diálogo.

Ubicación general de referencia: junto a la bahía y cerca del comercio, según `mapas/isla-bitu-concepto.png`; límites exactos, acceso a la propiedad, reparaciones y ampliaciones pendientes. La exposición doméstica no es necesaria; las colecciones tienen el museo como destino. Una isla privada cercana fue una idea anterior, no una ubicación elegida.

## 8. Profesiones y recursos

### Libertad y progreso

**Confirmado:** puedes desarrollar todas las profesiones con el mismo personaje o dedicarte solo a las que quieras. No son excluyentes.

**Base provisional que encaja al usuario:** experiencia al practicar y nuevas posibilidades al progresar; materiales y monedas para mejorar herramientas. Niveles, desbloqueos y requisitos de maestría se decidirán después.

### Inventario

**Límite confirmado: por espacios en la mochila**, no por peso. La mochila se destina a recursos y todo lo recolectable. **Herramientas y equipo tienen huecos propios**, además de otros objetos cuya identidad y distribución quedan pendientes. Número de huecos, objetos apilables, límites de cada pila y tratamiento de objetos recién encontrados que puedan equiparse pendientes. Ampliar la mochila mediante mejoras y disponer de una bodega separada en el barco son propuestas todavía por concretar.

### Botín y recogida

**Dirección vigente, elegida al cambiar el sistema:** el botín aparece como objetos visibles en el mundo y se recoge al acercarse. Se aplica a matar enemigos, recolectar, minar y pescar. Esta decisión sustituye la ventana de botín de referencia WoW y sus modos manual/automático; el saqueo agrupado mediante ventana y los atajos asociados dejan de ser la base.

- **Minería:** interactuar con una mena o veta, ejecutar la animación de extracción y hacer aparecer los materiales cerca de su ubicación. Los aproximadamente 2 segundos mencionados son un ejemplo, no una duración fijada.
- **Recolección:** los objetos aparecen junto a la flor o recurso cosechado.
- **Enemigos:** al derrotarlos, los objetos aparecen cerca del cadáver.
- **Pesca desde la costa:** tras conseguir la captura, el pez se acerca a la orilla cerca del personaje para poder recogerlo. Esto no sustituye el desafío de pesca acordado. Presentación de capturas desde barco pendiente.
- **Recogida automática por cercanía:** al entrar en el radio de recogida, los objetos pasan a la mochila si hay espacio. Si aparecen a los pies del personaje, se recogen prácticamente de inmediato; no requieren otro clic. Radio, animación, cantidades por objeto visible y tratamiento de sobrantes cuando no cabe todo pendientes.

**Tamaño de botín uniforme confirmado: 32 × 32 píxeles.** Todos los objetos de botín usan ese lienzo, incluidos minerales, flores, cosechas, peces y objetos de enemigos. Ajustar cada silueta manteniendo sus proporciones y alojar sus destellos dentro del lienzo común. Esto no iguala el tamaño de las plantas, depósitos, peces nadando ni criaturas originales. **Iconos de inventario: 64 × 64 píxeles**, también aceptados. Representaciones de museo pendientes. Estas medidas son objetivos de producción; los originales existentes aún no están adaptados.

**Desaparición y reaparición indicadas por el usuario:** al terminar de extraer una mena o recolectar una flor, el recurso desaparece como si se hubiese recogido todo y comienza su tiempo de reaparición, aunque el jugador ignore el botín. No esperar a vaciar la ventana para iniciar ese tiempo. No se ha indicado que desaparezcan recursos intactos solo por pasar de largo. Tratamiento de mochila llena y aplicación exacta a otras formas de recurso pendientes.

**Persistencia temporal confirmada para ese botín:** los objetos sin recoger de menas y flores pueden permanecer aproximadamente **10 minutos**, independientemente de la desaparición del recurso y de su tiempo de reaparición. La duración es orientativa; al agotarse, desaparece el botín restante. El cambio de presentación permite volver al lugar y recoger los objetos sin reabrir una ventana. Momento exacto de inicio del plazo y tratamiento al pausar o cerrar el juego pendientes. Plazo para cadáveres y pesca pendiente de concretar.

**Aportaciones del asistente, todavía propuestas:** recoger solo lo que quepa en la mochila y dejar el resto en el mundo; calcular el botín una sola vez; destacar rareza y calidad visualmente, especialmente Siru/prístino; aviso breve de lo obtenido sin bloquear acciones. Para pesca desde barco, situar la captura en la cubierta cerca del personaje. La propuesta de una bolsa para reabrir la ventana queda sustituida por los propios objetos visibles.

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

**Primer recurso solicitado:** [pico–hacha básico de hierro](assets/herramientas/pico-hacha/README.md), PNG transparente con mango de madera y agarre de cuero. Hierro gris estándar, sin efectos de rareza. Incluye medidas de presentación, regiones independientes de pico/mango/hacha, punto de agarre y rig Godot de prueba para minería y tala. PNG fuente de 1254 × 1254; presentación de 48,5 × 60,5 píxeles dentro de una referencia de 64 × 64, junto al humano de 80. Una sola proyección; cuerpo y manos coordinados provisionalmente en la granja. Vistas definitivas y aplicación de mejoras jugables pendientes. Se conserva la revisión independiente `prueba/scenes/herramienta.tscn`.

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

**Mecánica de pesca acordada:** lanzar la caña, esperar la picada y superar un pequeño desafío para sacar el pez. Los peces comunes serán fáciles; los raros podrán tener comportamientos distintos y una dificultad mayor.

Controles, forma del desafío, tiempos, consecuencias de fallar y comportamiento de cada especie pendientes. Cebos, recetas y efectos de comida también están por definir. Cocinar capturas y alimentos de la granja es una conexión propuesta. Se busca que la comida sea útil sin exigir alimentación constante.

### Agricultura

Cultivar alimentos, por ejemplo **patatas y tomates**, en la granja del jugador. Progresar hasta la maestría es un objetivo posible.

**Trabajo confirmado:** al principio plantar, regar y cosechar manualmente. Más adelante se podrá automatizar mediante mejoras. Sistemas concretos, costes y momento de desbloqueo pendientes; esta decisión se refiere a la granja y no confirma automatización de todas las profesiones.

**Falta de riego confirmada:** los cultivos detienen su crecimiento, sin marchitarse ni perder el progreso acumulado. Vuelven a crecer cuando el jugador retoma el riego. Esto permite salir de expedición sin perder la plantación por no atenderla.

**Cosechas excepcionales confirmadas:** habrá productos de mejor calidad y, ocasionalmente, variantes muy raras, incorporando el coleccionismo a la agricultura. Tipos, probabilidades, condiciones de obtención y efectos de la calidad pendientes.

**Experiencia específica por cultivo:** recoger tomates da experiencia en el cultivo de tomates. Al aumentar esa habilidad, aumentan las probabilidades de obtener tomates de calidad excepcional. Cada cultivo tiene su propio progreso; cultivar tomates no sube automáticamente la habilidad de cultivar patatas. Niveles, cantidades de experiencia y probabilidades pendientes.

**Nombre confirmado para la máxima calidad: «Prístino»** (por ejemplo, «tomate prístino»). El resto de categorías de calidad está pendiente. Tomate dorado, semillas especiales, fertilizantes y efectos concretos en cocina o precio fueron ejemplos del asistente, no decisiones confirmadas.

**Nombre elegido para la variante rara: «Siru».** Grafía usada por el usuario para el juego; referencia lingüística: acadio **ṣīru**, «elevado, excelso, sublime». Ejemplo: «tomate Siru». Se mantiene la distinción entre variante y calidad: un ejemplar Siru podría alcanzar calidad prístina. Aspecto, obtención, probabilidades y aplicación del nombre a otros recursos pendientes. Aurath, Náreth y Elyr fueron nombres inventados y no elegidos; no atribuirles significados históricos.

**Recursos gráficos solicitados:** [tomate](assets/objetos/cultivos/tomate.png), [tomate prístino](assets/objetos/cultivos/tomate-pristino.png), [tomate Siru](assets/objetos/cultivos/tomate-siru.png) y [tomate Siru prístino](assets/objetos/cultivos/tomate-siru-pristino.png). Cuatro PNG transparentes pixel art de una pieza cada uno, con vista elevada en tres cuartos. [Previsualizaciones y notas de importación](assets/objetos/cultivos/README.md).

**Diseños básicos aprobados por el usuario:** tomate común rojo y tomate Siru índigo oscuro con vetas doradas. Se conservan intactos.

**Diferenciación prístina solicitada:** debe distinguirse a primera vista por brillos o detalles destacados. Las imágenes prístinas se sustituyeron por nuevas versiones: tomate rojo con contorno luminoso y grandes destellos perlados; Siru con vetas y contorno dorados más luminosos y grandes destellos de oro y blanco. Se reutilizan los mismos nombres de archivo, sin copias anteriores en la carpeta vigente. Los efectos son estáticos en el PNG y no confirman poderes mágicos jugables. El usuario autorizó generar y subir estos dos reemplazos; la generación general sigue en pausa; la prueba posterior conserva estos originales.

Semillas, frecuencia de riego, otros cuidados, tiempos de crecimiento, venta y usos culinarios están por definir. No hay un maestro agricultor vivo adicional confirmado. Esta decisión no determina el progreso mientras el juego está cerrado.

El maestro de pesca/cocina sí ofrecerá orientación secundaria sobre granja, agricultura y animales, incluidos consejos a veces mágicos. El usuario propone aplicar también experiencia específica por tipo de animal. Acciones que dan experiencia, productos afectados, especies y alcance del sistema de ganadería todavía deben concretarse.

### Herboristería y alquimia

**Herboristería:** recolectar plantas silvestres para alquimia durante la exploración. Es distinta de plantar alimentos en la granja; el herboristero no es el maestro de agricultura.

Habrá **flores y arbustos**, siguiendo la misma relación que menas y vetas: muchas más flores y arbustos menos frecuentes con mejores recompensas. Cada tipo tiene su zona de aparición, con posiciones variables dentro de ella.

**Flor de Yde** es un ejemplo inventado por el usuario, no una especie definitiva.

**Palín de herborista, nombre de trabajo:** aceptada la dirección de una pala pequeña específica para plantas y de una animación en la que el personaje se arrodilla junto a la tierra para sacar la flor, planta o recoger hojas. La acción concreta se adaptará al recurso; no todas las hojas requieren arrancar raíces. Prestaciones y requisitos pendientes. Por petición explícita del usuario, la prueba incorpora postura de rodillas, paladas y recuperación de pie al recolectar la flor; animación provisional, no todas las vistas definitivas.

**Diseño visual solicitado e integrado:** el usuario pide que el palín sea más exótico que el pico–hacha clásico. Se crea [una hoja cóncava con forma de hoja vegetal](assets/herramientas/palin-herborista/README.md), metal verde azulado con borde de bronce, nervaduras, pequeño detalle ámbar y mango de madera retorcida con correas verdes. Su apariencia no fija rareza, poderes ni un material nuevo confirmado. PNG transparente integrado con escala 1/32 y agarre registrado; la prueba guarda el pico–hacha y equipa el palín durante la recolección. La flor desaparece y comienza su reaparición al extraerla a los 1,5 segundos; la recuperación termina a los 2 segundos. Parámetros de prueba, no tiempos definitivos.

**Alquimia:** elaborar preparaciones con las plantas recolectadas. Recetas e ingredientes concretos pendientes. Curación, resistencia a peligros y mejoras temporales son efectos propuestos. Plantas propias de cada isla, recetas coleccionables y variantes raras son posibilidades por valorar.

## 9. Navegación y exploración marítima

**Navegación libre:** conduces el barco entre islas. El mar también es espacio de exploración.

Puede haber **cuevas, lugares perdidos, objetos únicos y peces especiales entre las islas**. Cuevas costeras accesibles en barco, restos de embarcaciones y lugares especiales de pesca son ejemplos por concretar. Los puntos marítimos no tienen que ser islas adicionales.

Mejoras propuestas: velocidad, capacidad de carga, resistencia y alcance; personalización de velas/casco y cambios visibles en el muelle. Materiales, precios y efectos exactos pendientes.

Controles de navegación, peligros marítimos, buceo, disposición fija o variable y reaparición de descubrimientos están sin decidir.

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

Beneficios opcionales de comida son una propuesta. Duración del ciclo, rutinas de personajes, alcance de la automatización y progreso mientras no juegas siguen pendientes. La granja empezará manual y se automatizará más adelante. No se ha elegido usar la hora real.

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
- Controles y peligros del barco; primera isla visitable.
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
