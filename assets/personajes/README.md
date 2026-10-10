# Personajes de Bītu

El protagonista tiene el conjunto completo porque es controlable. Los seis NPC solo conversan al visitarlos y comparten **ocho sprites estáticos en reposo**, uno por dirección. Las variantes adicionales de marcha, comida y equipo de NPC se retiraron por petición del usuario.

| Personaje | Sprites activos | Altura de referencia |
|---|---:|---:|
| Dragón protagonista | 160 | 80 px |
| Flavia | 8 | 80 px |
| Unamahloni | 8 | 80 px |
| Elfa del museo | 8 | 80 px |
| Comerciante | 8 | 84 px |
| Maestro de pesca/cocina | 8 | 80 px |
| Maestro enano | 8 | 64 px |

**208 registros activos en total**:48 de los seis NPC y160 del protagonista nuevo. NPC nativos128×128, apoyo(64,112); dragón con atlas nuevos registrados, cuerpo80px, marcha y sprint propios. Se retira el arte anterior del dragón por petición del usuario. Marco de escala común, estaturas conservadas; aprobación visual pendiente.

- [Sprites, atlas y prefabs vigentes](escala-juego/README.md).
- [Referencias de creación conservadas](referencias/README.md).
- [Protagonista, fuentes y herramientas](dragon/README.md).

Revisión en Godot: abrir `prueba/scenes/personajes.tscn` y F6. Web: `?vista=personajes`. Flechas cambian las vistas de todos; Espacio y V afectan a marcha/poses del protagonista; Z amplía a todos por igual.

El dragón está integrado en la partida. Los seis NPC están integrados en posiciones provisionales, con giro, colisión e interacción de conversación de prueba. Diálogos, servicios y recepción de objetos pendientes. El usuario solicita publicar esta entrega en GitHub.
