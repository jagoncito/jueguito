# Astillero de Flavia — propuestas visuales

Entrega solicitada el 10 de octubre de 2026. Fuentes pixel art revisadas, con publicación solicitada posteriormente por el usuario. Pendientes de integración.

- [Exterior](referencias/astillero-exterior-fuente.png): edificio de carpintería naval, cobertizo, muelle, casco sobre soportes y piezas separadas de suelo, muelle, postes, cuerdas, barril, caja, tablones y caballetes.
- [Interior](referencias/astillero-interior-fuente.png): vista abierta sin techo, bancos, almacén de madera, planos, herramientas y estructura de barco, con accesorios aislados.

La herrería permanente del maestro sigue lejos, en las montañas del noroeste. El maestro está de paso con Flavia en el astillero al comienzo. Las propuestas de distribución, accesorios y arquitectura no fijan nuevos sistemas ni costes.

Estas imágenes de 1536 × 1024 son fuentes RGBA grandes. No son atlas nativos: los módulos aún requieren recorte, comprobación de transparencia y alineación, escala uniforme, anclas, colisiones y prueba de uniones. El suelo de referencia es 64 × 32 y la estatura adulta 80 px; las fuentes no deben usarse a tamaño completo en el mundo.

Organización recomendada al registrar: módulos repetidos de suelo/muelle en atlas compartido; accesorios en el mismo atlas cuando convenga; edificio, techo y casco como piezas únicas con capas necesarias para profundidad y visibilidad del interior. Evitar multiplicar texturas o nodos por cada detalle decorativo. La modularidad facilita reutilizar y editar, pero no garantiza por sí sola menos memoria o llamadas de dibujo.

## Rendimiento observado en el código

Existe caché del dragón y uso de AtlasTexture para agua. Los seis NPC usan ocho vistas cada uno. El terreno estático no solicita redibujado cada fotograma. Sin embargo, cada pose nueva del dragón recorta y limpia píxeles en ejecución, los cultivos en crecimiento solicitan redibujado continuo, y la carga por zonas todavía no existe. Falta medir tiempos de fotograma, picos al cambiar pose y memoria en equipos representativos.

Prioridad antes de ampliar Bītu: preprocesar las poses fuera de ejecución conservando contactos, agrupar recursos y cargar solo la zona activa. No se han aplicado cambios de rendimiento ni medido FPS por esta entrega artística.

## Revisión para publicar

Comprobadas las tres imágenes: PNG legibles de 1536 × 1024, sin archivos dañados. El mapa conserva la herrería al noroeste y el astillero en la bahía sureste. Exterior e interior comparten perspectiva y materiales; la coincidencia exacta de huella y escala deberá verificarse al registrarlos. Las láminas RGBA conservan halo y píxeles parcialmente transparentes; hay que limpiar esos márgenes antes de crear el atlas. El marcador humano del mapa es provisional y los rótulos deberán convertirse en UI.
