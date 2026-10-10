class_name BituPlayer
extends CharacterBody2D

const SPEED := 150.0
const SPRINT_SPEED := 225.0
const TOOL := preload("res://assets/herramientas/pico-hacha/pico-hacha-hierro.tscn")
const HERBAL_TOOL := preload("res://assets/herramientas/palin-herborista/palin-herborista.tscn")
const DRAGON_VISUAL := preload("res://scripts/dragon_visual.gd")
const DIRECTIONS := [Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1),Vector2.RIGHT,Vector2(1,1)]
const WALK_POSES := ["andar-a","paso-a","andar-b","paso-b"]
const RUN_POSES := ["sprint-a","sprint-paso-a","sprint-b","sprint-paso-b"]
const TOOL_SCALE := 0.64
signal work_impact(function: StringName)
signal work_finished
signal work_cancelled
signal attack_impact(direction: Vector2)
signal attack_finished
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
var sprinting := false
var work_stance := Vector2.ZERO
var repeat_stance := false
var recovery_offset := Vector2.ZERO
var stance_return: Tween
var approaching := false
var approach_target := Vector2.ZERO
var approach_time := 0.0
var activity := ""
var activity_time := 0.0
var fishing_pose := "pesca-cargar"
var attack_hit := false

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
	if tool != null:
		tool.pose_contact = dragon
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
	if tool == null or busy or not tool.supports_action(action):
		return
	face_towards(to_local(contact if ground_target == Vector2.INF else ground_target))
	busy = true
	gathering = false
	work_kind = action
	work_contact = to_local(contact)
	tool_mount.visible = true
	herbal_mount.visible = false
	if stance_return != null and stance_return.is_valid():
		stance_return.kill()
	recovery_offset = Vector2.ZERO
	repeat_stance = false
	# El contacto procede del extremo dibujado en el mismo PNG que el cuerpo.
	dragon.show_pose("golpe-talar" if action == &"talar" else "golpe",direction_index)
	tool.set_direction(direction_index)
	work_stance = work_contact-dragon.contact_local(action)
	# El apoyo pertenece al cuerpo físico: caminar hasta él antes del golpe.
	# Evita deslizar solo el dibujo sobre una colisión inmóvil.
	approach_target = global_position+work_stance
	approach_time = 0.0
	approaching = work_stance.length() > 2.0
	if not approaching:
		tool.play_work(action)
	animate_pose(0)

func repeat_work() -> void:
	repeat_stance = true
	tool.play_work(work_kind)
	animate_pose(0)

func end_work() -> void:
	approaching = false
	activity = ""
	activity_time = 0.0
	if stance_return != null and stance_return.is_valid():
		stance_return.kill()
	recovery_offset = Vector2.ZERO
	if not recovery_offset.is_zero_approx():
		stance_return = create_tween()
		stance_return.tween_property(self,"recovery_offset",Vector2.ZERO,0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
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

func begin_attack(aim: Vector2) -> bool:
	if busy:
		return false
	face_towards(aim-global_position)
	busy = true
	activity = "zarpazo"
	activity_time = 0.0
	attack_hit = false
	walk_time = 0.0
	animate_pose(0)
	return true

func begin_fishing(point: Vector2) -> bool:
	if busy:
		return false
	face_towards(point-global_position)
	busy = true
	activity = "pesca"
	activity_time = 0.0
	fishing_pose = "pesca-cargar"
	walk_time = 0.0
	animate_pose(0)
	return true

func set_fishing_pose(pose: String) -> void:
	fishing_pose = pose
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

func _physics_process(delta: float) -> void:
	if approaching:
		approach_time += delta
		var remaining := approach_target-global_position
		if remaining.length() <= 2.0:
			approaching = false
			work_contact -= global_position-(approach_target-work_stance)
			work_stance = Vector2.ZERO
			walk_time = 0.0
			velocity = Vector2.ZERO
			tool.play_work(work_kind)
			return
		velocity = remaining.normalized()*minf(SPEED,remaining.length()/delta)
		var previous := position
		move_and_slide()
		walk_time += position.distance_to(previous)*0.06
		if approach_time > 1.2:
			end_work()
			work_cancelled.emit()
		return
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	sprinting = not busy and Input.is_action_pressed("sprint")
	var speed := SPRINT_SPEED if sprinting else SPEED
	velocity = direction*speed if not busy else Vector2.ZERO
	var previous := position
	move_and_slide()
	var travel := position-previous
	if not busy and travel.length() > 0.001:
		if not recovery_offset.is_zero_approx():
			if stance_return != null and stance_return.is_valid():
				stance_return.kill()
			recovery_offset = Vector2.ZERO
		face_towards(travel)
		walk_time += travel.length()*0.06
	else:
		walk_time = 0.0
		if not busy:
			face_towards(direction)

func _process(delta: float) -> void:
	if activity == "zarpazo":
		activity_time += delta
		if activity_time >= 0.22 and not attack_hit:
			attack_hit = true
			animate_pose(0)
			attack_impact.emit(DIRECTIONS[direction_index].normalized())
		if activity_time >= 0.50:
			end_work()
			attack_finished.emit()
	animate_pose(delta)

func animate_pose(_delta: float, work_time := -1.0) -> void:
	if dragon == null:
		return
	var pose := "reposo"
	var elapsed := 0.0
	if activity == "zarpazo":
		pose = ["zarpazo-cargar","zarpazo-golpe","zarpazo-seguir","zarpazo-recuperar"][0 if activity_time < 0.18 else (1 if activity_time < 0.28 else (2 if activity_time < 0.38 else 3))]
	elif activity == "pesca":
		pose = fishing_pose
	elif approaching:
		pose = WALK_POSES[int(walk_time/1.15)%4]
	elif gathering:
		elapsed = herbal_tool.motion.get_total_elapsed_time() if herbal_tool.motion != null else 0.0
		if elapsed >= 0.20 and elapsed < 1.90:
			pose = "arrodillado" if elapsed < 1.68 else "levantar"
	elif busy and work_kind != &"":
		elapsed = work_time if work_time >= 0 else (tool.motion.get_total_elapsed_time() if tool.motion != null else 0.0)
		if elapsed < 0.12:
			pose = "medio-talar" if work_kind == &"talar" else "medio"
		elif elapsed < 0.28:
			pose = "cargar" if work_kind == &"minar" else "cargar-talar"
		elif elapsed < 0.40:
			pose = "golpe-talar" if work_kind == &"talar" else "golpe"
		else:
			pose = "recuperar-talar" if work_kind == &"talar" else "recuperar"
	elif walk_time > 0:
		pose = (RUN_POSES if sprinting else WALK_POSES)[int(walk_time/1.15)%4]
	if pose == "reposo" and (gathering or not equipment_enabled):
		pose = "sin-equipo"
	dragon.show_pose(pose,direction_index)
	dragon.position = recovery_offset
	if busy and not gathering and not approaching and work_kind != &"":
		# Solo el error residual del último paso (máximo 2px), sin saltos.
		var registered := dragon.contact_local(work_kind)
		if registered.is_finite():
			dragon.position = work_contact-registered
	# Pequeño cambio de apoyo al agacharse: mantener el tamaño del palín.
	# La posición física del jugador y el alcance de interacción no cambian.
	if gathering and pose not in ["reposo","sin-equipo"]:
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
	if not equipment_enabled:
		dragon.hand_cover.visible = false
		dragon.other_hand_cover.visible = false
		return
	tool.visible = gathering and not dragon.has_baked_tool()
	tool_mount.visible = busy and work_kind != &"" and not approaching
	herbal_mount.visible = gathering
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
		# El PNG equipado incluye herramienta y dedos: el nodo conserva solo
		# el reloj y las señales, sin dibujar una segunda herramienta encima.
		tool_mount.position = primary_hand.position
		tool_mount.scale = Vector2.ONE*TOOL_SCALE
		tool_mount.rotation = 0.0
