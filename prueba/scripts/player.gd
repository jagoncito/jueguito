class_name BituPlayer
extends CharacterBody2D

const SPEED := 150.0
var busy := false
var facing := 1
var walk_time := 0.0

func _ready() -> void:
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 7.0
	collision.shape = shape
	collision.position = Vector2(0, -3)
	add_child(collision)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED if not busy else Vector2.ZERO
	if absf(direction.x) > 0.1:
		facing = 1 if direction.x > 0 else -1
	if velocity.length() > 0 or busy:
		walk_time += delta * 9
	else:
		walk_time = 0
	move_and_slide()
	queue_redraw()

func _draw() -> void:
	var stride := roundf(sin(walk_time) * 3)
	draw_rect(Rect2(-14, -4, 28, 7), Color(0.04, 0.08, 0.05, 0.35))
	draw_rect(Rect2(-12, -20 + stride, 9, 20), Color("343a34"))
	draw_rect(Rect2(3, -20 - stride, 9, 20), Color("343a34"))
	draw_rect(Rect2(-14, -6 + stride, 12, 6), Color("332a25"))
	draw_rect(Rect2(2, -6 - stride, 13, 6), Color("332a25"))
	draw_rect(Rect2(-15, -53, 30, 34), Color("87643e"))
	draw_rect(Rect2(-15, -53, 7, 32), Color("b79258"))
	draw_rect(Rect2(8, -51, 7, 30), Color("624c36"))
	draw_rect(Rect2(-16, -25, 32, 5), Color("3c3430"))
	draw_rect(Rect2(-3, -25, 7, 5), Color("cfb46b"))
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
