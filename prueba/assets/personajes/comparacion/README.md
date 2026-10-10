# Personajes para comparar en la granja

Copias intactas de nueve PNG existentes en la raíz del repositorio. El catálogo
`personajes.json` registra SHA-256, ruta original, recortes, anclas y escala.
Se reproduce con `python prueba/tools/register_npcs.py` desde la raíz.

| Personaje | Altura de referencia | Movimiento de revisión |
|---|---:|---|
| Flavia | 80 px | Cuatro fases, 24 px de ida y vuelta |
| Unamahloni | 80 px | Cuatro fases, 24 px de ida y vuelta |
| Cocinero / pescador | 80 px | Giro entre ocho vistas estáticas |
| Minero / herrero | 64 px | Giro entre ocho vistas estáticas |
| Elfa del museo | 80 px | Giro entre ocho vistas estáticas |
| Comerciante | 84 px | Giro entre ocho vistas estáticas |

Cada muestra dura seis segundos y se repite, con pausas. Los caminantes usan
el primer dibujo de marcha al detenerse, sin cambiar de anatomía a otro atlas.
La escala es fija dentro de cada ciclo direccional y los pies usan su ancla.
Los otros cuatro no se desplazan: todavía no tienen dibujos de marcha.

Los personajes comparten el orden de profundidad del mundo y del protagonista.
F6 pausa/reanuda el grupo. Sus posiciones son provisionales para comparar:
no fijan ubicación narrativa, colisión, diálogo, comercio ni profesiones.
Sin imágenes nuevas; acabado visual pendiente de revisión del usuario.
