# Dragón jugable de Bītu

El protagonista usa fotogramas completos con su cuerpo y, en las acciones de trabajo, herramienta y agarre dibujados juntos. Las siete direcciones de marcha rechazadas, la carrera y los golpes se revisan mediante nuevas hojas; la marcha NORTE, pesca, recolección y garras conservan sus imágenes aceptadas. El montaje de piezas articuladas fue rechazado y retirado.

## Organización

| Carpeta o registro | Uso |
|---|---|
| `sprites/conservados/` | Ocho PNG originales: reposo, marcha NORTE, sprint NORTE, arrodillado, levantar, pesca, pesca norte y zarpazo. Sus bytes se conservan. |
| `fuentes/fotogramas/` | 48 dibujos individuales de marcha/carrera y diez hojas de trabajo, conservados sin retoque. |
| `registro-fotogramas.json` | Recortes de figuras enteras, DPI uniforme, anclas, palmas y contacto de metal. |
| `sprites/fotogramas/` | Hojas nuevas de figuras completas para los ciclos corregidos. Cada fotograma tiene su apoyo y escala registrados. |
| `referencias/riego-vistas-fuente.png` | Propuesta única de riego, trasladada desde la entrega de equipo inicial; sin animación integrada. |
| `referencias/anteriores/` | Fuentes únicas anteriores de minería/tala, fuera de ejecución. |
| `dragon-jugable.json` | Catálogo que consulta el juego; sus `frames`, `animations` y contactos son el inventario activo. |
| `registro-fuentes.json` | Registro histórico de las diez fuentes originales, con rutas actualizadas y recolección preservada. |

Las copias de ejecución están bajo `prueba/assets/personajes/dragon/`, con las mismas rutas relativas y bytes de los PNG activos. Los originales anteriores y propuestas no se copian al juego. Las capturas están en `prueba/capturas/`; son evidencia del motor y no sprites. [Auditoría de todas las imágenes y referencias](../../../docs/auditoria-archivos-dragon.md).

## Reglas de animación

Mantener anatomía, perspectiva y anclaje al suelo coherentes en las ocho direcciones. Alternar apoyo de un pie y otro, con brazos contrarios; usar dibujos propios de carrera. No estirar extremidades ni animar girando recortes. Los ciclos corregidos usan seis fases; NORTE conserva sus cuatro originales. Los nuevos atlas tienen celdas192×192, ancla(96,168), cuerpo de referencia80px y escala final1. El margen permite levantar y bajar la herramienta sin recortarla ni reducir el cuerpo. NE/E/SE reflejan la figura completa una sola vez por dirección; SUR nunca refleja el cuerpo entre pasos. El motor selecciona un fotograma completo; las transformaciones de escala son uniformes para la presentación80/72px, no deformaciones anatómicas.

La herramienta es un solo pico–hacha: preparación, carga, golpe, seguimiento y recuperación propios de cada actividad. La punta minera actúa sobre la mena y el filo ancho sobre el árbol; el extremo opuesto se conserva visible. Ambos comparten los cinco golpes y el reloj de trabajo del juego. Los contactos se registran sobre el metal visible, sin girar el instrumento por separado de las manos.

Pesca y recolección mantienen los dibujos y tiempos aceptados. Las garras conservan su secuencia y un único impacto por ataque. Encontrar una propuesta de riego no significa que esa animación esté implementada. La revisión visual debe comprobar ciclos, transiciones, proporciones y contacto en el juego; los tests no otorgan aprobación artística automática.

## Revisar

`?vista=dragon` o `prueba/scenes/dragon.tscn`:1reposo,2marcha,3minería,4tala,5palín,6parar/andar,7sprint,8pesca,9zarpazo. Espacio activa cámara lenta. `?vista=personajes` compara con los seis NPC.

El registrador antiguo está archivado en `referencias/anteriores/register_dragon_antes.py`. Sirve para reproducir las medidas históricas y solo escribe en `work/`; no modifica el catálogo activo ni la prueba. El código actual de registro está en `prueba/tools/register_dragon.py`.
