class_name BituPlayer
extends CharacterBody2D

const SPEED := 150.0
const TOOL := preload("res://assets/herramientas/pico-hacha/pico-hacha-hierro.tscn")
const HERBAL_TOOL := preload("res://assets/herramientas/palin-herborista/palin-herborista.tscn")
const DRAGON_VISUAL := preload("res://scripts/dragon_visual.gd")
signal work_impact(function: StringName)
signal work_finished
var busy := false
var equipment_enabled := false
var work_kind: StringName = &""
var tool_mount: Node2D
var tool: Node2D
var primary_hand: Sprite2D
var secondary_hand: Sprite2D
var dragon: BituDragonVisual
var herbal_mount: Node2D
var herbal_tool: Node2D
var gathering := false
var kneel_amount := 0.0
var posture: Tween
var plant_contact := Vector2.ZERO
var facing := 1
var facing_back := false
var walk_time := 0.0

func _ready() -> void:
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 7.0
	collision.shape = shape
	collision.position = Vector2(0, -3)
	add_child(collision)
	dragon = DRAGON_VISUAL.new()
	add_child(dragon)
	primary_hand = dragon.primary_hand
	secondary_hand = dragon.secondary_hand
	if equipment_enabled:
		tool_mount = Node2D.new()
		add_child(tool_mount)
		tool = TOOL.instantiate()
		tool_mount.add_child(tool)
		tool.impact.connect(func(action: StringName): work_impact.emit(action))
		tool.work_finished.connect(func(): work_finished.emit())
		herbal_mount = Node2D.new()
		add_child(herbal_mount)
		herbal_tool = HERBAL_TOOL.instantiate()
		herbal_mount.add_child(herbal_tool)
		herbal_tool.impact.connect(func(action: StringName): work_impact.emit(action))
		herbal_tool.work_finished.connect(func(): work_finished.emit())
		end_work()
	# Manos delante de los mangos, sin elevar el personaje sobre los árboles.
	primary_hand.reparent(self)
	secondary_hand.reparent(self)
	dragon.pose(0,facing,facing_back,walk_time,kneel_amount,equipment_enabled,false,false)

func begin_work(action: StringName, contact: Vector2) -> void:
	busy = true
	work_kind = action
	var local_contact := to_local(contact)
	facing = 1 if local_contact.x >= 0 else -1
	facing_back = local_contact.y < -12
	tool_mount.visible = true
	tool_mount.scale = Vector2(-facing if action == &"minar" else facing,1)
	tool_mount.position = Vector2(facing*12,-32)
	var expected: Vector2 = tool.impact_vector(action)*tool_mount.scale
	var direction := local_contact-tool_mount.position
	if direction.length() > 0:
		tool_mount.position += direction.normalized()*clampf(direction.length()-expected.length(),-8,8)
		tool_mount.rotation = direction.angle()-expected.angle()
	tool.play_work(action)

func repeat_work() -> void:
	tool.play_work(work_kind)

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
		tool_mount.position = Vector2(facing*21,-27)
		tool_mount.rotation = 0
		tool_mount.scale = Vector2(facing,1)
		secondary_hand.visible = false

func begin_gathering(contact: Vector2) -> void:
	busy = true
	work_kind = &""
	gathering = true
	plant_contact = to_local(contact)
	facing = 1 if plant_contact.x >= 0 else -1
	facing_back = plant_contact.y < -12
	if tool_mount != null:
		tool_mount.visible = false
		herbal_mount.visible = true
		herbal_mount.scale = Vector2(facing,1)
		var expected: Vector2 = herbal_tool.contact_vector()*herbal_mount.scale
		var direction := plant_contact-Vector2(facing*15,-17)
		if direction.is_zero_approx():
			direction = Vector2(facing,1)
		herbal_mount.position = plant_contact-direction.normalized()*expected.length()
		herbal_mount.rotation = direction.angle()-expected.angle()
		posture = create_tween()
		posture.tween_property(self,"kneel_amount",1.0,0.25)
		posture.tween_interval(1.45)
		posture.tween_property(self,"kneel_amount",0.0,0.30)
		herbal_tool.play_work()

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED if not busy else Vector2.ZERO
	if not busy and absf(direction.x) > 0.1:
		facing = 1 if direction.x > 0 else -1
	if not busy and direction.length() > 0:
		facing_back = direction.y < -0.1
	if velocity.length() > 0:
		walk_time += delta * 9
	else:
		walk_time = 0
	move_and_slide()

func _process(delta: float) -> void:
	# Herramientas en el paso de física; agarres después, en el fotograma visible.
	animate_pose(delta)

func animate_pose(delta: float) -> void:
	# Compartida por el juego y la revisión de animaciones, sin mover al actor.
	if tool_mount != null:
		if not busy:
			tool_mount.position = Vector2(facing*21,-27+roundf(absf(sin(walk_time))*1.5))
			tool_mount.scale.x = facing
			tool_mount.rotation = deg_to_rad(sin(walk_time)*3)
		primary_hand.visible = tool_mount.visible or gathering
		primary_hand.position = to_local(herbal_tool.global_position).round() if gathering else tool_mount.position.round()
		secondary_hand.visible = work_kind != &"" or gathering
		if gathering:
			secondary_hand.position = Vector2(facing*18,-26).lerp(plant_contact+Vector2(0,-17),kneel_amount).round()
		elif secondary_hand.visible:
			secondary_hand.position = to_local(tool.to_global(Vector2(0,-13.125))).round()
	dragon.pose(delta,facing,facing_back,walk_time,kneel_amount,equipment_enabled,work_kind != &"",gathering)
