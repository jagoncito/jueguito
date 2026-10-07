# Bloc de diseño — Bītu y el archipiélago

Última revisión: **7 de octubre de 2026**.

**Estado: diseño en conversación. La programación sigue en pausa.** El usuario quiere hablar y desarrollar las ideas antes de crear el juego. El mini esquema sirve como orientación; su aceptación no autoriza comenzar a programar. Esperar una instrucción explícita del usuario para iniciar código.

Este es el documento de referencia para retomar el proyecto, también en otro chat. Las decisiones posteriores sustituyen las interpretaciones anteriores. Los detalles pendientes se decidirán con el usuario, de uno en uno.

## 1. Visión del juego

Juego **individual**, de fantasía, en **pixel art y visto desde arriba**. El jugador llega a una tierra misteriosa con pocos habitantes, comienza en **Isla Bītu**, construye su primer barco y explora un archipiélago extenso.

La experiencia se centra en **farmear, mejorar, explorar y coleccionar**. Minería y pesca son especialmente importantes para el usuario. También habrá agricultura, herboristería, alquimia, herrería y cocina. Cada jugador puede dedicar tiempo a todas las profesiones o solo a las que le apetezcan.

Bucle de referencia: explorar → conseguir recursos y hallazgos → conservar piezas especiales y vender o utilizar materiales → mejorar habilidades, herramientas, casa y barco → explorar nuevos lugares.

Se busca que las mejoras se noten y que encontrar algo especial dé ilusión. La presentación concreta de ese bucle y su equilibrio siguen en diseño.

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

Ambos muestran instalaciones dispersas, ruinas, camino inicial y un lugar provisional para la granja. **No se ha elegido un mapa definitivo.** Sus ilustraciones orientan la distribución; el juego será pixel art. La granja dibujada debe entenderse como parte del hogar del jugador, cuya ubicación todavía no está fijada.

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

Las propuestas anteriores de cabello azul petróleo o negro violáceo y ojos de dos tonos no son la dirección elegida. El anillo oscuro del iris tampoco está confirmado. **Peinado liso confirmado** al solicitar la segunda imagen. Matiz exacto del cabello, longitud, ropa y demás detalles se podrán retomar más adelante. Ojos y cabello elegidos describen a Unamahloni; no obligan a todos los Veyari a tener esos colores.

**Personaje en pausa por petición del usuario:** dejarlo por ahora con estas decisiones y no seguir preguntando sobre él hasta que el usuario quiera retomarlo.

El usuario ha solicitado después una imagen pixel art para la futura programación. Primer recurso generado: [Unamahloni — pose quieta](assets/personajes/unamahloni-idle.png), PNG transparente de 1143 × 1376 píxeles. [Notas de uso](assets/personajes/README.md). Es una sola pose, sin animaciones; ropa y accesorios de esta imagen pueden revisarse. Se mantiene la pausa del diseño detallado y de la programación.

Segunda imagen solicitada: [Unamahloni — versión Ghibli con pelo liso](assets/personajes/unamahloni-ghibli.png), también PNG transparente de 1143 × 1376 píxeles. Conserva la identidad, colores y pose, con renderizado de animación dibujada. Se guarda como variante independiente; el estilo global pixel art del juego no se ha revisado todavía.

Tercera imagen solicitada: [Unamahloni — vista isométrica elevada](assets/personajes/unamahloni-isometrico.png), PNG transparente de 1143 × 1376 píxeles. La cámara mira desde arriba en tres cuartos, con referencia a la perspectiva de juego de Diablo IV. Conserva estética Ghibli y pelo liso. Es la variante más reciente del recurso, sin animaciones ni integración en un motor.

La timidez y la religiosidad son rasgos de Unamahloni, no una personalidad común obligatoria para toda su especie.

Los nombres, aspectos y relatos todavía no definidos de los personajes siguen abiertos. Los nombres propuestos anteriormente —Ena, Orun y Sila— no fueron elegidos.

## 7. Protagonista y hogar

### Personaje

- Protagonista **humano y personalizable**, con nombre y aspecto elegidos por el jugador.
- La llegada misteriosa es el punto de partida común.
- Propuesta para empezar: pocas opciones de piel, pelo y ropa, ampliables después. Opciones exactas y amplitud del editor pendientes; la especie humana está confirmada.

### Casa y granja

Obtienes una **casa abandonada con un terreno descuidado**, que puedes reparar y transformar poco a poco. Allí vivía el antiguo maestro granjero. El jugador puede llegar a ser **maestro granjero** algún día.

**Flavia o el comerciante** pueden presentarte la casa y contar que hace tiempo vivía allí un antiguo maestro, sin revelar de entrada su especialidad. El comerciante puede estar de camino; no se ha elegido quién lo hace, el recorrido ni el diálogo.

Ubicación exacta, acceso a la propiedad, reparaciones y ampliaciones pendientes. La exposición doméstica no es necesaria; las colecciones tienen el museo como destino. Una isla privada cercana fue una idea anterior, no una ubicación elegida.

## 8. Profesiones y recursos

### Libertad y progreso

**Confirmado:** puedes desarrollar todas las profesiones con el mismo personaje o dedicarte solo a las que quieras. No son excluyentes.

**Base provisional que encaja al usuario:** experiencia al practicar y nuevas posibilidades al progresar; materiales y monedas para mejorar herramientas. Niveles, desbloqueos y requisitos de maestría se decidirán después.

### Aparición de recursos: minería y herboristería

Regla confirmada para ambas actividades: **cada tipo de recurso tiene su propia zona de aparición y reaparición**. El recurso aparece en distintos puntos dentro de esa misma zona; no vuelve obligatoriamente a la coordenada exacta donde se recogió ni se redistribuye por cualquier lugar del mundo.

| Actividad | Forma mucho más frecuente | Forma menos frecuente, con mejores recompensas |
|---|---|---|
| Minería | Menas | Vetas |
| Herboristería | Flores | Arbustos |

La diferencia de frecuencia debe ser importante. Proporciones exactas, tiempos de reaparición, cantidades simultáneas, límites de cada zona y contenido de las recompensas pendientes. Esta regla se aplica a plantas silvestres; los cultivos de la granja se diseñan por separado.

### Herramientas y acceso a recursos

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

Semillas, cuidados, tiempos de crecimiento, venta y usos culinarios están por definir. No hay un maestro agricultor vivo adicional confirmado.

El maestro de pesca/cocina sí ofrecerá orientación secundaria sobre granja, agricultura y animales, incluidos consejos a veces mágicos. El usuario ha mencionado ganadería como uno de sus intereses; la existencia y alcance de un sistema jugable de ganadería todavía deben concretarse.

### Herboristería y alquimia

**Herboristería:** recolectar plantas silvestres para alquimia durante la exploración. Es distinta de plantar alimentos en la granja; el herboristero no es el maestro de agricultura.

Habrá **flores y arbustos**, siguiendo la misma relación que menas y vetas: muchas más flores y arbustos menos frecuentes con mejores recompensas. Cada tipo tiene su zona de aparición, con posiciones variables dentro de ella.

**Flor de Yde** es un ejemplo inventado por el usuario, no una especie definitiva.

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

El usuario dijo que el siguiente esquema encaja, pero lo considera denso y quiere seguir diseñando antes de programar:

1. Ruinas → camino inicial → encuentro con Flavia.
2. Paso al interior de Bītu y presentación de sus personajes. El esquema original incluía cinco; la incorporación de la pareja del comerciante y del museo al primer tramo está por revisar.
3. Primeras acciones de minería, pesca y recolección de plantas.
4. Venta, una mejora básica de herramienta, combate con un enemigo sencillo y una poción de curación.
5. Materiales y construcción del primer barco como cierre del tramo.
6. Pequeña colección y guardado de progreso.

La navegación, primera expedición, granja desarrollada, cocina completa, jefes y resto del archipiélago requieren revisar el alcance antes de incluirlos. Las propuestas anteriores de un jefe inicial o un destino cercano no son requisitos cerrados de esta versión.

Guardado local es una propuesta inicial; plataforma y sistema definitivo de guardado pendientes. **No se ha elegido motor, tecnología ni plataforma de ejecución.** El proyecto contiene documentación, mapas y recursos gráficos de personaje, sin implementación.

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
- Plataforma, guardado y alcance concreto de la primera implementación.
- Misterios y revelaciones, cuando tenga sentido desarrollarlos.

## 15. Ideas para ampliaciones

Propuestas sin compromiso: encargos, rumores, mapas de un cartógrafo, almacén, ayudantes y automatización, logros, decoración de la casa/granja/barco, nuevas regiones y colecciones.

Taberna, tiendas independientes y más habitantes fueron ideas tempranas. Si se retoman, deben encajar con las pocas personas y sus casas; no convertir Bītu automáticamente en una ciudad.

## 16. Continuidad y publicación

- Repositorio: **jagoncito/jueguito**, rama remota **main**.
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
- **7 de octubre de 2026:** solicitada y creada variante de Unamahloni con estética Ghibli y pelo liso, guardada aparte para conservar el original pixel art. El usuario pide subirla a GitHub.
- **7 de octubre de 2026:** creada variante isométrica elevada de Unamahloni, con Diablo IV como referencia de cámara y conservando estética Ghibli y pelo liso.
