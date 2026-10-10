# Dragón nuevo de Bītu

Reinicio solicitado el 10 de octubre de 2026 después de comparar con los NPC.
El paquete `dragon-avatar/`, su original y sus registros se han retirado del árbol
vigente. El historial de Git se conserva. Ningún PNG del dragón anterior se usa.

Propuesta nueva: cuerpo esbelto gris azulado, vientre/hocico crema, ojos ámbar,
cresta y alas recogidas naranja óxido, contorno fino y detalles en píxeles. Cabeza
menor y piernas más largas para aproximarse al lenguaje de los habitantes.
**Sigue pendiente de aprobación visual.**

| Acción | Vistas / fases | Registros |
|---|---|---:|
| Reposo con pico–hacha y sin equipo | 8 cada uno | 16 |
| Caminar | 8 × 4 fases | 32 |
| Sprint | 8 × 4 fases propias | 32 |
| Minar | 8 × preparación, carga, impacto, recuperación | 32 |
| Talar | 8 × preparación, carga, impacto, recuperación | 32 |
| Arrodillarse y levantarse con palín | 8 cada uno | 16 |
| **Total** | **Ocho direcciones** | **160** |

Diez PNG fuente nuevos, copiados idénticos a `prueba/assets/personajes/dragon/`.
Son atlas grandes registrados con AtlasTexture, **no PNG nativos128×128**.
Las regiones contienen una sola figura completa. Se verifican dimensiones,
SHA-256, transparencias y ausencia de dibujos vecinos dentro de cada recorte.
Las celdas de ensayo sustituidas por impactos/elevaciones dedicados no se usan.
El renderizador no elimina píxeles ni estira partes del personaje.

Altura de cresta80px sobre el origen del suelo en reposo, marcha y sprint antes
del zoom. Una escala uniforme por ciclo de cuatro fases, sin reescalar al levantar
un pie. Las posturas de trabajo/recolección bajan mediante dibujos flexionados.
F7/F8 conservan la comparación reversible80/72px; colisión y velocidades intactas.

Revisión multiuso del 10 de octubre: las ocho poses de impacto de minería conservan
la hoja ancha opuesta del hacha. Se reconoce una única cabeza con ambos extremos,
sin sustituir el equipo al pasar de mena a árbol. Nuevos contactos de punta medidos;
la tala y las demás poses se conservan. Entrega autorizada para GitHub, revisión visual pendiente.

Pico arriba/filo abajo al llevarlo, incluido el perfil. El pico–hacha, brazos y
dedos están en el mismo dibujo. Minería registra la punta afilada; tala, el borde
ancho de la hoja opuesta. Partículas en el extremo registrado, cinco golpes y
tiempos previos. El palín reutiliza sus ocho proyecciones, registrado en las
palmas nuevas; no se añade pesca, riego animado ni combate.

Reproducir registro: `python prueba/tools/register_dragon.py`. Pillow/NumPy/SciPy
solo leen medidas; no editan PNG. `registro-fuentes.json` conserva puntos fuente
de contacto/apoyo y `dragon-jugable.json` las regiones y transformaciones.
`check_dragon_anatomy.py` mide los píxeles reales de cresta y informa la anchura
superior para revisión; una prueba matemática no aprueba el acabado artístico.

Revisión real: Godot `prueba/scenes/dragon.tscn`, o web `?vista=dragon`.
1 reposo, 2 marcha, 3 minería, 4 tala, 5 palín, 6 parar/andar, **7 sprint**.
Espacio: cámara lenta. `?vista=personajes` compara con los seis NPC sin cambiar
sus fuentes. Capturas/vídeos del motor en `prueba/capturas/`.
