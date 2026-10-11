# Auditoría de assets de Bītu — 11 de octubre de 2026

Revisión de archivos, catálogos, documentación, escenas y cargas de recursos. Se contrasta el checkout de trabajo con el checkout publicado en main (6fbcf9c). No se ejecuta Godot ni se afirma validación visual del juego en esta auditoría. Auditoría inicial sin generación; posteriormente el usuario solicita generar los huecos y publicarlos. Ver actualización al final.

## Lugares

| Lugar | Referencias existentes | Preparación/integración |
|---|---|---|
| Casa del jugador | Exterior en agua-casa | Sprite registrado e integrado; interior ausente, entrada solo marcador |
| Astillero | Exterior e interior de taller | Fuentes; vivienda de Flavia no identificada ni dibujada |
| Museo | Exterior e interior | Fuentes; no integrado |
| BITU24H | Exterior, tienda y almacén interior | Fuentes; vivienda de comerciante/elfa sin resolver ni dibujar |
| Casa de Unamahloni | Exterior e interior con espacio doméstico | Fuentes; no integrado |
| Cocinero/pescador | Parcela, choza exterior/interior, cobertizo exterior/interior | Fuentes; no integrado |
| Minero/herrero | Conjunto, taller/vivienda exterior/interior, mina exterior/primera galería | Fuentes; no integrado |
| Ruinas y camino | Láminas, lote de módulos y tres alternativas de recorrido | Fuentes; no constituyen nivel construido |
| Agua, hierba, tierra, arena | Fuentes/atlas y registros | Presentes en prueba; agua estática, sin autotile completo/cascadas |

La primera prioridad ausente es el interior inicial de casa del jugador. DISENO sección7 ya fija casa abandonada habitable, cama y mesa sencillas, polvo/desgaste y cofre oculto con semillas y carta. No inventar un pasado visible, catálogo de muebles obligatorio ni un almacén general confirmado.

La casa de Flavia es parte del diseño; astillero no equivale a vivienda. El hogar de comerciante/elfa necesita decidir ubicación/distribución: la falta no exige automáticamente una casa adicional. Se han inspeccionado las láminas interiores de astillero y tienda: muestran taller y venta/almacén respectivamente, sin dormitorio.

## Personajes y otros recursos

Seis NPC con ocho vistas de reposo cada uno, integrados en posiciones provisionales. En main el protagonista tiene216 registros (reposo/sin equipo, marcha, sprint, minería, tala, recolección, pesca y zarpazo). Checkout de trabajo y algunos README antiguos todavía mencionan160/208: no usar esas cifras para resumir main ni sobrescribir sus mejoras.

Pico–hacha y palín presentes; caña dibujada dentro de poses de pesca. Main contiene pesca de costa, un pez de prueba y maniquí de zarpazo: sería incorrecto afirmar que toda pesca está pendiente. Regadera/animación de riego sin arte dedicado registrado; riego funcional provisional no equivale a animación terminada. No se encuentra paquete propio de barco navegable, mochila visible o kit portátil de cocina. Casco del astillero y ollas decorativas no sustituyen esos assets.

Árboles/tocones, cobre, flor de Yde, botín madera/mineral/flor, cuatro tomates y Miutu creados. No son un catálogo completo de especies, minerales, alimentos o coleccionables. Enemigos, futuras islas, mejoras de herramientas/casa/barco y catálogo de museo requieren definición antes de enumerar piezas concretas.

## Próximo trabajo y límites

1. Crear referencia interior de casa inicial coherente con exterior y acuerdos.
2. Resolver/dibujar vivienda de Flavia y espacio doméstico de la pareja.
3. Registrar módulos existentes y construir zonas, transiciones y colisiones; dar más suelo útil a interiores sin encoger personajes.
4. Diseñar assets funcionales pendientes conforme se implemente barco, riego y cocina.

Esta auditoría corrige la afirmación de que todo estaba creado. No identifica una lista definitiva de todo el juego: separa entregas existentes, huecos verificables del diseño inicial y arte futuro dependiente de sistemas pendientes.

## Actualización tras la petición de completar y publicar

Referencias nuevas en [completar Bītu](../assets/entregas/completar-bitu/README.md): interior de casa inicial, casa independiente de Flavia exterior/interior, vivienda compartida anexa a BITU24H exterior/interior, vistas y cubierta de velero de trabajo, equipo regadera/grifo/mochila, fases de riego y kit portátil. La fuente de riego se encuentra ahora en [las referencias del dragón](../assets/personajes/dragon/referencias/README.md), conservada sin integrar. Viviendas elegidas por respuestas expresas; barco por delegación. Estos huecos tienen ahora fuente visual; registro de módulos/fotogramas, escala, continuidad, colisiones y juego siguen pendientes. Las tablas superiores reflejan el estado auditado antes de esta entrega; no confundirlo con esta actualización.
