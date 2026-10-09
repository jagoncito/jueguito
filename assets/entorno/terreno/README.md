# Hierba y tierra — Bītu

Sprites creados por petición expresa del usuario el 9 de octubre de 2026 para una integración posterior. No se han incorporado a la escena, al TileSet ni a la descarga del juego.

`hierba-y-tierra.png` conserva intacto el atlas original generado: PNG RGBA de 1774 × 887 píxeles, con transparencia. Dos variantes de hierba verde musgo en la fila superior y dos de tierra marrón grisácea en la inferior. Superficies planas, sin caras laterales ni grosor de plataforma.

`terreno.json` registra regiones medidas, anclas centrales, huellas y escalas de presentación. Los sprites no son PNG nativos de 64 × 32: la presentación prevista es **64 × 32 píxeles por casilla**. La calibración por eje indicada ajusta solamente la superficie del suelo a ese rombo; los originales no se han redimensionado ni editado.

| Sprite | Posición en el atlas |
|---|---|
| `hierba-a` | Superior izquierda |
| `hierba-b` | Superior derecha |
| `tierra-a` | Inferior izquierda |
| `tierra-b` | Inferior derecha |

Para Godot: crear una AtlasTexture por `region_px`, utilizar filtro nearest y aplicar `presentation_scale_xy`; situar el centro del recorte en el centro de la casilla. Las regiones y anclas están en píxeles fuente, las huellas en píxeles de presentación.

Verificados transparencia, cuatro regiones dentro del atlas, dimensiones, calibración y huella SHA-256; sin píxeles rojos saturados de opacidad superior a 0,5 en la versión conservada. Las dos primeras pruebas de generación se descartaron como candidatas por su borde rojizo; siguen conservadas en el directorio de imágenes generadas de la sesión. La fuente seleccionada también permanece allí intacta.

Pendientes de la integración: revisión de bordes y repetición en una cuadrícula real de 64 × 32, transiciones entre hierba y tierra y aprobación visual. Estas cuatro bases no constituyen un TileSet de transiciones completo. La petición posterior de generar el Miutu y subir todo lo pendiente autoriza publicar este lote; no autoriza su integración ni reabre la generación general de imágenes.
