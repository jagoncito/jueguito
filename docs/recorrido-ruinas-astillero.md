# Ruinas y camino costero hasta el astillero

Petición del 10 de octubre de 2026: generar las ruinas y un camino largo hasta el astillero, conservando el mapa de Bītu. Fuentes visuales para revisión. El usuario solicita después un lote de assets y su publicación; integración pendiente.

## Qué estaba anotado

La [organización del terreno](terreno.md) ya recoge zonas conectadas, cámara que recorre mapas mayores que la pantalla, límites de cámara y transiciones en accesos. También conserva el único recorrido inicial desde las ruinas al astillero y la escala amplia del comienzo. El [README del astillero](../assets/entorno/astillero/README.md) publicado enumera recortes, transparencia, escala, anclas, colisiones y prueba de uniones pendientes. Esa preparación no se considera completada por generar una imagen.

## Pantalla, zona y dibujo

- **Pantalla:** el área que ve la cámara en cada momento. Caminar fuera de ella no obliga a cambiar de mapa: la cámara puede seguir al jugador.
- **Zona:** un escenario de Godot con suelo, objetos, límites, colisiones y puntos de entrada. Puede ocupar muchas pantallas.
- **Transición:** programación que detecta un acceso, conserva el estado, carga otra zona y coloca al jugador en su entrada. Una ilustración no implementa ese comportamiento.
- **Sector técnico:** porción que puede cargarse o descargarse por rendimiento; no tiene por qué provocar una transición visible.

La dirección propuesta para este comienzo es **una zona exterior amplia y continua con ruinas, varios tramos del sendero y astillero**, recorrida por la cámara. La entrada al interior del astillero puede ser una transición. Si las mediciones aconsejan dividir el exterior, se pueden usar accesos naturales entre zonas sin acortar la ruta. No se fija aún número de mapas, casillas ni minutos de viaje.

## Cómo construir un recorrido largo

Se ensamblan suelos reutilizables, curvas de sendero, bordes de acantilado, rocas, árboles y piezas de ruinas. Arcos y estructuras únicas conservan piezas mayores con capas de profundidad. No se estira una imagen para alargar la ruta: aumenta la extensión real de suelo transitable, manteniendo la escala del personaje y las piezas.

Secuencia visual propuesta: patio de ruinas → descenso → mirador del acantilado → bosque costero → curva rocosa sobre una cala → llegada al astillero. Son tramos del único camino inicial; no nuevos poblados ni atajos hacia el interior. La herrería permanece en el noroeste lejano y el maestro está de paso con Flavia.

Las láminas de conjunto comprimen el recorrido para poder revisarlo: **no representan lo que cabe en una sola pantalla a escala jugable**. Su duración se probará caminándolo después de registrar los assets. La amplitud debe ofrecer variedad visual y evitar un corredor vacío repetido.

## Preparación pendiente para el juego

1. Revisar las fuentes y separar piezas útiles; limpiar halos y márgenes.
2. Registrar a escala común: suelo de referencia 64 × 32 y adulto de 80 px; conservar resolución y proporciones.
3. Definir anclas en el suelo, profundidad, atlas y uniones del terreno.
4. Construir la zona con piezas reutilizadas y colisiones transitables; comprobar rampas y límites de costa.
5. Programar límites de cámara y, si procede, entradas/transiciones con estado persistente.
6. Medir rendimiento, memoria y duración del recorrido antes de integrarlo en la entrega jugable.

Las piezas separadas en una lámina son fuentes de trabajo, no sprites nativos ya registrados ni colisiones automáticas.

## Lote posterior

Registradas 48 piezas en [ruinas-camino](../assets/entorno/ruinas-camino/README.md), con tres atlas, catálogo, texturas, prefabs y galería. El registro permite seleccionarlas; se mantienen pendientes la geometría exacta del suelo, halos, uniones, escala visual final y colisiones.
