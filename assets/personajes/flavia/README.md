# Flavia — primera referencia y estudio de movimiento

Creado el **9 de octubre de 2026** por petición del usuario de realizar a Flavia en pixel art con varias vistas, incluida la espalda, y las necesarias para el movimiento.

**Referencias acordadas:** Éowyn para el rostro y la presencia, Lagertha para el peinado y el porte, Faye para la constitución fuerte y el aspecto natural de artesana. La propuesta combina piel clara cálida, ojos verde grisáceo, cabello rubio dorado con trenzas, camisa marfil, chaleco azul petróleo, delantal corto y botas de cuero. Vestuario, rasgos nuevos y ejecución concreta pendientes de revisión visual del usuario.

## Ver las poses y el movimiento

Abre [vista-previa.html](vista-previa.html) en un navegador. Funciona localmente, sin servidor, instalación ni conexión a Internet. Muestra las ocho direcciones, permite cambiar entre reposo y marcha, pausar, avanzar fotograma a fotograma y cambiar la ampliación.

La referencia de presentación es una figura de **hasta 80 píxeles de alto en un fotograma de 128 × 128**, ampliable ×1, ×2 o ×4. Es una vista de revisión, no una integración en la granja ni una resolución nativa de las fuentes.

**Comprobación:** contenido renderizado en Chromium con las imágenes incluidas; verificadas las ocho vistas, cambio real de fase, reposo, pausa y ampliación, sin errores de JavaScript. Originales y copias contrastados por SHA-256.

## Archivos

| Archivo | Contenido | Dimensiones reales |
|---|---|---|
| [flavia-base.png](flavia-base.png) | Una pose base en tres cuartos. | 1254 × 1254. |
| [flavia-orientaciones.png](flavia-orientaciones.png) | Ocho vistas en reposo, cuatro columnas y dos filas. | 1774 × 887. |
| [flavia-marcha-1.png](flavia-marcha-1.png) | Cuatro poses por dirección: S, SW, W y NW, una dirección por fila. | 1254 × 1254. |
| [flavia-marcha-2.png](flavia-marcha-2.png) | Cuatro poses por dirección: N, NE, E y SE, una dirección por fila. | 1254 × 1254. |
| [flavia.json](flavia.json) | Medidas observadas, regiones de cada figura, escalas de vista previa y huellas de los originales. | Metadatos. |

Son **41 figuras en total**: una base, ocho vistas en reposo y 32 poses de marcha. Todas las fuentes son PNG RGBA con transparencia, conservadas intactas. Las dos láminas de marcha se revisaron para aumentar el espacio entre figuras.

Orden de las ocho vistas en reposo, de izquierda a derecha y arriba a abajo: S, SW, W, NW; N, NE, E, SE. S es frente hacia la parte inferior de la pantalla; N es espalda hacia la superior. Los perfiles y diagonales son relativos a la pantalla.

## Estado y límites

- **Las fuentes son grandes y no son sprites nativos de 128 × 128** ni una ampliación exacta de esa cuadrícula. La reducción de presentación pierde detalle y requiere una adaptación de píxel para producción.
- La vista previa conserva los PNG originales: muestra regiones de sus siluetas y usa una escala constante por dirección de marcha para revisar los pasos.
- Las fases, la anatomía, el registro, los pies y el balanceo de los brazos requieren refinamiento antes de considerar la marcha terminada.
- Hay pequeñas variaciones de perspectiva, proporción, ropa y accesorios entre dibujos; revisar especialmente broche, mallet/mazo y delantal al girar. No asumir que reflejar horizontalmente conserve los lados de los accesorios.
- La perspectiva elevada y la legibilidad deben comprobarse junto al escenario y al resto de personajes.
- No incluye animaciones de construcción, conversación u otras acciones. No está integrado en Godot.

La generación de estas vistas y la **subida de esta entrega a GitHub** fueron solicitadas expresamente por el usuario. Las futuras generaciones y publicaciones mantienen sus límites anteriores. Diseño vigente y acuerdos en [DISENO.md](../../../DISENO.md).
