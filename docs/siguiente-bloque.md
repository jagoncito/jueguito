# Siguiente bloque preparado: base jugable de farmeo

Preparado el **7 de octubre de 2026**, después de que el usuario pidiera subir lo pendiente a GitHub y preparar lo siguiente. Se toma la base de farmeo recomendada como dirección de preparación. El mapa y el contenido de prueba no son decisiones narrativas definitivas. **Este documento conserva la propuesta completa; el estado implementado se describe en [prueba visual](prueba-visual.md).**

## Objetivo de la entrega

Poder moverse por una pequeña zona de prueba de Bītu, utilizar recursos y recoger botín en la escala acordada, con mochila visible y una primera parcela de tomates. Comprobar que el movimiento, la colocación y el farmeo se sienten coherentes antes de extender el archipiélago.

## Orden de trabajo

| Bloque | Trabajo | Resultado revisable |
|---|---|---|
| 1. Proyecto y mundo | Proyecto Godot 4 para 2D compatible con navegador; suelo 64 × 32, agua y obstáculos. | Una zona pequeña en la escala elegida. |
| 2. Personaje y cámara | WASD continuo, colisiones, orden de profundidad y zoom ajustable. | Caminar junto a agua, edificios y vegetación sin atravesar sus bases. |
| 3. Objetos y mochila | Datos de objetos, iconos 64 × 64, botín 32 × 32 y recogida por cercanía. | Recoger tomates y distinguir común, prístino, Siru y Siru prístino. |
| 4. Recursos silvestres | Una zona de mena y otra de flor; interacción, desaparición y reaparición variable dentro de cada zona. | Minar o recolectar y ver botín junto al origen. |
| 5. Cultivo de tomate | Colocación en parcela, siembra, riego, crecimiento, cosecha y experiencia específica. | Completar una cosecha y comprobar pausa de crecimiento sin agua. |
| 6. Conservación y navegador | Elegir y aplicar guardado, comprobar recarga y exportación web. | Mantener el progreso previsto y probar la entrega en navegador. |

Introducir pesca activa después de validar este bucle o adelantarla si el usuario la prioriza al retomar. El recorrido ruinas–Flavia–casa y el primer barco conservan su lugar en el primer capítulo; esta zona de pruebas no sustituye el inicio del juego.

## Zona de referencia

Propuesta: un único sector de **32 × 32 casillas**, con terreno firme, un tramo de orilla, obstáculos de referencia, espacio libre de granja y dos zonas de recursos separadas. Esta dimensión es una elección de prueba, no el tamaño definitivo de Bītu.

Mantener los accesos transitables. Señalar dónde se puede cultivar y permitir elegir la distribución dentro de ese terreno. Preparar referencias de superficie para casa y árbol aunque todavía no tengan dibujos definitivos. Las zonas de mena y flor deben tener varios puntos compatibles para verificar posiciones variables.

No añadir enemigos al Bītu tranquilo para probar combate. No usar esta distribución para fijar la ubicación real de los maestros o escoger un mapa conceptual.

## Responsabilidades del soporte del juego

- **Mundo:** terrenos, superficies transitables, obstáculos y ocupación de parcelas.
- **Personaje:** movimiento, interacción contextual y herramientas equipadas.
- **Cámara:** seguimiento y zoom; límites y control concreto pendientes.
- **Objetos:** identidad, tipo, variante, calidad, icono y representación de botín.
- **Mochila:** huecos, apilado y capacidad; equipo y herramientas separados.
- **Recursos silvestres:** zona propia, posiciones válidas, disponibilidad y tiempo de reaparición.
- **Cultivos:** parcela, etapa, riego, crecimiento y experiencia por cultivo.
- **Conservación:** estado del mundo y progreso; no almacenar imágenes dentro de una partida.

Separar estas responsabilidades permite añadir peces, más cultivos, minerales, mobs o islas sin rehacer el funcionamiento básico.

## Decisiones de diseño que se mantienen

El botín aparece físicamente y entra en la mochila al acercarse si cabe. Las herramientas tienen huecos propios, se usan de forma contextual y no se desgastan. Menas y flores desaparecen al extraerlas y comienzan su tiempo de reaparición aunque el botín quede sin recoger; ese botín puede durar unos diez minutos.

El tomate tiene experiencia específica; mayor habilidad aumenta la posibilidad de calidad prístina. Siru y calidad son características independientes. La falta de riego detiene el crecimiento sin destruir el cultivo. La distribución de la granja es libre.

## Parámetros de prueba y decisiones por cerrar

Mantener juntos y fácilmente modificables los valores de prueba: número de huecos, límite de apilado, distancia de interacción y recogida, tiempos de extracción y reaparición, crecimiento, experiencia y límites de zoom. Elegir valores prácticos al implementar, documentarlos como provisionales y no convertirlos en equilibrio definitivo.

La demostración de variantes raras debe permitir comprobar las cuatro imágenes sin depender de probabilidades ultraexclusivas. Usar datos o herramientas de prueba fuera del flujo normal del jugador; no garantizar Siru en una cosecha normal ni fijar su probabilidad final.

Recomendaciones pendientes de acuerdo:

- Mochila llena: recoger lo que quepa y dejar el resto como botín temporal, conservando su plazo.
- Guardado local en navegador para la primera entrega, con mecanismo de recuperación a desarrollar; comportamiento del tiempo al cerrar pendiente.
- Interacción cercana mediante un control contextual; no cambiar el clic izquierdo de ataque sin acuerdo.
- Gráficos temporales explícitos para lo que no tiene recurso definitivo. No generar nuevas imágenes sin petición ni convertir a Unamahloni en el protagonista.

## Recursos gráficos

| Recurso | Disponible | Preparación necesaria |
|---|---|---|
| Cuatro tomates | Sí, PNG transparentes. | Importar con proporciones conservadas a presentaciones de 32 × 32 y 64 × 64, con margen para destellos. |
| Unamahloni | Una pose original. | Reservar para su personaje; direcciones, peinado y adaptación de cámara siguen pendientes. |
| Protagonista | Sin sprites definitivos. | Referencia provisional de tamaño; producción y animaciones por acordar. |
| Suelo y orillas | Sin conjunto jugable definitivo. | Referencias temporales o conjunto gráfico futuro; mantener cuadrícula y transiciones. |
| Rocas, menas, flores y árbol | Sin recursos jugables definitivos. | Referencias provisionales con apoyos y colisiones correctos. |
| Etapas de tomatera | Sin recursos definitivos. | Distinguir etapas durante la prueba y producir las imágenes al solicitarlo. |

Los originales PNG quedan intactos. La presentación en el motor puede ajustar tamaño y filtrado sin crear ni sustituir imágenes en el repositorio.

## Comprobaciones de la entrega futura

1. Movimiento continuo, colisiones y apoyo visual coherentes con la cuadrícula y profundidad.
2. Zoom legible y los cuatro tomates distinguibles en suelo e inventario.
3. Huecos propios para herramientas y equipo; botín nunca rebasa la capacidad elegida.
4. Posiciones de recursos variables dentro de su zona y accesibles.
5. Reaparición independiente del botín; salir y volver a una zona no reinicia ese tiempo.
6. Cosecha que da experiencia específica; falta de riego conserva la etapa y progreso.
7. Comportamiento de guardado y tiempo acorde con la decisión que se tome.
8. Proyecto sin errores de importación o ejecución y exportación comprobada en navegador.

No marcar estas comprobaciones como realizadas antes de existir el juego. La prueba de importación del motor descrita abajo solo verifica preparación técnica.

## Preparación técnica observada

- Godot **4.6.3 estable** ya está instalado en este entorno y pertenece a la familia elegida Godot 4. La versión definitiva del proyecto puede fijarse al comenzar.
- Disponible Chromium para una futura comprobación de navegador.
- **Importación de los cuatro PNG verificada:** proyecto temporal fuera del repositorio, importación sin errores y carga como `Texture2D`/`Sprite2D`, con filtrado por vecino más cercano y presentación proporcional de 32 píxeles. Esta prueba no verifica una escena jugable ni el aspecto final a esa escala.
- Plantillas web oficiales **4.6.3** instaladas, con SHA-512 contrastado con la lista oficial. Ya existe una exportación sin hilos y la escena ha cargado en Chromium con WebGL 2. Los detalles de las comprobaciones y los límites están en [prueba visual](prueba-visual.md).

### Directorios de Godot en este entorno

La configuración y los datos de usuario predeterminados quedan fuera de las carpetas de escritura permitidas. La prueba inicial detectó errores de escritura y caída del motor; se resolvió indicando directorios dentro de `/workspace` para cada proceso Godot.

```sh
mkdir -p /workspace/.local/godot/data /workspace/.local/godot/config /workspace/.cache/godot
env XDG_DATA_HOME=/workspace/.local/godot/data XDG_CONFIG_HOME=/workspace/.local/godot/config XDG_CACHE_HOME=/workspace/.cache/godot godot --version
```

Estos directorios y variables se verificaron tanto durante la importación como al cargar los recursos. No modificar `HOME`. Al crear el proyecto, usar las mismas variables para los comandos del editor, importación y exportación.

Se guardaron también estas instrucciones en el campo `start_skill` del borrador de configuración del entorno. El guardado del borrador no publica el entorno ni crea el juego; conservarlas en nuevas sesiones requiere revisar, guardar y publicar desde los ajustes del entorno.

Mantener el checkout existente. Subir cambios únicamente cuando el usuario lo solicite. Referencias: [esquema del primer prototipo](primer-prototipo.md), [bloc de diseño](../DISENO.md), [escala](escala-y-recursos.md).
