class_name BituPlayer
extends CharacterBody2D

const SPEED := 150.0
const TOOL := preload("res://assets/herramientas/pico-hacha/pico-hacha-hierro.tscn")
const HERBAL_TOOL := preload("res://assets/herramientas/palin-herborista/palin-herborista.tscn")
const DRAGON_VISUAL := preload("res://scripts/dragon_visual.gd")
const DIRECTIONS := [Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1),Vector2.RIGHT,Vector2(1,1)]
const CARRY_ANGLES := [-35.0,-40.0,-55.0,-40.0,35.0,40.0,55.0,40.0]
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
var work_scale := TOOL_SCALE

func _ready() -> void:
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
		tool.impact.connect(func(action: StringName): work_impact.emit(action))
		tool.work_finished.connect(func(): work_finished.emit())
		herbal_mount = Node2D.new()
		add_child(herbal_mount)
		herbal_tool = HERBAL_TOOL.instantiate()
		herbal_tool.externally_posed = true
		herbal_mount.add_child(herbal_tool)
		herbal_tool.impact.connect(func(action: StringName): work_impact.emit(action))
		herbal_tool.work_finished.connect(func(): work_finished.emit())
	# Los dedos y el cuerpo ocluyen los mangos. Todo con z=0 para el y-sort.
	dragon = DRAGON_VISUAL.new()
	add_child(dragon)
	primary_hand = Node2D.new()
	secondary_hand = Node2D.new()
	add_child(primary_hand)
	add_child(secondary_hand)
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
	var hand := dragon.primary_hand.position
	var angle := (dragon.secondary_hand.position-hand).angle()+PI/2
	var tip: Vector2 = (tool.CONTACTS[String(action)]-tool.SOURCE_GRIP)*tool.SOURCE_SCALE*TOOL_SCALE
	tool_side = 1.0 if (hand+tip.rotated(angle)).distance_to(work_contact) <= (hand+Vector2(-tip.x,tip.y).rotated(angle)).distance_to(work_contact) else -1.0
	var reach := work_contact-hand
	work_stance = (reach.normalized()*(reach.length()-tip.length())).limit_length(18)
	work_scale = (work_contact-hand-work_stance).length()/(tip.length()/TOOL_SCALE)
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

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction*SPEED if not busy else Vector2.ZERO
	if not busy and not direction.is_zero_approx():
		face_towards(direction)
	walk_time = walk_time+delta*9 if velocity.length()>0 else 0.0
	move_and_slide()

func _process(delta: float) -> void:
	animate_pose(delta)

func animate_pose(_delta: float) -> void:
	if dragon == null:
		return
	var pose := "reposo"
	var elapsed := 0.0
	if gathering:
		elapsed = herbal_tool.motion.get_total_elapsed_time() if herbal_tool.motion != null else 0.0
		if elapsed >= 0.20 and elapsed < 1.90:
			pose = "arrodillado" if elapsed < 1.68 else "levantar"
	elif busy and work_kind != &"":
		elapsed = tool.motion.get_total_elapsed_time() if tool.motion != null else 0.0
		if elapsed < 0.12 or (elapsed >= 0.40 and elapsed < 0.53):
			pose = "medio"
		elif elapsed < 0.28:
			pose = "cargar"
		elif elapsed < 0.40:
			pose = "golpe"
	elif walk_time > 0:
		pose = ["andar-a","paso","andar-b","paso"][int(walk_time/1.15)%4]
	dragon.show_pose(pose,direction_index)
	dragon.position = work_stance if busy and not gathering else Vector2.ZERO
	# Pequeño cambio de apoyo al agacharse: mantener el tamaño del palín.
	# La posición física del jugador y el alcance de interacción no cambian.
	if gathering and pose != "reposo":
		var tip_length: float = ((herbal_tool.SOURCE_TIP-herbal_tool.SOURCE_GRIP)*herbal_tool.SOURCE_SCALE).length()
		var reach: Vector2 = plant_contact-dragon.primary_hand.position
		var held_scale := clampf(reach.length()/tip_length,0.65,0.95)
		dragon.position = reach.normalized()*(reach.length()-tip_length*held_scale)
	primary_hand.position = dragon.position+dragon.primary_hand.position
	secondary_hand.position = dragon.position+dragon.secondary_hand.position
	if not equipment_enabled:
		return
	if gathering:
		herbal_mount.position = primary_hand.position
		var tip: Vector2 = (herbal_tool.SOURCE_TIP-herbal_tool.SOURCE_GRIP)*herbal_tool.SOURCE_SCALE
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
		tool_mount.scale = Vector2(tool_side if busy else 1.0,1)*(work_scale if busy else TOOL_SCALE)
		if busy:
			if pose == "golpe":
				var tip: Vector2 = (tool.CONTACTS[String(work_kind)]-tool.SOURCE_GRIP)*tool.SOURCE_SCALE
				tip.x *= tool_side
				tool_mount.rotation = (work_contact-primary_hand.position).angle()-tip.angle()
			else:
				tool_mount.rotation = (secondary_hand.position-primary_hand.position).angle()+PI/2
		else:
			tool_mount.rotation = deg_to_rad(CARRY_ANGLES[direction_index])
