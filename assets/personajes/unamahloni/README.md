# Unamahloni — ocho orientaciones

Estudio de vistas solicitado por el usuario a partir de [la imagen base](../unamahloni-idle.png). El original se conserva intacto.

**Entrega completada:** las vistas con manos libres, 32 fases de marcha, poses de agarre y objetos intercambiables están en [equipamiento/](equipamiento/README.md) y en el [visor compartido](../objetos-equipables/vista-previa.html). Este estudio quieto y su visor original se conservan como referencia; los límites que siguen describen ese estudio anterior. La publicación del conjunto ha sido solicitada expresamente por el usuario.

## Archivos

- `unamahloni-orientaciones.png`: ocho figuras completas sobre fondo transparente, en dos filas de cuatro. PNG fuente de **1330 × 1182 píxeles**, conservado sin redimensionar.
- `unamahloni.json`: regiones medidas, orden de las orientaciones, huellas de los originales y escala para la vista previa.
- `vista-previa.html`: vista independiente con la imagen incorporada. Abrir directamente en un navegador; no necesita servidor ni conexión. Permite revisar las ocho figuras a unos 80 píxeles de alto, ampliar ×1/×2/×4 y mostrar una casilla de suelo de 64 × 32.

## Orden de las vistas

Las direcciones son relativas a la pantalla, no a los ejes del mundo.

| Fila | Columna 1 | Columna 2 | Columna 3 | Columna 4 |
|---|---|---|---|---|
| Superior | Frente (S) | Frente izquierda (SW) | Perfil izquierdo (W) | Espalda izquierda (NW) |
| Inferior | Espalda (N) | Espalda derecha (NE) | Perfil derecho (E) | Frente derecha (SE) |

## Continuidad con la base

Piel gris azulada, ojos y cabello ámbar, orejas humanas, camisa marfil, chaleco verde con motivos vegetales, pantalones y botas marrones, medallón botánico, cuaderno, bolsa de hierbas y frasco verde. Se mantiene el cuaderno bajo el brazo derecho, la bolsa en la cadera derecha y el frasco en la izquierda, teniendo en cuenta su ocultación al girar.

La cámara elevada y los mechones lisos buscan acercar la base al diseño vigente. El bordado de la espalda y los detalles antes ocultos son una ejecución propuesta, pendiente de revisión.

## Alcance

Una pose quieta por dirección. No incluye marcha ni animaciones de alquimia o recolección. La fuente grande **no es un atlas de fotogramas nativos de 128 × 128**, ni una ampliación exacta de esa cuadrícula. La vista previa presenta las figuras dentro de ese marco con filtrado por vecino más cercano; no modifica el PNG.

Proporciones, cámara, peinado, siluetas y registro requieren revisión antes de integrar en Godot. El diseño personal que sigue pendiente no queda confirmado por esta generación. Esta petición autoriza crear estas vistas; la entrega se guarda localmente y las futuras publicaciones requieren una petición expresa.
