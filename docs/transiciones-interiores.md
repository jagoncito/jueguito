# Entrada y salida de interiores de Bītu

11 de octubre de 2026. El usuario pide pensar y anotar una solución común, efectiva y optimizada para todos los interiores. Este documento propone su implementación; no modifica el juego ni afirma tiempos medidos. Acuerdos previos: zonas conectadas, interiores más amplios, cancelación de acciones por movimiento y colisiones estables.

## Experiencia recomendada

Acercarse a una puerta muestra «E · Entrar» o «E · Salir». Una pulsación inicia una transición corta: fundido suave a negro, cambio de zona mientras está cubierta, fundido de vuelta. E es la propuesta porque ya se utiliza para interacción; hay que arbitrar su prioridad frente a NPC/parcelas. No entrar simplemente por rozar fachada ni exigir precisión al pulsar una puerta diminuta. El portal debe tener zona accesible delante del umbral y un indicador vinculado a los pies del personaje.

Propuesta inicial: 0,12–0,18s para oscurecer y lo mismo para aclarar; no añadir pausa negra artificial si la zona ya está lista. Son valores para probar, no requisito cerrado ni garantía de carga. Fundido, no destello instantáneo. Si tarda en cargar, mantener negro sin revelar escenario incompleto; mostrar indicación de carga discreta solo si la espera se prolonga.

Al salir, aparecer delante de la misma puerta usada, sobre suelo transitable, mirando hacia el exterior. Al entrar, detrás del umbral mirando hacia la sala. Cámara colocada inmediatamente en el punto correcto mientras la pantalla está negra: no recorrer el mapa desde su origen ni interpolar desde la cámara exterior. Conservar zoom elegido, dentro de límites razonables que se definan en prueba. No encoger personaje para mostrar toda la sala; cámara y límites recorren el interior amplio.

## Aplicación por lugar

| Lugar | Comportamiento propuesto |
|---|---|
| Casa del jugador | Puerta exterior ↔ interior abierto. Cofre/cama/cocina siguen interacciones propias; no portales. |
| Casa de Flavia | Puerta exterior ↔ vivienda. Dormitorio y cocina/salón en una escena, sin fundido entre habitaciones. |
| Astillero cerrado | Puerta ↔ taller interior. Muelle y cobertizo abierto permanecen en exterior. |
| BITU24H | Entrada ↔ tienda/almacén. Vivienda anexa ↔ acceso doméstico exterior y puerta comunicante de tienda; preservar el portal concreto usado. |
| Vivienda comerciante/elfa | Una escena doméstica para dormitorio/estudio/salón; puerta comunicante cambia a tienda con transición si son zonas distintas. |
| Museo | Entrada ↔ salas. Salas contiguas pueden compartir escena; transición solo si una ampliación se separa en otra zona. No fija desbloqueos. |
| Casa del alquimista | Entrada ↔ vivienda/laboratorio. Invernadero conectado puede compartir escena; no transición adicional si forma parte del mismo espacio. |
| Herrería y vivienda | Entradas respectivas ↔ interior común con forja y ala doméstica. Caminar por su puerta interna sin pantalla negra. Parte abierta del porche/forja exterior permanece en exterior si así se monta. |
| Choza del pescador | Puerta ↔ interior de la choza. Patio, puesto de pesca, muelle y cobertizo abierto de cocina se cruzan andando en exterior, sin negro. |
| Mina | Boca ↔ primera galería. Portales entre sectores solo si el nivel se divide; número de sectores no decidido. |
| Barco | Cubierta sin interior inicial. Después de la mejora: escotilla ↔ interior; al volver usar ancla local a la cubierta y transformarla a posición actual del barco, no coordenada fija de isla. No implementa la mejora. |

Un tejado no implica un interior independiente: la distinción es espacio cerrado separado frente a cobertura exterior transitable. La ilustración «interior del cobertizo» sirve para colocar muebles, no obliga a cambiar de mapa.

## Arquitectura para Godot

Mantener una escena raíz persistente (jugador, cámara, UI, inventario y estado de partida) y un contenedor para la zona activa. Sustituir la zona, no recargar `main.tscn` para entrar. La implementación actual crea terreno/objetos en `main.gd`, y `house.gd` contiene dibujo, colisión y marcador sin entrada funcional: habrá que separar creación de zona de estado de partida. Este documento no realiza esa refactorización.

Cada portal usa un identificador estable, destino de zona, identificador del punto de llegada y orientación de llegada. Una misma zona puede tener varias entradas. `Marker2D` registra apoyos seguros; `Area2D` detecta candidatos y un único gestor ejecuta la transición. Portales y puntos se validan antes del fundido. La posición de llegada debe tener margen suficiente respecto a pared y activador; no desplazar al jugador dentro de una colisión para corregirlo después.

Secuencia propuesta:

1. Comprobar alcance, condiciones y destino; aceptar solo una solicitud. Rechazar entradas bloqueadas con explicación breve antes de oscurecer.
2. Cancelar acción actual mediante una ruta común: minería, tala, pesca y recolección; retirar sedal/equipo temporal/objetivo y eventos tardíos. No conceder botín al cancelar. Conservación del daño ya aplicado sigue el acuerdo que se defina, no se decide aquí.
3. Bloquear movimiento/interacciones, poner velocidad a cero y cerrar overlays que interfieran. El fundido debe poder ejecutarse aunque la simulación esté pausada. Durante la transición no avanza la simulación; se conservan tiempos restantes, sin eventos accidentales en negro.
4. Iniciar/completar carga, oscurecer; registrar estado de la zona saliente. Preparar nueva instancia sin que ambas zonas simulen simultáneamente.
5. Restaurar estado del destino, trasladar jugador persistente al punto seguro y fijar cámara/límites antes del primer fotograma visible.
6. Aclarar; permitir controles al acabar. Consumir la pulsación que inició la transición; hace falta soltar E antes de otra activación y abandonar el activador de llegada para evitar rebote entrada/salida. Movimiento mantenido puede continuar al devolver control sin volver a disparar portal.

Si falla carga o falta un punto: conservar/restituir zona y posición anteriores, aclarar y desbloquear controles con mensaje breve. Nunca dejar pantalla negra o jugador inmóvil. Validación de puntos antes de descargar origen; referencias del origen solo se liberan tras confirmar llegada segura.

## Estado y rendimiento

El cambio de zona no reinicia cultivos, cofres, recursos, botín, NPC, desbloqueos ni inventario. Separar esos datos de los nodos y usar identificadores estables. Conservar también tiempos restantes del botín y del trabajo; no dar un plazo nuevo al regresar. Los estados/timers de zonas inactivas deben avanzar según el reloj activo de la partida cuando corresponda, no por mantener nodos procesándose. Pausa, transición y ausencia no avanzan ese reloj. Reaparición/regeneración todavía necesita sus reglas de diseño; entrar/salir no debe servir para reaparecer recursos inmediatamente.

Cargar solamente la zona activa. Al acercarse a una puerta candidata, precargar su `PackedScene` en segundo plano y compartir texturas/atlas reutilizados. En Godot usar `ResourceLoader.load_threaded_request`, consultar estado por fotograma y obtener recurso cuando esté listo; no hacer esperas bloqueantes en el hilo principal. Instanciar y añadir nodos de forma segura en el hilo principal. Una precarga no debe activar cultivos, NPC o física de un interior invisible.

Caché pequeña de recursos próximos/última zona con límite de memoria, no todas las viviendas y minas cargadas. Tamaño del límite pendiente de medición. La corrección del estado no depende de la caché; una zona puede descargarse y restaurarse. Cancelar/ignorar precargas obsoletas, evitar duplicarlas y liberar referencias al salir del presupuesto. Portal usa detección por área/proximidad, sin barrer todos los edificios cada fotograma.

Reutilizar muebles, suelos y materiales; interior y exterior son escenas distintas porque el suelo útil puede ser mayor, sin exigir que su huella coincida píxel a píxel. Fundido dibujado con un `ColorRect` en `CanvasLayer` persistente. No incluirlo dentro de la zona que se descarga.

## Validación antes de integrar todos los edificios

Primero implementar casa del jugador como caso pequeño y comprobar ida/vuelta por la misma puerta, llegada sin colisiones, pulsaciones rápidas, movimiento mantenido, fallo de carga y cámara sin salto visible. Después probar vivienda de pareja con dos accesos y exterior abierto del pescador; aplicar el mismo mecanismo al resto.

Verificar cancelación durante golpe y picada sin entrega duplicada, conservación de cultivo/cofre/botín y sus tiempos al entrar/salir, pausa durante transición, regresar desde otra entrada y límites de cámara. Medir picos de fotograma y memoria en transiciones frías/calientes, con repetidas visitas y exportación web; sin cifras de FPS inventadas. Mantener una prueba de estado y entrada múltiple útil en vez de duplicar tests por cada fachada.
