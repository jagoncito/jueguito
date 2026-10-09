# Bītu y el archipiélago

Proyecto de juego individual de fantasía, **íntegramente en pixel art**, con **vista desde arriba isométrica cenital**, centrado en explorar, farmear, mejorar y coleccionar.

**Primera prueba visual jugable:** una zona provisional de Bītu con el **dragón protagonista bípedo y sus rasgos faciales originales y ocho direcciones**. Camina con el pico–hacha, mina, tala y usa el palín al arrodillarse. Un clic inicia toda la extracción. Incluye una [revisión ampliada de animaciones](assets/personajes/dragon-avatar/README.md). El juego completo continúa en diseño. Consulta [cómo probarla](docs/prueba-visual.md).

Motor elegido: **Godot 4**. Primera plataforma: **navegador en ordenador, con teclado y ratón**. La versión descargable queda como posibilidad futura.

La generación general de imágenes está en pausa; solo se crean recursos cuando el usuario los pide explícitamente.

[![Captura real de la prueba](prueba/capturas/recursos-en-juego.png)](prueba/README.md)

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

- [Propuesta visual de agua y casa](docs/referencias/README.md): referencia revisada de agua turquesa y casa rural de entramado de madera; publicada por petición del usuario, sin integrar en el juego.

- [Unamahloni — pose quieta en pixel art](assets/personajes/unamahloni-idle.png): versión original, PNG transparente de 1143 × 1376 píxeles.
- [Notas de uso del personaje](assets/personajes/README.md).
- [Cuatro tomates en pixel art](assets/objetos/cultivos/README.md): común, prístino, Siru y Siru prístino; PNG independientes con fondo transparente.
- [Pico–hacha de hierro](assets/herramientas/pico-hacha/README.md): PNG transparente, medidas, agarre, componentes visuales independientes y escena de revisión animable en Godot.
- [Palín de herborista](assets/herramientas/palin-herborista/README.md): diseño exótico con hoja vegetal, integrado en la recolección arrodillada de flores.
- [Árboles, cobre, Yde y botín](assets/entorno/recursos/README.md): dos atlas transparentes, tres árboles con sus tocones, estados del cobre y dibujos propios del botín, con recortes, anclas y escala registrados. Revisión con `?vista=recursos`.

Para ejecutar la prueba en tu ordenador: instala Godot **4.6.3**, importa `prueba/project.godot` y pulsa **F5** para jugar. También puedes usar la [descarga para navegador](prueba/descargas/bitu-navegador.zip), con Python 3; consulta las [instrucciones de la prueba](prueba/README.md). Movimiento WASD, **Shift para sprint**, rueda para zoom, un clic izquierdo sobre mena, árbol o flor cercana para extraer, E para las otras interacciones y Tab para mostrar la mochila. La prueba no guarda progreso.

Para retomar en otro chat, empezar por el bloc y continuar con una decisión cada vez.
