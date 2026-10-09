# Personajes con objetos intercambiables

Entrega del 9 de octubre de 2026: **Flavia y Unamahloni**, ocho orientaciones, cuatro poses de manos libres/uso y cuatro fases de marcha por dirección. **64 fotogramas activos por personaje, 128 en conjunto.** Las bases y láminas originales se conservan.

## Ver la entrega

Descarga el repositorio completo desde GitHub con **Code → Download ZIP**, extrae sus carpetas y abre [vista-previa.html](vista-previa.html). No necesita servidor ni conexión. Cambia personaje, pose, objeto y ampliación; permite caminar, pausar, avanzar fases y mostrar anclajes. La vista ×1 es el tamaño de revisión dentro del juego: figura de hasta 80 píxeles en 128 × 128, suelo de 64 × 32.

Las fuentes PNG grandes se dibujan con vecino más cercano. No se presentan como imágenes nativas de 128 × 128 ni como una integración de estos NPCs en la granja.

## Objetos y agarres

- `objetos-equipables.png`: cuaderno, frasco verde y mazo, con proyección frontal y trasera. Seis objetos independientes sobre transparencia real.
- `objetos.json`: regiones, tamaños y puntos de agarre de esas seis vistas, más referencias al tomate, pico–hacha y palín ya existentes. No se modifica ninguno de esos tres recursos.
- `compositor.js`: montaje separado de cuerpo y objeto. Alinea el agarre principal a la palma; cuando hay dos agarres y la pose es de dos manos, aplica una transformación uniforme para hacer coincidir ambos. Respeta profundidad y redibuja pequeños discos de palma por encima del mango. No estira el cuerpo ni refleja accesorios.
- El mazo corto, el frasco, el tomate y el palín usan una mano. Cuaderno y pico–hacha disponen de dos agarres. Probar un objeto de una mano en la pose de dos manos no le crea un segundo mango.

Las direcciones son de pantalla: S hacia el observador, N de espaldas, W izquierda, E derecha. Las vistas traseras del objeto se eligen para N/NW/NE. Para la prueba genérica, este visor reutiliza los PNG originales de una proyección del pico–hacha y el palín; el prototipo actual ya dispone de sus ocho vistas registradas, que esta entrega conserva sin cambiar. Se pueden registrar futuros objetos —incluidas armas— con la misma convención, sin fijar ningún catálogo de combate.

`equipamiento.json` de cada personaje contiene regiones absolutas `[x,y,ancho,alto]` y pies/palmas relativos a esa región. La referencia de pies es (64,112); la marcha mantiene escala constante por dirección. Los anclajes de espalda pueden quedar ocultos por el torso, y eso no implica ausencia de objeto. Las pequeñas variaciones de las fuentes y la lateralidad anatómica necesitan revisión al producir sprites definitivos.

## Comprobaciones

Completadas sobre esta entrega:

- **`BITU_EQUIPMENT_ASSETS_OK`**: 128 fotogramas únicos, ocho direcciones, cuatro fases por ciclo, medidas y huellas de todas las fuentes, regiones sin solapamiento, anclajes visibles sobre la silueta y base original de Unamahloni intacta.
- **`BITU_EQUIPMENT_BROWSER_OK`**: 896 combinaciones personaje/pose/fase/objeto/dirección en Chromium; agarres coincidentes, sin recortes fuera de 128 × 128, filtrado correcto, controles y cambio real de fase. Revisadas visualmente las ocho vistas del mazo, libro y frasco.
- **Dragón conservado**: test real en Godot 4.6.3, repetido sobre la actualización de `main` en [`c1c037c`](https://github.com/jagoncito/jueguito/commit/c1c037c2d4860c1bb2fdcb0c794b7912e3b187cd). Resultado `BITU_DRAGON_SMOKE_OK`; 80 fotogramas, ocho direcciones con cuatro fases de marcha distintas, agarres y ocultación, movimiento real, minería, tala, palín y recuperación. Esta entrega no modifica sus PNG, metadatos, herramientas ni scripts.

Para repetir las pruebas de recursos:

```sh
python assets/personajes/objetos-equipables/validar.py
```

Requiere Python 3 y Pillow. La verificación automática del navegador está en `verificar-visor.py`; requiere Playwright y Chromium en `/usr/bin/chromium` y guarda capturas en un directorio temporal. Ejecutar con `python assets/personajes/objetos-equipables/verificar-visor.py`.

El visor usa JavaScript estándar y el resto de carpetas del repositorio. Las poses de uso son estáticas: no son ciclos completos de trabajo, alquimia, construcción o combate. No se crean personajes todavía sin una base visual, como el herrero.
