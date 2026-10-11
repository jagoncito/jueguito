# Revisión de apoyos y extremos del pico–hacha

> **Revisión retirada.** El usuario rechazó el resultado visual de este montaje en el vídeo del11deoctubre. La sustitución usa fotogramas completos; el atlas de recortes, JSON, renderizador y registrador descritos aquí ya no se utilizan ni se distribuyen. Este documento conserva el diagnóstico y las pruebas históricas, que no demostraban continuidad anatómica. Consultar la [auditoría vigente](auditoria-archivos-dragon.md) y la [guía del dragón](../assets/personajes/dragon/README.md).

11 de octubre de 2026. Alcance confirmado por el usuario: corregir marcha SUR,
OESTE/ESTE y cuatro diagonales, sprint diagonal, minería y tala; preservar NORTE
al andar y las demás acciones aceptadas. Verificar y repetir antes de publicar.

La revisión anterior reflejaba el cuerpo completo a mitad de la marcha frontal.
Eso cambiaba de lado la cabeza y la silueta. Los perfiles y diagonales tampoco
mostraban una alternancia suficiente de pies. Ahora las vistas afectadas usan
un atlas de piezas limpias y articulaciones de dos segmentos: apoyo izquierdo,
transición, apoyo derecho y transición continua. El tronco conserva su centro;
las piernas alternan, con suela plana y brazos contrarios. La marcha sigue la
distancia recorrida; sprint diagonal aumenta la amplitud y elevación del pie.
NORTE al andar y los cuatro sprint cardinales siguen usando sus poses anteriores.

`piezas-articuladas.png` contiene cinco vistas y seis piezas por vista: torso,
brazo, antebrazo/mano, muslo, pierna y pie. Las vistas derechas se reflejan una
sola vez. El registro UV sigue cada componente transparente; los rectángulos
por sí solos incluían trozos de las figuras vecinas y se descartaron. El torso
cubre las uniones de las piernas; la profundidad de brazos/herramienta se adapta
a las vistas de espalda. Cabeza y torso no cambian de escala durante el ciclo.
Se registra el centro de la cresta respecto al reposo para evitar otro salto
lateral al arrancar. La flexión vertical de marcha es inferior a un píxel nativo.

Minería y tala usan el mismo PNG de hierro y la misma instancia de equipo. Se
orienta la cabeza combinada para que el extremo activo quede abajo: punta del
pico en minería, filo ancho en tala, con el extremo contrario arriba. Preparación,
carga, golpe a los 0,33 s, seguimiento y recuperación. Ambas manos siguen el
mango mediante hombros y codos; la herramienta sigue ese agarre. Los pies quedan
apoyados durante el trabajo y el torso acompaña. La corrección residual de la
postura es constante durante el ciclo: el cuerpo no salta al llegar al impacto.
El paso físico previo, las colisiones, los cinco golpes y el botín se conservan.

Los diez PNG anteriores y el catálogo de 216 nombres de pose no se modifican.
Las poses corregidas se representan con el rig en lugar del dibujo antiguo.
Reposo, flores/palín, pesca, zarpazo, NPC, terreno y novedades remotas se conservan.
Las fuentes generadas o montajes que fallaron la comprobación no se incorporan.
El acabado artístico requiere revisión del usuario dentro del juego; los tests
no equivalen a su aprobación ni demuestran que todas las animaciones del juego
sean definitivas.

Comprobaciones reproducibles:

- `python prueba/tools/register_dragon_parts.py`: lee el PNG, registra geometría
  UV y alinea la cresta; no edita imágenes. Copias fuente/runtime idénticas.
- `tests/dragon-gait-smoke.gd`: 64 muestras por ciclo, apoyos alternos, suela
  dibujada en el objetivo, pies alcanzables, altura/centro estables, agarre en
  todo el golpe y metal activo debajo del mango en las ocho vistas. También
  comprueba conservación de marcha NORTE, sprint cardinal y reposo.
- `tests/dragon-smoke.gd`, `scene-smoke.gd`, `actions-smoke.gd` y
  `character-scale-smoke.gd`: control, extracción, colisiones, cinco golpes,
  flores, pesca, zarpazo y escala. La prueba nueva mide el rig visible; las
  comprobaciones históricas del atlas por sí solas no verifican sus apoyos.
- Chromium/WebGL: `impact_browser_smoke.py` comprueba altura y centro de cresta
  reposo/arranque e impactos contra árbol/mena reales; `dragon_browser_smoke.py`
  reproduce ocho acciones en ocho vistas, cambia pies entre las cuatro muestras
  y renueva capturas/vídeo. `browser_smoke.py` y `actions_browser_smoke.py`
  comprueban extracciones, botín, pesca y zarpazo mediante clics reales.

Los controles y las capturas de la versión vigente están en la [guía de la prueba](prueba-visual.md); las imágenes publicadas se renuevan al sustituir las animaciones y no documentan este montaje retirado.

## Optimización conservadora y límites del acabado

El registro de articulaciones pasa de 2.872.360 a 466.825 bytes (83,75 % menos)
al compactar JSON; todos los datos y triángulos permanecen idénticos. El registro
se carga una vez y se comparte en lectura; cada actor conserva sus propios nodos,
apoyos y poses. La prueba de dos actores confirma esa independencia.

Godot vuelve a pasar la comprobación de marcha. Siete capturas fijas de ocho
vistas en Chromium/WebGL son idénticas píxel por píxel antes y después. Se
descartó agrupar triángulos porque modificaba algunos píxeles en el navegador.
No se ha medido una mejora de FPS. ZIP regenerado, CRC y PCK comprobados.

La estabilidad y los extremos activos de la herramienta están verificados;
el acabado artístico admite mejora: algunas uniones de miembros se perciben
segmentadas al ampliar y los golpes podrían transmitir más peso con el cuerpo.
Minería y tala comparten la trayectoria básica, orientando el extremo activo
correspondiente. Esta revisión no equivale a una aprobación visual definitiva.
