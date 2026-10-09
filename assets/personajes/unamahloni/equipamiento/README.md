# Unamahloni — vistas, marcha y manos libres

Entrega completada el 9 de octubre de 2026 a partir de la base existente. Piel gris azulada, ojos ámbar, cabello cobrizo, orejas humanas, camisa marfil, chaleco botánico verde, pantalones y botas marrones. La bolsa de hierbas permanece como accesorio; el cuaderno y el frasco se montan como objetos separados. La base original y las ocho vistas anteriores se conservan.

[Abrir el visor compartido](../../objetos-equipables/vista-previa.html). Descarga el repositorio como ZIP y conserva sus carpetas; funciona sin servidor ni conexión.

## Recursos activos

| Fuente | Filas activas | Columnas |
|---|---|---|
| `unamahloni-manos-libres.png` | S, SW, W | Reposo, una mano, dos manos, comer/beber. |
| `unamahloni-manos-libres-nw.png` | NW, una fila | Las mismas cuatro poses. |
| `unamahloni-manos-libres-espalda.png` | N, NE, E, SE | Las mismas cuatro poses. |
| `unamahloni-marcha-1.png` | S, SW, W | Cuatro fases de paso. |
| `unamahloni-marcha-nw.png` | NW, una fila | Cuatro fases de paso. |
| `unamahloni-marcha-2.png` | N, NE, E, SE | Cuatro fases de paso. |

La cuarta fila de las dos primeras láminas frontales es una variante NE que **no se usa como NW**. Las tiras dedicadas corrigen la espalda izquierda sin reflejar la bolsa de hierbas. `equipamiento.json` selecciona únicamente los **64 fotogramas activos**: 32 poses y 32 fases de marcha.

Regiones medidas, pies comunes en (64,112), altura de hasta 80 píxeles, escala constante por dirección de marcha, palmas primaria/secundaria y orden de ocultación. El visor coloca el libro con dos manos, frasco o comida cerca de la boca y herramientas en el agarre, independientemente del cuerpo.

## Alcance

Las fuentes grandes no son atlas nativos de 128 × 128. Esta entrega completa las vistas, el ciclo visual de caminar y la preparación para equipar objetos; no añade ciclos completos de alquimia/recolección ni integra al NPC en la granja. Hay pequeñas variaciones de pelo, bordado y proporción propias de las fuentes generadas. La mano activa se documenta por pose visible, no como lateralidad anatómica definitiva.

Pruebas y convenciones en [el paquete compartido](../../objetos-equipables/README.md). La subida de esta entrega fue solicitada expresamente.
