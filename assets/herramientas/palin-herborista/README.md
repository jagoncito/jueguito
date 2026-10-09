# Palín de herborista — diseño exótico integrado

![Diseño pixel art del palín](palin-herborista-exotico.png)

Diseño generado el **8 de octubre de 2026** por petición explícita del usuario. Pala de mano para herboristería: hoja cóncava vegetal de color verde azulado, borde bronce, nervaduras sutiles, pequeño detalle ámbar y mango de madera retorcida con correas verdes. Paleta y ornamentos son una propuesta visual; no confirman materiales, rareza, poderes ni requisitos.

Integrado en la prueba por petición explícita del usuario. Un clic izquierdo sobre una flor cercana guarda el pico–hacha y equipa el palín: el personaje baja a una rodilla, hace paladas junto a la raíz, extrae la planta y se levanta. El botín aparece al extraer a los **1,5 segundos** y el control vuelve a los **2 segundos**. Animación y tiempos provisionales; se añaden ocho vistas direccionales para el dragón, sin mejoras jugables todavía.

El PNG original **RGBA de 1254 × 1254** se conserva sin modificar. Se presenta con escala **1/32**, equivalente a un lienzo de **39,1875 × 39,1875 píxeles** antes de girarlo, junto al humano de 80 píxeles. Filtrado nearest. No es un sprite nativo de 64 × 64 ni una hoja de fotogramas; esta es la referencia original. La integración actual del dragón utiliza poses completas y el atlas direccional descrito abajo.

`palin-herborista.tscn` compone el PNG con el origen en el **agarre (440,820)** del original; posición del Sprite2D (5,84375; −6,03125), escala 0,03125. El punto de contacto de la hoja se registra en **(1170,155)** del original. `palin.gd` anima el giro, emite `impact("recolectar")` una vez al extraer y `work_finished` al terminar. El personaje orienta el montaje hacia la tierra y coordina mano, postura y recuperación.

Metadatos: [palin-herborista.json](palin-herborista.json). La copia del proyecto está en `prueba/assets/herramientas/palin-herborista/`. Abrir `prueba/project.godot` y usar **F5**; acercarse a la flor y hacer clic sobre ella. Imagen original y copia del proyecto idénticas.

**Ocho vistas para el dragón:** `palin-vistas.png`, transparente de 1536 × 1024, orden S, SW, W, NW / N, NE, E, SE. Hoja frontal, cara posterior, perfiles estrechos y diagonales con volumen propio. `palin-vistas.json` registra región, agarre y punta por vista. `set_direction()` selecciona la perspectiva y `tip_offset()` registra el contacto. El personaje coloca el mango en la palma dibujada y presenta sus dedos por encima; las vistas traseras quedan ocluidas por el torso. Se mantienen extracción a 1,5 s, recuperación a 2 s y ajuste de apoyo sin ampliar alcance ni mover la posición física.

![Captura real de la recolección arrodillada](../../../prueba/capturas/dragon-recolectando.png)

Las pruebas de la escena verifican agarre, contacto, orientación desde ambos lados, postura, ausencia de botín duplicado y recuperación. La subida de esta entrega fue solicitada expresamente; no autoriza futuras subidas automáticas.
