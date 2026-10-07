# Primera prueba visual de Bītu

Una pequeña escena para revisar **el aspecto y la escala** después de la petición de probar cómo se ve. El terreno, el personaje, la casa, las plantas y los árboles son referencias temporales dibujadas por Godot. Los cuatro tomates son los PNG originales del repositorio, con proporciones conservadas y filtrado por vecino más cercano. No se generaron imágenes artísticas nuevas.

## Qué se puede probar

- Caminar con **WASD**, con colisiones en agua, casa, bases de árboles y límites.
- Ajustar el zoom con la **rueda**.
- Acercarse a las parcelas y pulsar **E** para plantar, regar o cosechar según su estado.
- Acercarse a una mena o flor y pulsar **E** para recogerla; aparece botín físico, desaparece el recurso y comienza su reaparición en su propia zona.
- Recoger objetos al pasar cerca. Los tipos de tomate se mantienen separados en la mochila.
- Mostrar u ocultar la mochila con **Tab**.

Los cuatro tomates junto a la orilla son **muestras de comparación**, no un ejemplo de rareza normal. Las cosechas de esta prueba dan tomate común y aumentan el contador de experiencia del tomate. Todavía no hay probabilidades de calidad ni variantes en la cosecha.

Las herramientas se indican aparte de la mochila. Sus huecos interactivos, requisitos y mejoras siguen pendientes.

## Ejecutar en tu ordenador

Instala **Godot 4.6.3 estándar**, descarga el proyecto y usa **Importar** para abrir `prueba/project.godot`. Pulsa **F5** para jugar. No hace falta Node, npm ni compilar manualmente.

Hay una [descarga de navegador ya preparada](../prueba/descargas/bitu-navegador.zip): descomprime todo y ejecuta `python JUGAR.py` dentro de `bitu-navegador` con Python 3. Abre automáticamente el navegador y mantiene el servidor local mientras la terminal esté abierta.

Para regenerar la versión de navegador, instala las plantillas de exportación de la misma versión desde Godot. Usa **Proyecto → Exportar → Web** y exporta `index.html` a una carpeta. Sirve esa carpeta mediante un servidor HTTP; abrir el HTML con doble clic no carga los archivos WebAssembly correctamente. Se incluye una configuración sin hilos, que no requiere cabeceras especiales de aislamiento. El navegador necesita WebGL 2.

La prueba se sube a GitHub tras la petición explícita del usuario; la publicación como sitio web sigue pendiente. [Carpeta de la prueba](../prueba/README.md).

## Parámetros provisionales

| Referencia | Valor de esta prueba |
|---|---|
| Suelo / humano / botín / iconos | 64 × 32 / 80 de alto / 32 × 32 / 64 × 64 píxeles |
| Sector | 32 × 32 casillas |
| Mochila | 12 huecos; pilas de hasta 50 |
| Movimiento | 150 píxeles por segundo |
| Zoom | 0,75; 1; 1,5; 2 |
| Recogida / interacción | 29 / 47 píxeles |
| Extracción / reaparición | 2 / 14 segundos |
| Botín temporal de prueba | 10 minutos |
| Crecimiento de tomate / riego | 12 / 8 segundos activos |

Estos valores permiten revisar rápido, no fijan dificultad, velocidad o economía definitivas. Sin agua se conserva el cultivo y su progreso. Se recoge lo que cabe y el resto mantiene su plazo en el suelo.

## Límites

**No guarda progreso**: recargar o cerrar reinicia la escena. No incluye pesca activa, navegación, habitantes, relato inicial, enemigos, combate, museo, construcción libre de parcelas ni producción gráfica definitiva. La granja usa parcelas precolocadas para esta revisión de escala; la libertad de distribución sigue siendo el diseño previsto.

## Comprobaciones

`tests/smoke.gd` comprueba capacidad y recogida parcial, separación de calidad y variante, conservación del crecimiento sin riego, reaparición dentro de la zona y conversión isométrica.

`tests/scene-smoke.gd` ejecuta la escena y comprueba extracción, recogida física y colisión real contra el agua. Ambas pruebas han pasado. La exportación se ha abierto en Chromium con WebGL 2, sin errores de consola; se revisaron movimiento, zoom y extracción mediante controles del navegador y se capturó el resultado renderizado.

```sh
cd prueba
godot --headless --editor --path . --import
godot --headless --path . --script res://tests/smoke.gd
godot --headless --path . --script res://tests/scene-smoke.gd
godot --headless --path . --quit-after 120
mkdir -p build/web
godot --headless --path . --export-release Web
```

En el entorno cloud, anteponer a cada comando Godot:

```sh
env XDG_DATA_HOME=/workspace/.local/godot/data XDG_CONFIG_HOME=/workspace/.local/godot/config XDG_CACHE_HOME=/workspace/.cache/godot
```

Las carpetas deben existir. No cambiar `HOME`. La configuración de entorno guardada es un borrador; su publicación es independiente de esta prueba.
