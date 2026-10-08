class_name BituPlayer
extends CharacterBody2D

const SPEED := 150.0
const TOOL := preload("res://assets/herramientas/pico-hacha/pico-hacha-hierro.tscn")
const HERBAL_TOOL := preload("res://assets/herramientas/palin-herborista/palin-herborista.tscn")
signal work_impact(function: StringName)
signal work_finished
var busy := false
var equipment_enabled := false
var work_kind: StringName = &""
var tool_mount: Node2D
var tool: Node2D
var primary_hand: Polygon2D
var secondary_hand: Polygon2D
var herbal_mount: Node2D
var herbal_tool: Node2D
var gathering := false
var kneel_amount := 0.0
var posture: Tween
var plant_contact := Vector2.ZERO
var facing := 1
var walk_time := 0.0

func _ready() -> void:
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 7.0
	collision.shape = shape
	collision.position = Vector2(0, -3)
	add_child(collision)
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
		primary_hand = _hand()
		secondary_hand = _hand()
		add_child(primary_hand)
		add_child(secondary_hand)
		end_work()

func _hand() -> Polygon2D:
	var hand := Polygon2D.new()
	hand.polygon = PackedVector2Array([Vector2(-3,-4),Vector2(3,-4),Vector2(3,4),Vector2(-3,4)])
	hand.color = Color("c69b72")
	return hand

func begin_work(action: StringName, contact: Vector2) -> void:
	busy = true
	work_kind = action
	facing = 1 if contact.x >= global_position.x else -1
	tool_mount.visible = true
	tool_mount.scale = Vector2(-facing if action == &"minar" else facing,1)
	tool_mount.position = Vector2(facing*12,-32)
	var expected: Vector2 = tool.impact_vector(action)*tool_mount.scale
	var direction := contact-global_position-tool_mount.position
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
		tool_mount.position = Vector2(facing*17,-25)
		tool_mount.rotation = 0
		tool_mount.scale = Vector2(facing,1)
		secondary_hand.visible = false

func begin_gathering(contact: Vector2) -> void:
	busy = true
	work_kind = &""
	gathering = true
	plant_contact = to_local(contact)
	facing = 1 if plant_contact.x >= 0 else -1
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
	if velocity.length() > 0:
		walk_time += delta * 9
	else:
		walk_time = 0
	move_and_slide()
	if tool_mount != null:
		if not busy:
			tool_mount.position = Vector2(facing*17,-25)
			tool_mount.scale.x = facing
		primary_hand.visible = tool_mount.visible or gathering
		primary_hand.position = to_local(herbal_tool.global_position).round() if gathering else tool_mount.position.round()
		secondary_hand.visible = work_kind != &"" or gathering
		if gathering:
			secondary_hand.position = Vector2(facing*18,-26).lerp(plant_contact+Vector2(0,-17),kneel_amount).round()
		elif secondary_hand.visible:
			secondary_hand.position = to_local(tool.to_global(Vector2(0,-13.125))).round()
	queue_redraw()

func _draw() -> void:
	var stride := roundf(sin(walk_time) * 3)
	draw_rect(Rect2(-14, -4, 28, 7), Color(0.04, 0.08, 0.05, 0.35))
	if kneel_amount > 0.5:
		draw_rect(Rect2(-19,-13,32,11),Color("343a34"))
		draw_rect(Rect2(facing*12-6,-9,13,9),Color("434a3e"))
		draw_rect(Rect2(-facing*21-6,-5,14,6),Color("332a25"))
	else:
		draw_rect(Rect2(-12, -20 + stride, 9, 20), Color("343a34"))
		draw_rect(Rect2(3, -20 - stride, 9, 20), Color("343a34"))
		draw_rect(Rect2(-14, -6 + stride, 12, 6), Color("332a25"))
		draw_rect(Rect2(2, -6 - stride, 13, 6), Color("332a25"))
	var body_offset := Vector2(roundf(facing*5*kneel_amount),roundf(20*kneel_amount))
	draw_set_transform(body_offset)
	draw_rect(Rect2(-15, -53, 30, 34), Color("87643e"))
	draw_rect(Rect2(-15, -53, 7, 32), Color("b79258"))
	draw_rect(Rect2(8, -51, 7, 30), Color("624c36"))
	draw_rect(Rect2(-16, -25, 32, 5), Color("3c3430"))
	draw_rect(Rect2(-3, -25, 7, 5), Color("cfb46b"))
	if work_kind != &"" or gathering:
		_draw_arm(Vector2(facing*14,-48),primary_hand.position-body_offset,Color("715536"))
		_draw_arm(Vector2(-facing*14,-48),secondary_hand.position-body_offset,Color("a48251"))
	else:
		draw_rect(Rect2(-21, -48 - stride, 7, 23), Color("a48251"))
		draw_rect(Rect2(14, -48 + stride, 7, 23), Color("715536"))
		draw_rect(Rect2(-20, -27 - stride, 6, 8), Color("c69b72"))
		draw_rect(Rect2(14, -27 + stride, 6, 8), Color("c69b72"))
	draw_rect(Rect2(-8, -60, 16, 10), Color("bd936e"))
	draw_rect(Rect2(-12, -75, 24, 23), Color("d3ad80"))
	draw_rect(Rect2(-13, -80, 26, 8), Color("4a382c"))
	draw_rect(Rect2(-14, -73, 5, 15), Color("4a382c"))
	draw_rect(Rect2(9, -73, 5, 13), Color("4a382c"))
	draw_rect(Rect2(-7 + facing * 2, -66, 3, 3), Color("28352d"))
	draw_rect(Rect2(3 + facing * 2, -66, 3, 3), Color("28352d"))
	draw_rect(Rect2(-3, -57, 7, 2), Color("a7795c"))
	draw_set_transform(Vector2.ZERO)

func _draw_arm(shoulder: Vector2, hand: Vector2, color: Color) -> void:
	var elbow := shoulder.lerp(hand,0.5)+Vector2(-facing*3,4)
	draw_line(shoulder,elbow.round(),color,7,false)
	draw_line(elbow.round(),hand,color,6,false)
