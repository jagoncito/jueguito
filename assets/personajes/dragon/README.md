# Dragón jugable de Bītu

Revisión integral del10 de octubre: reposo, caminar, correr, minar, talar,
recolectar, pescar y zarpazo. Se conservan exactamente los PNG y los16 registros
de arrodillarse/levantarse de la recolección que gustó al usuario.

Cuerpo esbelto gris azulado, vientre/hocico crema, ojos ámbar y cresta/alas naranja.
El acabado gráfico se entrega para revisión dentro del juego.

| Acción | Vistas/fases | Registros |
|---|---|---:|
| Reposo y alias sin equipo | 8 × 2 | 16 |
| Marcha | 8 × 4 | 32 |
| Sprint | 8 × 4 | 32 |
| Minería | 8 × 4 | 32 |
| Tala | 8 × 4 | 32 |
| Arrodillarse/levantarse | 8 × 2 | 16 |
| Pesca: cargar, esperar, recoger | 8 × 3 | 24 |
| Zarpazo: cargar, golpear, seguir, recuperar | 8 × 4 | 32 |
| Total | Ocho direcciones | 216 |

Diez PNG fuente, copiados byte por byte a la prueba. AtlasTexture, filtro nearest
y escala uniforme: no son atlas nativos128×128. Reposo/marcha/sprint conservan
la cresta a80px sobre el apoyo; una sola escala durante cada ciclo.

Las manos quedan libres al desplazarse. Cada actividad equipa su instrumento.
Pico y hacha comparten una herramienta y reloj de trabajo; ambos usan poses
completas con manos y madera/metal dibujados juntos. Se registran por separado
la punta minera y el borde ancho de tala. Cinco golpes por recurso. Antes del
golpe, un paso físico ajusta el apoyo, respetando colisiones. Si no hay espacio,
se cancela el trabajo y se recupera el control.

Las vistas generadas que giraban de forma incorrecta se proyectan desde su
vista simétrica coherente: cuerpo, manos y contactos reflejados juntos. Nunca
se gira la herramienta por separado. `mirror_x` registra esa decisión.
`pesca-norte.png` aporta únicamente la recogida norte; el resto de esa fuente
no se utiliza. Todas las regiones activas contienen una sola figura.

La caña está dibujada con el cuerpo. El sedal se une a su extremo registrado y
llega al flotador real del agua; mantener clic recoge y soltar afloja la tensión.
Las garras usan cuatro fases y un único impacto. Un maniquí permite probarlo
sin añadir criaturas o IA enemiga.

Registro reproducible: `python prueba/tools/register_dragon.py`.
Pillow/NumPy/SciPy leen medidas, sin editar PNG. El registro conserva las poses
aprobadas del palín y las fuentes/puntos/transformaciones del conjunto nuevo.

Revisión: `?vista=dragon` o `prueba/scenes/dragon.tscn`.
1 reposo,2 marcha,3 minería,4 tala,5 palín,6 parar/andar,7 sprint,8 pesca,9 zarpazo.
Espacio: cámara lenta. `?vista=personajes` compara con los seis NPC.
