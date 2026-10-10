# Agua y casa del prototipo

Copias de los PNG aprobados en `assets/entorno/agua-casa/`, sin redibujar ni reescalar. Casa: 640 × 512, dibujo desde (-368,-496), ancla en casilla (18,11). Reserva técnica 10 × 7; solo los cimientos colisionan. `house.gd` divide el dibujo en columnas para ordenar la profundidad con el dragón.

Atlas: 256 × 192, celdas 64 × 32. Filas: superficie, profunda, somera, espuma, bordes NO/NE/SE/SO y esquinas arriba/derecha/abajo/izquierda. `terrain.gd` selecciona por vecinos y dibuja las orillas después del agua. No añade tierra en los límites del mapa. Agua estática; sin navegación ni interiores.

La integración local no se ha publicado nuevamente en GitHub.
