# Auditoría de archivos del dragón

Revisión del 11 de octubre de 2026 para sustituir el montaje articulado rechazado y ordenar todo el material del protagonista. Se revisaron los 226 PNG trackeados al iniciar el trabajo, sus enlaces y registros. Esta cifra incluye entorno, NPC y capturas; no es el número de sprites del dragón.

## Inventario de partida

Once PNG del dragón en `assets/personajes/dragon/`, con once copias necesarias e idénticas byte por byte en `prueba/assets/personajes/dragon/`. Son atlas fuente grandes: el catálogo elige regiones y transformaciones, por lo que 216 nombres de pose no equivalen a 216 dibujos únicos ni a 216 fotogramas nuevos.

| PNG fuente | Lienzo | Bytes | Estado al comenzar |
|---|---:|---:|---|
| `arrodillado.png` | 1254 × 1254 | 1,195,334 | Preservar: recolección aceptada; 8 regiones activas. |
| `levantar.png` | 1254 × 1254 | 841,595 | Preservar: recolección aceptada; 8 regiones activas. |
| `marcha.png` | 887 × 1774 | 1,703,949 | Preservar sus cuatro dibujos de marcha NORTE; las otras siete direcciones requieren sustitución. |
| `mineria.png` | 887 × 1774 | 1,845,935 | Fuente anterior: 32 nombres registrados, visual reemplazado por rig defectuoso; revisar antes de retirar del runtime. |
| `pesca-norte.png` | 887 × 1774 | 1,524,927 | Preservar: solo recogida NORTE activa; el resto de la hoja es material único sin uso. |
| `pesca.png` | 887 × 1774 | 1,482,855 | Preservar: 23 registros activos, pesca aceptada. |
| `piezas-articuladas.png` | 1536 × 1024 | 1,660,187 | Rig rechazado: 30 recortes en cinco vistas, distinto registro de las poses completas. Retirar al sustituir su renderizador. |
| `reposo.png` | 887 × 1774 | 545,435 | Fuente de reposo registrada en cinco vistas; las otras tres son reflejos completos. |
| `sprint.png` | 887 × 1774 | 1,774,246 | Fuente anterior: 32 nombres registrados; requiere revisar carrera y continuidad. |
| `tala.png` | 887 × 1774 | 1,826,179 | Fuente anterior: 32 nombres registrados, visual reemplazado por rig defectuoso; revisar antes de retirar del runtime. |
| `zarpazo.png` | 887 × 1774 | 1,428,155 | Preservar: 32 registros de ataque; no se solicitó rehacer esta acción. |

`dragon-jugable.json` registra reposo, marcha, sprint, minería, tala, recolección, pesca y garras; `registro-fuentes.json` permite reproducir el registro original. El rig añadido tenía otro atlas y `articulaciones.json`. Es necesario comprobar cuál de los dos renderizadores está visible; verificar las poses antiguas ocultas no valida el dibujo del rig.

Las hojas anteriores tienen fases repetidas y algunas perspectivas incoherentes. Las vistas derechas utilizan reflejos completos de sus parejas izquierdas; la marcha frontal incluso reflejaba media zancada del cuerpo entero. Compartir altura de cresta no garantiza que brazos, torso y piernas conserven sus proporciones. No debe repetirse este método para sustituir dibujos nuevos.

## Fuente dispersa localizada y conservada

La fuente `assets/entregas/completar-bitu/referencias/riego-vistas-fuente.png` se trasladó a [`assets/personajes/dragon/referencias/riego-vistas-fuente.png`](../assets/personajes/dragon/referencias/riego-vistas-fuente.png), sin editar sus píxeles ni bytes. Contiene 32 poses propuestas; lienzo1201×1309,1.216.612bytes, SHA-256`6e2099b6335521cbdd38c9f05dc249dff37931a2c21289ef13f106039aa01657`.

Se actualizaron la galería de completar Bītu, el registro relativo de sus diez fuentes y la auditoría del lote. Su propio registro y explicación están ahora en [referencias del dragón](../assets/personajes/dragon/referencias/README.md). Su anatomía es más compacta: se conserva como material de preparación, sin afirmar que esté registrado ni integrado. Las parcelas siguen usando la interacción de riego existente.

`equipo-inicial-fuente.png` contiene regadera, punto de agua y mochila; `kit-cocina-fuente.png` contiene equipo, no al dragón. Las demás láminas de casas, entorno, barcos, NPC y mapas se mantuvieron en sus carpetas. No se encontró otra fuente suelta del dragón en esos PNG.

## Referencia obsoleta incrustada

El visor independiente de agua/casa todavía contenía un PNG de un dragón anterior en base64 y su registrador apuntaba a la carpeta eliminada `dragon-avatar/`. El PNG antiguo incrustado era1536×1024 y2.447.457bytes; ya no era un archivo fuente vigente.

`assets/entorno/agua-casa/registrar.py` ahora lee el catálogo actual del dragón, su reposo SUR y su altura registrada. Se regeneraron solo el registro JSON y el visor para sustituir esa referencia; los30PNG de agua/casa permanecieron idénticos. No se rasterizó de nuevo el terreno ni la casa. El visor de seis NPC y su preparador también dejaron de anunciar un total histórico de160fotogramas; se retiró una rama de generación de dragón que ya no tenía personaje en el catálogo de NPC.

## Organización aplicada y comprobaciones

- `assets/personajes/dragon/`: catálogo y registros del protagonista. Los diez PNG fuente originales se trasladaron manteniendo sus bytes.
- `assets/personajes/dragon/sprites/conservados/`: ocho fuentes aceptadas y sus copias runtime, incluidas marcha y sprint NORTE.
- `assets/personajes/dragon/sprites/fotogramas/`: hojas nuevas de fotogramas completos, separadas de las referencias.
- `assets/personajes/dragon/referencias/`: propuesta de riego sin ejecución; `anteriores/` conserva minería/tala originales y registrador histórico, sin sus copias runtime.
- `prueba/assets/personajes/dragon/`: copias necesarias para Godot, comprobadas contra sus fuentes; no tratarlas como duplicados sobrantes.
- `prueba/capturas/`: evidencia del resultado en el motor. Las imágenes de escenas que contienen al protagonista permanecen aquí; no son sprites ni deben entrar en su catálogo.

Retirar un atlas anterior del runtime exige comprobar todas sus regiones: `marcha.png` sigue siendo necesaria mientras conserve NORTE y `pesca-norte.png` aporta una sola región válida, aunque el resto no se utilice. Una parte sin uso no permite borrar una hoja entera. Solo se elimina material obsoleto verificado; el historial de Git permanece intacto.

La validación final debe comprobar fuentes/copia, rutas existentes, conservación de NORTE/pesca/recolección, ciclos y transiciones visibles en ocho direcciones y contactos de ambos extremos de la herramienta. Los tests técnicos no sustituyen la revisión visual de las proporciones y los apoyos.

El atlas de30recortes `piezas-articuladas.png`, ambos `articulaciones.json`, sus copias/importaciones y el renderizador/UID/registrador se retiraron después de comprobar que el jugador y las pruebas nuevas ya no los referencian. El registro antiguo de fuentes se conserva como documentación reproducible, con rutas actualizadas; su registrador solo escribe en `work/`. La documentación histórica de apoyos indica claramente que ese método fue rechazado.

Se comprobaron enlaces de las galerías y huellas de las fuentes trasladadas. El visor independiente de agua/casa abre en Chromium sin errores y mantiene24piezas de agua; su geometría y fuentes permanecen idénticas. Las hojas nuevas se evalúan como candidatas antes de publicar: el inventario histórico de esta auditoría no supone aprobación de su acabado.

## Registro de la entrega por fotogramas

- Corregidos: siete vistas de marcha y siete de carrera, seis fases cada una;16ciclos de minería/tala con seis fases.30atlas nuevos activos, celdas192×192 y ancla(96,168).
- Fuentes nuevas:48PNG individuales de marcha/carrera y diez hojas completas de trabajo. Las vistas derechas se reflejan completas al importar, sin girar miembros. Fuentes sin editar en `fuentes/fotogramas/`; registro explícito en `registro-fotogramas.json`.
- Conservados: ocho PNG originales,80poses protegidas con huella de píxeles y transformaciones, además de16registros de reposo/sin equipo.
- Trasladados: diez fuentes originales (ocho activas y dos anteriores), la referencia única de riego y el registrador histórico. Copias activas de Godot sincronizadas por bytes.
- Retirados: atlas y registro del rig rechazado, renderizador/UID y registrador de piezas; copias runtime de minería/tala anteriores y las importaciones de rutas retiradas. Material fuente único de trabajo anterior conservado en referencias.
- Catálogo:396nombres =96registros conservados +180fotogramas registrados +120alias de compatibilidad. No equivalen a396dibujos nuevos: hay reflejos completos y cierres de recuperación sobre preparación cuando la última figura fuente toca el borde.

Las primeras candidatos de carrera con proporciones de cabeza/torso incorrectas o una pierna repetida no se incorporaron. La revisión en WebGL detectó y corrigió el desfase de un píxel del contorno de arranque en NW/NE; altura numérica estable por sí sola no bastaba.

Límites pendientes: acabado artístico sujeto a revisión del usuario, animación de riego sin integrar, y ocultación del personaje/herramienta cuando trabaja detrás de la copa de un árbol. Se conserva el orden de profundidad existente; esta revisión no añade un sistema de transparencia de copas. Sin guardado ni nuevas actividades/sistemas.

## Validación y bytes antes de publicar

Once pruebas nativas de Godot4.6.3 superadas: inventario, herramienta, recursos, entorno, escena/extracción, dragón, ciclos completos y conservación, acciones, escala, habitantes e interior. Auditoría anatómica técnica y cuatro suites Chromium/WebGL superadas: dragón ocho direcciones×ocho modos y seis muestras de marcha/carrera, arranque/parada e impactos reales, extracción por clic y pesca/zarpazo con captura/botín/cancelación. Capturas y vídeos actuales del canvas revisados. Las fuentes de NPC/entorno/objetos/mapas siguen idénticas al remoto integrado.

Descarga regenerada:31.268.916bytes; SHA-256`1f9b2240d2f12aaff7a04796acb6a6e4a8cda2d50c64cb11452dd58136ad6702`; CRC correcto y PCK idéntico al exportado. Es el archivo mayor de esta entrega. Límite GitHub por archivo104.857.600bytes; todos los archivos preparados quedan por debajo. Las fuentes grandes se conservan en GitHub, fuera del paquete del juego; no hace falta dividir la descarga.

Remoto revisado e integrado hasta `0f60ace784e2bab8e6fa094af085b8747cbb9dc2`: interior de casa, formas de zonas y registro de conversación conservados. Publicación ordinaria por avance del historial, sin `--force`.
