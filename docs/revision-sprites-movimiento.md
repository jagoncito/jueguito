# Revisión selectiva del protagonista — 11 de octubre

## Defectos identificados al comparar las fuentes y el render del juego

- Reposo venía de un atlas distinto al de marcha. Aunque ambas crestas estuvieran
  a 80 px, cabeza, torso y postura cambiaban al empezar o dejar de andar.
- Los dibujos frontales repetían la misma pierna adelantada. La diferencia de
  píxeles entre cuatro recortes no verificaba una zancada alterna.
- Las diagonales traseras NW y NE tenían perspectivas y proporciones diferentes.

## Corrección aplicada

44 registros de reposo/marcha/sprint cambian. La revisión dentro del canvas
detectó que el cuarto dibujo de marcha aún tenía
un pie levantado, así que no se usó como reposo. Se corrigió únicamente el atlas
de reposo desde la referencia de marcha: cinco vistas con ambos pies apoyados,
registradas a80px y con las tres vistas derechas reflejadas. En frontal, la segunda
media zancada refleja la primera figura completa: intercambia piernas y brazos,
no solo una extremidad. Las vistas NE/E/SE de movimiento usan las parejas
NW/W/SW reflejadas completas. Todas las posiciones locales se reflejan juntas.

Solo se sustituye reposo.png y su copia de ejecución, mediante la herramienta
de imágenes. No se editan imágenes con Python ni se deforman por ejes.
Fuentes y registros de minería, tala, pesca, garras y los 16 de flores son idénticos a fe7091e. Los cambios remotos de
recorridos a5250f4 se conservan. No se cambia velocidad, colisión, alcance,
número de golpes, mapa, NPC ni tiempo de acciones.

## Verificación y límites

Registro reproducible con `python prueba/tools/register_dragon.py`.
`check_dragon_anatomy.py` verifica también crestas, escalas constantes por ciclo, parejas
simétricas y medias zancadas frontales reflejadas. Godot comprueba poses renderizadas
incluyendo el reflejo; no cuenta únicamente los bytes del recorte fuente.

Las capturas y vídeo de la revisión de ocho direcciones se actualizan desde el
canvas de Godot. Esta corrección elimina tres defectos concretos del movimiento.
No afirma que cuatro dibujos equivalgan a una animación completamente suave,
ni otorga aprobación visual a las acciones conservadas. Sprint conserva sus
propias poses de inclinación; no es una marcha acelerada ni un nuevo modelo.

Verificados registro reproducible, nueve fuentes y todos los registros de acciones
preservados, integridad CRC del ZIP y PCK idéntico al exportado. Godot: dragón
y extracción real. Navegador: ocho direcciones/acciones y reposo/arranque/impactos
en partida y extracción por clic de cobre, madera y flor con botín/mochila.
Vídeo y capturas del canvas renovados.

La prueba mantiene todos los controles. `?vista=dragon`, tecla 6 alterna
reposo/marcha y Espacio permite comparar lentamente. Teclas 2/7: marcha/sprint.
