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

Los cinco personajes de servicio son la propuesta de núcleo de Bītu. La ubicación exacta de todos ellos sigue abierta. Conviene reunir funciones en pocos habitantes.

### Mapas conceptuales guardados

- [Primera propuesta de Bītu](mapas/isla-bitu-propuesta-1.png): isla más compacta y accidentada.
- [Segunda propuesta de Bītu](mapas/isla-bitu-concepto.png): bahía amplia, terreno más abierto y silueta alargada.

Ambos muestran instalaciones dispersas, ruinas, camino inicial y un lugar provisional para la granja. **No se ha elegido un mapa definitivo.** Sus ilustraciones orientan la distribución; el juego será pixel art. La granja dibujada debe entenderse como parte del hogar del jugador, cuya ubicación todavía no está fijada.

## 6. Personajes

### Reparto funcional indicado por el usuario

| Personaje | Función establecida | Servicios adicionales propuestos |
|---|---|---|
| Comerciante | Vender recursos y gestionar mejoras por concretar. | Suministros, intercambios, encargos y mejoras de inventario o almacenamiento. |
| Maestro alquimista/herboristero | Alquimia y recolección de plantas para ella. | Identificar plantas, enseñar recetas y mejorar utensilios. |
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
- **Carácter:** cálida, práctica y contenta con su vida. Ayuda por amabilidad.
- **Recibimiento:** puede sorprenderle tu llegada, manteniendo un trato amable.

«Guerrera» describe su presencia y carácter; no confirma pasado militar, armadura, armas ni papel de combate. No necesita un problema propio o una misión personal para justificar su ayuda. La falta de suministros y el proyecto de reparar un barco propio no son historias acordadas.

**Pendiente:** especie, edad, ropa, resto del aspecto y diálogos. Los 30–40 años, botas, ropa de trabajo y cabello recogido fueron sugerencias sin confirmar. Tampoco está establecido que te reconozca o conozca tu pasado.

### Otros personajes

Sus nombres, apariencia, personalidad e historias siguen pendientes. Los nombres propuestos anteriormente —Ena, Orun y Sila— no fueron elegidos.

## 7. Protagonista y hogar

### Personaje

- Protagonista **personalizable**, con nombre y aspecto elegidos por el jugador.
- La llegada misteriosa es el punto de partida común.
- Propuesta para empezar: pocas opciones de piel, pelo y ropa, ampliables después. Especies, opciones exactas y amplitud del editor pendientes.

### Casa y granja

Obtienes una **casa abandonada con un terreno descuidado**, que puedes reparar y transformar poco a poco. Allí vivía el antiguo maestro granjero. El jugador puede llegar a ser **maestro granjero** algún día.

**Flavia o el comerciante** pueden presentarte la casa y contar que hace tiempo vivía allí un antiguo maestro, sin revelar de entrada su especialidad. El comerciante puede estar de camino; no se ha elegido quién lo hace, el recorrido ni el diálogo.

Ubicación exacta, acceso a la propiedad, reparaciones, ampliaciones y exposición de colecciones pendientes. Una isla privada cercana fue una idea anterior, no una ubicación elegida.

## 8. Profesiones y recursos

### Libertad y progreso

**Confirmado:** puedes desarrollar todas las profesiones con el mismo personaje o dedicarte solo a las que quieras. No son excluyentes.

**Base provisional que encaja al usuario:** experiencia al practicar y nuevas posibilidades al progresar; materiales y monedas para mejorar herramientas. Niveles, desbloqueos y requisitos de maestría se decidirán después.

### Minería y herrería

- Explorar minas y galerías con vetas, criaturas y secretos al profundizar.
- Encontrar rocas y vetas también al aire libre.
- Existen **rocas básicas**.
- También hay **vetas preciosas y muy valiosas en la superficie de islas difíciles y peligrosas**.

El valor depende del lugar y sus peligros, además de la profundidad. Minerales, extracción, requisitos de pico y reaparición de vetas pendientes. Fundición y fabricación de equipo son propuestas vinculadas a herrería.

### Pesca y cocina

Pescar y coleccionar peces, incluidos hallazgos especiales en distintas aguas y momentos del día. El maestro reúne pesca y cocina.

Mecánica de pesca, cebos, recetas y efectos de comida pendientes. Cocinar capturas y alimentos de la granja es una conexión propuesta. Se busca que la comida sea útil sin exigir alimentación constante.

### Agricultura

Cultivar alimentos, por ejemplo **patatas y tomates**, en la granja del jugador. Progresar hasta la maestría es un objetivo posible.

Semillas, cuidados, tiempos de crecimiento, venta y usos culinarios están por definir. No hay un maestro agricultor vivo adicional confirmado ni un instructor elegido.

### Herboristería y alquimia

**Herboristería:** recolectar plantas silvestres para alquimia durante la exploración. Es distinta de plantar alimentos en la granja; el herboristero no es el maestro de agricultura.

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

Beneficios opcionales de comida son una propuesta. Duración del ciclo, rutinas de personajes, automatización y progreso mientras no juegas siguen pendientes. No se ha elegido usar la hora real.

## 12. Coleccionables premium y ultraexclusivos

### Lo que quiere el usuario

Coleccionar rarezas, variantes visuales especiales y piezas exclusivas o **ultraexclusivas**, con la emoción de poseer algo excepcional. Esto forma parte central de la experiencia.

«Premium» describe el carácter especial de los objetos; no se ha acordado monetización. El juego es individual. La rareza puede hacer que pocos jugadores encuentren una pieza en sus partidas, sin fijar cupos globales o un porcentaje exacto de propietarios.

### Propuestas de diseño

- Minerales, gemas, peces, plantas, recetas, trofeos o piezas decorativas.
- Variantes brillantes, doradas u otras apariencias especiales.
- Hallazgos por azar, exploración, retos y colecciones completadas.
- Piezas ultraexclusivas como objetivos de largo plazo, sin exigirlas para progresar.
- Álbum, museo o exposición para conservar y mostrar piezas. Uso equipable y exhibición no están decididos.
- Proteger piezas frente a ventas accidentales. La protección frente a la derrota sí está confirmada.

No hay tabla de rarezas definitiva, probabilidades, eventos temporales o cantidades limitadas. «Único» todavía no determina si un objeto tiene una sola copia por partida.

### Nota de probabilidades para el futuro equilibrio

Probabilidad de conseguir al menos una pieza tras `n` intentos independientes, con probabilidad constante `p` por intento: `1 − (1 − p)^n`.

- **0,1 % por intento:** una posibilidad entre 1.000. Tras 1.000 intentos, aproximadamente **63,2 %** de conseguir al menos una.
- **0,000001 % por intento:** una posibilidad entre **100.000.000**.

Estas cifras fueron ejemplos explicativos, no probabilidades elegidas. Ajustar rareza considerando frecuencia y duración de intentos. Probabilidad por intento y porcentaje de jugadores propietarios son cosas distintas; no hay estadísticas globales acordadas.

## 13. Primera versión: orientación, no encargo de programación

El usuario dijo que el siguiente esquema encaja, pero lo considera denso y quiere seguir diseñando antes de programar:

1. Ruinas → camino inicial → encuentro con Flavia.
2. Paso al interior de Bītu y presentación de los cinco personajes.
3. Primeras acciones de minería, pesca y recolección de plantas.
4. Venta, una mejora básica de herramienta, combate con un enemigo sencillo y una poción de curación.
5. Materiales y construcción del primer barco como cierre del tramo.
6. Pequeña colección y guardado de progreso.

La navegación, primera expedición, granja desarrollada, cocina completa, jefes y resto del archipiélago requieren revisar el alcance antes de incluirlos. Las propuestas anteriores de un jefe inicial o un destino cercano no son requisitos cerrados de esta versión.

Guardado local es una propuesta inicial; plataforma y sistema definitivo de guardado pendientes. **No se ha elegido motor, tecnología ni plataforma de ejecución.** El proyecto todavía contiene documentación y mapas, sin implementación.

## 14. Pendientes para futuras conversaciones

No convertir esta lista en un cuestionario completo. Elegir un tema útil cada vez y conservar las respuestas anteriores.

- Recorrido inicial, diálogo con Flavia, apertura del paso y presentación de la casa.
- Resto del aspecto de Flavia y personalidad de los demás personajes.
- Distribución definitiva de Bītu, ubicación del hogar y selección de mapa.
- Primeros materiales, economía, almacenamiento y mejoras.
- Mecánicas de pesca, extracción, cultivos, recetas y maestrías.
- Esquive, armas y enemigos; estas preguntas se aplazaron a petición del usuario.
- Duración del día, efectos nocturnos y grado de automatización.
- Controles y peligros del barco; primera isla visitable.
- Categorías y forma de mostrar colecciones; requisitos y probabilidades de piezas especiales.
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
