# Continuidad del proyecto

- Lee `DISENO.md` antes de trabajar: contiene el diseño vigente y las preferencias del usuario.
- El diseño sigue en conversación. Tras expresar que quiere empezar a programar y pedir una prueba para ver el aspecto, el usuario dispone de un prototipo visual limitado. Mantén ese alcance: no convertirlo en autorización para desarrollar de golpe todo el juego. La aceptación de una idea individual no cierra todas las decisiones pendientes.
- El usuario quiere avanzar con decisiones pequeñas, una por una. Evita cuestionarios extensos y preguntas prematuras sobre detalles de implementación.
- Distingue decisiones confirmadas, propuestas y pendientes. No conviertas tus sugerencias en decisiones sin aceptación del usuario.
- Mantén el bloc al día cuando se acuerden cambios. Usa el estado actual del documento; las notas antiguas del historial de Git pueden haber sido sustituidas.
- Guarda los acuerdos localmente. Solo subir cambios a GitHub cuando el usuario lo pida explícitamente; las peticiones anteriores de subida no autorizan subidas continuas.
- Los secretos de los creadores no son información inicial del jugador. Respeta especialmente el antiguo maestro granjero y la imposibilidad de morir.
- Conserva la grafía **Bītu**. Recuerda: pocas personas, casas dispersas con instalaciones dentro o fuera de sus terrenos, agricultura distinta de herboristería y juego individual.
- Todo el juego será **pixel art**, con **vista desde arriba isométrica cenital** (cámara elevada en tres cuartos; referencia de perspectiva: Diablo IV). Los mapas son propuestas de distribución; no hay mapa definitivo. Motor elegido: **Godot 4**; primera plataforma: **navegador en ordenador, con teclado y ratón**. Elegir motor no autoriza empezar a programar.
- Referencia aceptada para planificar: suelo de **64 × 32 píxeles** y humano de unos **80 píxeles de alto**. Consulta `docs/terreno.md` y `docs/escala-y-recursos.md`: los demás rangos, fichas y soluciones son propuestas pendientes de desarrollo y comprobación visual, no un catálogo confirmado ni autorización de implementación.
- El usuario ha pedido detener la generación de imágenes. No generar nuevas imágenes salvo una petición explícita posterior del usuario. Conservar el recurso pixel art de Unamahloni; las dos variantes ilustradas descartadas fueron eliminadas.
- Usa el checkout existente. No crear otro checkout o un worktree salvo que el usuario lo solicite.
- Prueba actual: `prueba/project.godot`, Godot 4.6.3; consulta `docs/prueba-visual.md`. Escena y entorno provisionales, sin guardado ni pesca todavía. Usa directorios XDG dentro de `/workspace` para Godot según `docs/siguiente-bloque.md`; los predeterminados no son escribibles. No generar PNG nuevos por preparar referencias visuales.
