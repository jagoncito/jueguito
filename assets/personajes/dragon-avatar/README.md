# Dragón — protagonista bípedo

Tras revisar la primera integración, el usuario pide rehacer proporciones, cola y animaciones, con **ocho vistas como mínimo**. Esta versión conserva la identidad de la cara: ojos ámbar, hocico beige redondeado, sonrisa, piel azul grisácea y aletas naranjas. Las perspectivas nuevas están redibujadas; **no son un recorte idéntico de la cara original**. El PNG original sigue intacto como referencia. Nombre, especie concreta, historia y personalización pendientes.

![Ocho vistas dentro de Godot](../../../prueba/capturas/dragon-animaciones.png)

| Atlas transparente | Dimensiones fuente | Contenido |
|---|---|---|
| `dragon-reposo.png` | 1536 × 1024 | Ocho poses erguidas. |
| `dragon-marcha-frontal.png` | 1312 × 1199 | Cuatro fases en S, SW, E y SE. |
| `dragon-marcha-trasera.png` | 1312 × 1199 | Cuatro fases en W, NE, N y NW. |
| `dragon-marcha-apoyos.png` | 1312 × 1199 | Apoyos opuestos adicionales de S y N. |
| `dragon-transiciones.png` | 1312 × 1199 | Agarre preparado; su antiguo paso ya no se usa. |
| `dragon-trabajo.png` | 1261 × 1247 | Carga y golpe en cada dirección. |
| `dragon-herboristeria.png` | 1536 × 1024 | Recolección arrodillada y elevación. |
| `dragon-jugable.json` | Coordenadas fuente | Regiones, anclas de suelo, palmas y escala uniforme. |
| `dragon-idle.png` | 1254 × 1254 | Referencia cuadrúpeda original, sin cambios. |

Direcciones: **S, SW, W, NW, N, NE, E, SE**. Son dibujos completos: cabeza, torso, brazos, piernas, alas y cola forman parte de cada pose. La cola nace de la pelvis, cambia de perspectiva con el cuerpo y acompaña los pasos; no se coloca como una pieza suelta ni se estira. Se retiran los dos atlas de piezas sustituidos.

La presentación erguida queda normalizada a **90 px antes del zoom**; la pose arrodillada es más baja de forma intencionada. Los PNG grandes se mantienen y se muestran mediante texturas recortadas en memoria, vecino más cercano y una escala uniforme por silueta: no son sprites nativos de 128 × 128. El catálogo contiene **80 entradas**, incluidas 32 de marcha (cuatro por dirección); la elevación E reutiliza la pose baja correcta porque el dibujo generado de elevación no conservaba su perfil. Los pequeños componentes desconectados que invadían algunas celdas se descartan al preparar cada fotograma en memoria; los originales no se alteran. El atlas antiguo de marcha se retira, recuperable en Git. No se afirma que todas las poses sean animación final de producción.

La punta del pico y el filo del hacha se alinean con el recurso al impactar; la postura ajusta el apoyo hasta 18 px sin cambiar la posición física. El cuerpo gira inmediatamente hacia **la base del recurso**, independientemente de la altura del punto de impacto. Los mangos se registran con las palmas dibujadas y se ocluyen por el cuerpo y los dedos; no se mueven brazos a través de la espalda para alcanzar herramientas. El palín hace paladas breves desde la muñeca y toca la tierra al extraer. Un cambio de apoyo al agacharse mantiene su escala entre 0,65 y 0,95, sin desplazar físicamente al jugador ni ampliar el alcance.

- Marcha: contacto A → paso A → contacto B → paso B, con cuatro dibujos distintos y herramienta equipada. Los pies traseros avanzan alejándose de la cámara. El ciclo sigue la distancia realmente recorrida, no solo la tecla pulsada; se detiene al quedar bloqueado.
- Minería/tala: preparación → carga → golpe → recuperación; señales y tiempos conservados.
- Herboristería: agacharse → paladas → extracción → elevación → recuperar postura.
- Pesca, regadera, combate, daño y esquive: pendientes de sus sistemas.

[`dragon_visual.gd`](../../../prueba/scripts/dragon_visual.gd) presenta las poses; [`player.gd`](../../../prueba/scripts/player.gd) registra herramientas y orientación. Los siete atlas y el catálogo tienen copias idénticas dentro de `prueba/` para exportar el proyecto independiente.

**Agarre revisado:** coordenadas de palma medidas en cada dibujo, incluida la marcha. `hand_cover` presenta una región de los dedos del mismo atlas sobre el mango, sin modificar el PNG. El cuerpo ocluye las herramientas traseras; las frontales se presentan delante del torso y detrás de los dedos. Pico–hacha y palín usan ocho proyecciones espaciales propias, no solo giros de una única imagen. [`register_motion_assets.py`](../../../prueba/tools/register_motion_assets.py) reproduce los registros medidos y emite JSON para revisión; requiere Pillow, NumPy y SciPy, no edita imágenes.

Importa `prueba/project.godot` en **Godot 4.6.3** y pulsa **F5** para jugar. Cámara inicial de prueba a zoom **1,5**, ajustable con la rueda. Abre `prueba/scenes/dragon.tscn` y pulsa **F6** para ver simultáneamente ocho direcciones ampliadas ×2: **1 reposo, 2 marcha, 3 minar, 4 talar, 5 palín**. En el navegador añade `?vista=dragon` a la URL.

[Marcha](../../../prueba/capturas/dragon-marcha.png) · [Minería](../../../prueba/capturas/dragon-minar.png) · [Tala](../../../prueba/capturas/dragon-talar.png) · [Palín](../../../prueba/capturas/dragon-palin.png)

[Prueba de navegador](../../../prueba/descargas/bitu-navegador.zip) · [Vídeo real del canvas](../../../prueba/capturas/dragon-animaciones.webm) · [Alcance y comprobaciones](../../../docs/prueba-visual.md).

## Referencia original

![Dragón original del avatar](dragon-idle.png)

Creado el 8 de octubre de 2026 a partir del avatar del usuario. Pose cuadrúpeda estática conservada sin redimensionar ni recortar. [Medidas, apariencia y huella SHA-256](dragon-idle.json). La adaptación bípedo posterior sustituye al protagonista humano anterior; Unamahloni mantiene su papel de maestro.

El usuario autoriza generar estas vistas, integrarlas, retirar los recursos sustituidos y subir esta corrección a GitHub. La generación general sigue en pausa y las futuras subidas requieren petición.
