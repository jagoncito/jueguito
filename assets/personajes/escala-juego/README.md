# NPC a escala de juego

Los seis NPC comparten **ocho vistas de reposo sin instrumentos**: frente, espalda, dos perfiles y cuatro diagonales. **48 sprites nativos** de128×128, alpha binaria, apoyo(64,112), suelo64×32, escala1:1 y filtro nearest. Atlas comunes1024×1280; las celdas sobrantes quedan vacías.

| NPC | Altura de referencia | Sprites |
|---|---:|---:|
| Flavia | 80 px | 8 |
| Unamahloni | 80 px | 8 |
| Elfa | 80 px | 8 |
| Comerciante | 84 px | 8 |
| Cocinero | 80 px | 8 |
| Enano | 64 px | 8 |

Cada carpeta contiene PNG individuales, atlas, `animaciones.tres` y `personaje.tscn`. Sprite no centrado en(-64,-112) respecto al nodo de suelo. Las animaciones del recurso son poses de un fotograma, no ciclos de conversación. Unamahloni conserva una variación de muestreo de1px (79–80).

**Protagonista:** sus sprites y animaciones están en [dragon](../dragon/README.md), separados de este paquete de seis NPC. Los 48 registros de reposo de habitantes se conservan; el renderizador real del dragón se compara con ellos en `prueba/scenes/personajes.tscn`. El número y estado de sus fotogramas se documentan en su catálogo propio; no usar totales históricos de este paquete como medida del protagonista.

## Revisión

Abrir `prueba/scenes/personajes.tscn` en Godot4.6.3 y F6, o añadir `?vista=personajes` a la descarga web. **La escena muestra los seis NPC nativos y el protagonista mediante su renderizador real actualizado.** Flechas: vistas de todos; Espacio: marcha del dragón; V: poses del dragón; Z: zoom común1×/2×. La regla representa90px de puerta, sin imponer esa altura al protagonista.

`visor.html` es una comparación autónoma de los seis NPC. El protagonista se revisa en el motor para mostrar exactamente la versión jugable. Los seis NPC están integrados en posiciones provisionales de la partida, con colisión, giro hacia el jugador e interacción básica de prueba. Diálogos definitivos y servicios pendientes. [Capturas y explicación de escala](../../../docs/revision-personajes-en-juego.md).

## Fuentes y comprobación

`fuentes.json` selecciona únicamente las vistas vigentes desde `../referencias/`. `sprites.json` contiene regiones, transformaciones y SHA-256. Ejecutar `python assets/personajes/escala-juego/exportar.py` (Playwright y Chromium), seguido de `python assets/personajes/escala-juego/preparar_recursos.py`.

Se retiraron los sprites y paquetes adicionales de marcha, agarres, equipo y comida de NPC. Se conservan las fuentes necesarias y referencias de creación. Protagonista y herramientas mantienen sus cambios remotos. Comprobación de tamaño, alpha, SHA-256, atlas, ocho direcciones, prefabs y pruebas reales de Godot.

Publicación solicitada por el usuario para esta entrega concreta.
