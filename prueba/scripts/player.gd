class_name BituPlayer
extends CharacterBody2D

const SPEED := 150.0
const SPRINT_SPEED := 225.0
const TOOL := preload("res://assets/herramientas/pico-hacha/pico-hacha-hierro.tscn")
const HERBAL_TOOL := preload("res://assets/herramientas/palin-herborista/palin-herborista.tscn")
const DRAGON_VISUAL := preload("res://scripts/dragon_visual.gd")
const DIRECTIONS := [Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1),Vector2.RIGHT,Vector2(1,1)]
# Profile views are deliberately kept diagonally downward.  The old ±70°
# values made the vertical profile atlas look almost horizontal in the hands.
const CARRY_ANGLES := [-48.0,-52.0,-38.0,-55.0,55.0,55.0,38.0,48.0]
const WALK_POSES := ["andar-a","paso-a","andar-b","paso-b"]
const TOOL_SCALE := 0.72
signal work_impact(function: StringName)
signal work_finished
var busy := false
var equipment_enabled := false
var work_kind: StringName = &""
var tool_mount: Node2D
var tool: Node2D
var primary_hand: Node2D
var secondary_hand: Node2D
var dragon: BituDragonVisual
var herbal_mount: Node2D
var herbal_tool: Node2D
var gathering := false
var kneel_amount := 0.0
var posture: Tween
var plant_contact := Vector2.ZERO
var work_contact := Vector2.ZERO
var facing := 1
var facing_back := false
var direction_index := 0
var walk_time := 0.0
var tool_side := 1.0
var work_stance := Vector2.ZERO
var impact_grip := 0

func _ready() -> void:
	if not InputMap.has_action("sprint"):
		InputMap.add_action("sprint")
		var sprint_key := InputEventKey.new()
		sprint_key.physical_keycode = KEY_SHIFT
		InputMap.action_add_event("sprint",sprint_key)
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 7.0
	collision.shape = shape
	collision.position = Vector2(0,-3)
	add_child(collision)
	if equipment_enabled:
		tool_mount = Node2D.new()
		add_child(tool_mount)
		tool = TOOL.instantiate()
		tool.externally_posed = true
		tool_mount.add_child(tool)
		tool.impact.connect(func(action: StringName):
			animate_pose(0,0.33)
			work_impact.emit(action)
		)
		tool.work_finished.connect(func(): work_finished.emit())
		herbal_mount = Node2D.new()
		add_child(herbal_mount)
		herbal_tool = HERBAL_TOOL.instantiate()
		herbal_tool.externally_posed = true
		herbal_mount.add_child(herbal_tool)
		herbal_tool.impact.connect(func(action: StringName): work_impact.emit(action))
		herbal_tool.work_finished.connect(func(): work_finished.emit())
	# Capas locales, sin alterar el y-sort del personaje frente al mundo.
	dragon = DRAGON_VISUAL.new()
	add_child(dragon)
	primary_hand = Node2D.new()
	secondary_hand = Node2D.new()
	add_child(primary_hand)
	add_child(secondary_hand)
	dragon.hand_cover.reparent(self)
	dragon.other_hand_cover.reparent(self)
	end_work()

func face_towards(direction: Vector2) -> void:
	if direction.is_zero_approx():
		return
	direction_index = posmod(roundi((direction.angle()-PI/2)/(PI/4)),8)
	facing = -1 if DIRECTIONS[direction_index].x < 0 else 1
	facing_back = direction_index >= 3 and direction_index <= 5

func begin_work(action: StringName, contact: Vector2, ground_target := Vector2.INF) -> void:
	if tool == null or busy:
		return
	face_towards(to_local(contact if ground_target == Vector2.INF else ground_target))
	busy = true
	gathering = false
	work_kind = action
	work_contact = to_local(contact)
	tool_mount.visible = true
	herbal_mount.visible = false
	# Elegir el extremo una vez por extracción, sin invertirlo entre poses.
	dragon.show_pose("golpe",direction_index)
	tool.set_direction(direction_index)
	# Resolver el apoyo con las palmas del dibujo de impacto. El mango queda
	# sobre ambas manos; nunca se corrige su ángulo para perseguir el recurso.
	var best_distance := INF
	for grip in range(2):
		var hand := dragon.primary_hand.position if grip == 0 else dragon.secondary_hand.position
		var upper := dragon.secondary_hand.position if grip == 0 else dragon.primary_hand.position
		var angle := (upper-hand).angle()+PI/2
		for side in [1.0,-1.0]:
			var tip: Vector2 = tool.contact_offset(action)*TOOL_SCALE
			tip.x *= side
			var stance := work_contact-hand-tip.rotated(angle)
			if stance.length_squared() < best_distance:
				best_distance = stance.length_squared()
				impact_grip = grip
				tool_side = side
				work_stance = stance
	tool.play_work(action)
	animate_pose(0)

func repeat_work() -> void:
	tool.play_work(work_kind)
	animate_pose(0)

func end_work() -> void:
	busy = false
	work_kind = &""
	gathering = false
	if posture != null and posture.is_valid():
		posture.kill()
	kneel_amount = 0
	if herbal_mount != null:
		herbal_mount.visible = false
		herbal_tool.reset_pose()
	if tool_mount != null:
		tool.reset_pose()
		tool_mount.visible = true
	animate_pose(0)

func begin_gathering(contact: Vector2, ground_target := Vector2.INF) -> void:
	if herbal_tool == null or busy:
		return
	face_towards(to_local(contact if ground_target == Vector2.INF else ground_target))
	busy = true
	work_kind = &""
	gathering = true
	plant_contact = to_local(contact)
	tool_mount.visible = false
	herbal_mount.visible = true
	posture = create_tween()
	posture.tween_property(self,"kneel_amount",1.0,0.25)
	posture.tween_interval(1.45)
	posture.tween_property(self,"kneel_amount",0.0,0.30)
	herbal_tool.play_work()
	animate_pose(0)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	var sprinting := not busy and Input.is_action_pressed("sprint")
	var speed := SPRINT_SPEED if sprinting else SPEED
	velocity = direction*speed if not busy else Vector2.ZERO
	var previous := position
	move_and_slide()
	var travel := position-previous
	if not busy and travel.length() > 0.001:
		face_towards(travel)
		walk_time += travel.length()*0.06
	else:
		walk_time = 0.0
		if not busy:
			face_towards(direction)

func _process(delta: float) -> void:
	animate_pose(delta)

func animate_pose(_delta: float, work_time := -1.0) -> void:
	if dragon == null:
		return
	var pose := "reposo"
	var elapsed := 0.0
	if gathering:
		elapsed = herbal_tool.motion.get_total_elapsed_time() if herbal_tool.motion != null else 0.0
		if elapsed >= 0.20 and elapsed < 1.90:
			pose = "arrodillado" if elapsed < 1.68 else "levantar"
	elif busy and work_kind != &"":
		elapsed = work_time if work_time >= 0 else (tool.motion.get_total_elapsed_time() if tool.motion != null else 0.0)
		if elapsed < 0.12 or (elapsed >= 0.40 and elapsed < 0.53):
			pose = "medio"
		elif elapsed < 0.28:
			pose = "cargar" if work_kind == &"minar" else "medio"
		elif elapsed < 0.40:
			pose = "golpe"
	elif walk_time > 0:
		pose = WALK_POSES[int(walk_time/1.15)%4]
	dragon.show_pose(pose,direction_index)
	dragon.position = Vector2.ZERO
	if busy and not gathering:
		# Entrar y salir del apoyo sin desplazar la colisión del personaje.
		var support := smoothstep(0.0,0.12,elapsed)*(1.0-smoothstep(0.40,0.62,elapsed))
		dragon.position = work_stance*support
		# Tala: cargar el peso lateralmente, sin levantar el pico sobre la cabeza.
		if work_kind == &"talar" and elapsed < 0.28:
			var side := Vector2(DIRECTIONS[direction_index].y,-DIRECTIONS[direction_index].x).normalized()
			dragon.position += side*sin(clampf(elapsed/0.28,0,1)*PI)*4.0
	# Pequeño cambio de apoyo al agacharse: mantener el tamaño del palín.
	# La posición física del jugador y el alcance de interacción no cambian.
	if gathering and pose != "reposo":
		herbal_tool.set_direction(direction_index)
		var tip_length: float = herbal_tool.tip_offset().length()
		var reach: Vector2 = plant_contact-dragon.primary_hand.position
		var held_scale := clampf(reach.length()/tip_length,0.65,0.95)
		dragon.position = reach.normalized()*(reach.length()-tip_length*held_scale)
	primary_hand.position = dragon.position+dragon.primary_hand.position
	secondary_hand.position = dragon.position+dragon.secondary_hand.position
	# El recorte de dedos pertenece a la palma fuente aunque cambien los
	# papeles de las manos (inferior/superior) durante el golpe.
	dragon.hand_cover.position = dragon.position+dragon.primary_hand.position+dragon.cover_offset
	dragon.other_hand_cover.position = dragon.position+dragon.secondary_hand.position+dragon.other_cover_offset
	if busy and not gathering and pose == "golpe" and impact_grip == 1:
		var swap := primary_hand.position
		primary_hand.position = secondary_hand.position
		secondary_hand.position = swap
	if not equipment_enabled:
		dragon.hand_cover.visible = false
		dragon.other_hand_cover.visible = false
		return
	tool.set_direction(direction_index)
	herbal_tool.set_direction(direction_index)
	var mount := herbal_mount if gathering else tool_mount
	var layer := dragon.get_index()+(0 if dragon.tool_behind else 1)
	if mount.get_index() < dragon.get_index():
		layer -= 1
	if mount.get_index() != layer:
		move_child(mount,layer)
	if dragon.hand_cover.get_index() != get_child_count()-1:
		move_child(dragon.hand_cover,get_child_count()-1)
	dragon.other_hand_cover.visible = busy and not gathering and pose != "reposo" and dragon.hand_cover.visible
	move_child(dragon.other_hand_cover,get_child_count()-1)
	if gathering:
		herbal_mount.position = primary_hand.position
		var tip: Vector2 = herbal_tool.tip_offset()
		var reach := plant_contact-primary_hand.position
		herbal_mount.scale = Vector2.ONE*reach.length()/tip.length()
		herbal_mount.rotation = reach.angle()-tip.angle()
		# Paladas cortas desde la muñeca. El contacto queda fijo al extraer (1,5 s).
		if elapsed > 0.25 and elapsed < 1.30:
			herbal_mount.rotation += deg_to_rad(sin(elapsed*18)*6)
		elif elapsed >= 1.68:
			herbal_mount.rotation -= deg_to_rad(12)
	else:
		tool_mount.position = primary_hand.position
		# The atlas is authored at one tool size.  Mirroring chooses the nearer
		# end for the action; it never changes the scale of the tool.
		tool_mount.scale = Vector2(tool_side if busy and pose != "reposo" else 1.0,1)*TOOL_SCALE
		if busy and pose != "reposo":
			# El eje del mango pasa por las dos palmas del fotograma completo.
			# No hay tween de rotación ni giro independiente sobre la muñeca.
			tool_mount.rotation = (secondary_hand.position-primary_hand.position).angle()+PI/2
		else:
			tool_mount.rotation = deg_to_rad(CARRY_ANGLES[direction_index])
