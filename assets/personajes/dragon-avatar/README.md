# Dragón — protagonista bípedo

## Versión jugable del 9 de octubre de 2026

El usuario elige este dragón como **protagonista**, pide cuerpo bípedo, herramientas y animaciones dentro del juego. Sustituye al protagonista humano anterior. Nombre, especie concreta, historia y personalización siguen abiertos.

**La cara utiliza los mismos píxeles de `dragon-idle.png`, sin regenerarla.** El PNG original permanece intacto. Un contorno con UV registradas separa cráneo, aletas y mandíbula del cuerpo cuadrúpedo; ojos ámbar, hocico claro y sonrisa no se redibujan. Mirar a la izquierda refleja la pieza. Caminar hacia arriba utiliza una pieza nueva de espalda, con la cara oculta.

| Recurso | Uso |
|---|---|
| `dragon-idle.png` | Cabeza frontal y referencia original intacta, 1254 × 1254. |
| `dragon-cuerpo.png` | Atlas transparente de 1254 × 1254: torso, brazo, antebrazo, mano, muslo, pierna/pie, cola y ala. |
| `dragon-espalda.png` | Atlas transparente de 1774 × 887: cabeza y torso de espalda. |
| `dragon-jugable.json` | Medidas de presentación, regiones, agarres y animaciones. |

Piel azul grisácea, marcas ocre, vientre y garras beige, cresta y membranas naranja dorado. Brazos y manos capaces de agarrar; dos piernas sostienen al personaje. Cola y alas pequeñas acompañan sus movimientos.

- Altura jugable: **unos 84 px**, próxima a los 80 acordados; cabeza de unos 53 × 40 px.
- Fotograma orientativo **128 × 128**, apoyo `(0,0)` y colisión circular de radio 7 en `(0,-3)`.
- Los PNG grandes se conservan: **no son sprites nativos de 128 × 128**. Presentación con AtlasTexture, contorno UV y vecino más cercano.
- Reposo con respiración, alas y cola; caminar con pico–hacha; orientaciones laterales reflejadas y espalda; minar/talar con dos agarres; arrodillarse, usar palín y levantarse.
- **Animación por piezas articuladas en Godot**, no hoja completa de fotogramas ni ocho vistas dibujadas. Pesca, riego con regadera, ataque, daño y esquive pendientes de sus futuras acciones.

Rig en [`dragon_visual.gd`](../../../prueba/scripts/dragon_visual.gd), controlado por [`player.gd`](../../../prueba/scripts/player.gd). Copias idénticas de los tres PNG en `prueba/assets/personajes/dragon-avatar/` para un proyecto independiente.

Importa `prueba/project.godot` en **Godot 4.6.3** y pulsa **F5** para jugar. Abre `prueba/scenes/dragon.tscn` y pulsa **F6** para seis animaciones ampliadas ×3. En la exportación web añade `?vista=dragon` a la URL. [Captura de animaciones](../../../prueba/capturas/dragon-animaciones.png) · [Prueba de navegador](../../../prueba/descargas/bitu-navegador.zip).

El 9 de octubre el usuario solicita subir esta entrega a GitHub. Las futuras subidas requieren nueva petición.

## Referencia original del 8 de octubre

![Dragón basado en el avatar del usuario](dragon-idle.png)

Creado el **8 de octubre de 2026**, por petición del usuario de trasladar su avatar a pixel art, conservando especialmente **el tono de piel, la cara y la expresión**, y subir el resultado a GitHub.

## Apariencia

- Piel azul grisácea, escamas y pequeñas marcas ocre.
- Hocico corto y redondeado, de gris beige cálido, con dos pequeñas fosas nasales y sonrisa suave.
- Ojos grandes de iris ámbar dorado, pupilas oscuras, reflejos claros y párpados expresivos; cabeza ligeramente inclinada.
- Aletas laterales, cresta y membranas de naranja dorado.
- Cuerpo compacto de dragón joven, cuatro patas cortas, alas pequeñas y cola curvada.

La cara y la paleta se adaptan del avatar aportado. Esta pose cuadrúpeda se conserva como referencia original; el cuerpo bípedo se compone en el motor según la petición posterior. Nombre, especie concreta e historia pendientes; su papel de protagonista ya está elegido.

## Archivo y escala

| Medida | Estado |
|---|---|
| PNG original | **1254 × 1254 píxeles**, RGBA con transparencia. |
| Pose | Una pose quieta de cuerpo entero, vista ligeramente elevada en tres cuartos. |
| Referencia de presentación | Silueta de **80 píxeles de alto**, dentro de un fotograma de **128 × 128**. |
| Escala orientativa del original | **0,072072**; silueta principal aproximada de **75 × 80**. |
| Lienzo original a esa escala | Aproximadamente **90,38 × 90,38**. |
| Filtrado recomendado | Vecino más cercano (*nearest*). |

El original generado se conserva **sin recortar ni redimensionar**. Tiene un acabado pixel art detallado, pero **no es un sprite nativo de 128 × 128 ni una ampliación exacta de una cuadrícula de esa medida**. Reducirlo puede perder detalle de ojos y escamas; habrá que comprobar su legibilidad a escala jugable y adaptar los píxeles para la producción definitiva.

La altura visible se estima con alfa ≥ 8 para excluir residuos casi transparentes: región (182,96,1040,1110) del original. Medidas, huella SHA-256 y estado en [dragon-idle.json](dragon-idle.json).

## Alcance

La pose original es estática; las piezas posteriores sí están integradas en la granja. El diseño vigente del protagonista dragón está en [DISENO.md](../../../DISENO.md). La elección posterior sustituye al humano anterior.

La petición autoriza generar este recurso y publicar esta entrega. La generación general y las futuras subidas mantienen sus límites anteriores.
