# Bītu y el archipiélago


**Prueba de isla integrada — 12 de octubre de 2026.** Inicio en las ruinas del este, isla conectada con seis regiones exteriores, diez interiores accesibles con E y los seis habitantes en los patios de sus propiedades. **M** abre el mapa y la cabeza del dragón marca tu ubicación actual; dentro de un edificio señala su propiedad. **Tab** abre una mochila original de supervivencia:24 huecos, pilas de1.000 («1k»), arrastre, intercambio, división con Mayús y ordenación; herramientas aparte. Ambos menús pausan la partida. [Alcance, controles y comprobaciones](docs/isla-y-mochila-prueba.md). La distribución es de prueba: sin guardado, narrativa, comercio, fabricación ni navegación implementados. Se conserva el conjunto vigente del dragón; esta entrega no modifica sus PNG.

![Inicio en las ruinas](prueba/capturas/isla-ruinas.png)

Proyecto de juego individual de fantasía, **íntegramente en pixel art**, con **vista desde arriba isométrica cenital**, centrado en explorar, farmear, mejorar y coleccionar.

**Primera prueba visual jugable:** la isla provisional de Bītu con el **dragón protagonista bípedo rehecho en pixel art, con ocho direcciones y ciclos completos por fotogramas**. Camina, sprinta, mina, tala, recolecta con palín, pesca y ataca con garras. Un clic inicia toda la extracción. Incluye una [revisión ampliada de animaciones](assets/personajes/dragon/README.md). El juego completo continúa en diseño. Consulta [cómo probarla](docs/prueba-visual.md).

Motor elegido: **Godot 4**. Primera plataforma: **navegador en ordenador, con teclado y ratón**. La versión descargable queda como posibilidad futura.

La generación general de imágenes está en pausa; solo se crean recursos cuando el usuario los pide explícitamente.

[![Captura real de la prueba](prueba/capturas/recursos-en-juego.png)](prueba/README.md)

## Suelos en la prueba

Césped, tierra y arena existentes integrados en la cuadrícula de 64 × 32, con seis variantes y fuentes compartidas. [Captura dentro del juego](prueba/capturas/cesped-tierra-arena-en-juego.png). Descarga de navegador actualizada.

## Mapa y astillero

[Ruinas y camino costero: 48 piezas](assets/entorno/ruinas-camino/README.md), tres atlas con catálogo, recursos de Godot y galería. Ruinas y terreno integrados; otras variantes siguen disponibles como fuentes.

[Mapa de Bītu para el jugador](mapas/README.md) y [exterior/interior del astillero de Flavia](assets/entorno/astillero/README.md), con módulos visuales para su preparación posterior. Fachada y taller del astillero integrados en la prueba de isla; servicios y navegación pendientes.

## Documentos

- [Bloc de diseño](DISENO.md): decisiones, personajes, sistemas, secretos narrativos para los creadores, propuestas y pendientes.
- [Propuesta de organización del terreno](docs/terreno.md): cuadrícula isométrica, colocación libre en la granja y convivencia de escenarios, recursos y criaturas.
- [Escala y recursos de todo el archipiélago](docs/escala-y-recursos.md): familias de cultivos, plantas, minerales, peces y criaturas; agua, edificios, barcos, regiones y requisitos gráficos.
- [Esquema global y primer bloque jugable](docs/primer-prototipo.md): estado de preparación y propuesta de alcance para empezar.
- [Siguiente bloque preparado](docs/siguiente-bloque.md): orden de trabajo, recursos disponibles y comprobaciones para la base jugable de farmeo.
- [Primera propuesta de mapa de Bītu](mapas/isla-bitu-propuesta-1.png).
- [Segunda propuesta de mapa de Bītu](mapas/isla-bitu-concepto.png).

Los mapas son conceptuales; ninguna distribución es definitiva. El bloc contiene información narrativa que el jugador desconocerá al principio.

## Recursos gráficos

- [Sprites de agua y casa para desarrollo](assets/entorno/agua-casa/README.md): casa ajustada a la escala del personaje y 24 piezas de agua/orilla, con PNG transparentes, atlas y visor independiente. Publicación solicitada por el usuario, sin integrar en la prueba.

- [Propuesta visual de agua y casa](docs/referencias/README.md): referencia revisada de agua turquesa y casa rural de entramado de madera; publicada por petición del usuario, sin integrar en el juego.

- [Unamahloni — pose quieta en pixel art](assets/personajes/referencias/unamahloni-idle.png): versión original, PNG transparente de 1143 × 1376 píxeles.
- [Notas de uso del personaje](assets/personajes/README.md).
- [Cuatro tomates en pixel art](assets/objetos/cultivos/README.md): común, prístino, Siru y Siru prístino; PNG independientes con fondo transparente.
- [Pico–hacha de hierro](assets/herramientas/pico-hacha/README.md): PNG transparente, medidas, agarre, componentes visuales independientes y escena de revisión animable en Godot.
- [Palín de herborista](assets/herramientas/palin-herborista/README.md): diseño exótico con hoja vegetal, integrado en la recolección arrodillada de flores.
- [Árboles, cobre, Yde y botín](assets/entorno/recursos/README.md): dos atlas transparentes, tres árboles con sus tocones, estados del cobre y dibujos propios del botín, con recortes, anclas y escala registrados. Revisión con `?vista=recursos`.

Para ejecutar la prueba en tu ordenador: instala Godot **4.6.3**, importa `prueba/project.godot` y pulsa **F5** para jugar. También puedes usar la [descarga para navegador](prueba/descargas/bitu-navegador.zip), con Python 3; consulta las [instrucciones de la prueba](prueba/README.md). Movimiento WASD, **Shift para sprint**, rueda para zoom, un clic izquierdo sobre mena, árbol o flor cercana para extraer, clic en suelo/enemigo para zarpazo, clic en agua cercana para pescar, E para las otras interacciones y Tab para mostrar la mochila. Mantén clic para recoger sedal y suelta para aflojar; Esc cancela la pesca. La prueba no guarda progreso.

Para retomar en otro chat, empezar por el bloc y continuar con una decisión cada vez.

## Personajes dentro de la prueba

Seis NPC de ocho vistas integrados localmente, con colisión y conversación provisional. Protagonista con marcha/carrera corregidas,396nombres de catálogo incluidos alias; rig anterior retirado. [Auditoría del repositorio y comparativa real de tamaños](docs/revision-personajes-en-juego.md), con dragón80px actual y alternativa72px. F7/F8 permiten compararlos en la misma partida.
