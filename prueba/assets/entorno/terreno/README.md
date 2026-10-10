# Suelos de ejecución

Copias intactas de las fuentes de `assets/entorno/terreno/` y `assets/entorno/arena/`. `suelos.json` registra seis regiones: dos hierbas, dos tierras y dos arenas. Godot carga dos texturas compartidas y las dibuja con UV dentro de rombos 64 × 32. La geometría ajusta la superficie al suelo físico; no cambia PNG, colisiones o tamaño de los personajes. El terreno estático no solicita redibujado por fotograma.

La mezcla de materiales tiene bordes de casilla; transiciones suaves/autotiles quedan pendientes. Agua y orillas conservan su atlas previo.
