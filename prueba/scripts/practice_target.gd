class_name BituPracticeTarget
extends Node2D
## Maniquí para probar el contacto del zarpazo sin introducir IA enemiga.
var health := 3
var flash := 0.0
var reset_time := 0.0
const HIT_RADIUS := 14.0

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_to_group("enemies")
	var label := Label.new()
	label.text = "Práctica"
	label.position = Vector2(-25,9)
	label.add_theme_font_size_override("font_size",10)
	add_child(label)

func contains_visual_point(point: Vector2) -> bool:
	return Rect2(-14,-58,28,58).has_point(point)

func take_damage(amount: int) -> void:
	if health <= 0:
		return
	health = maxi(0,health-amount)
	flash = 0.18
	if health == 0:
		reset_time = 2.0
	print("BITU_CLAW_HIT:",health)
	queue_redraw()

func _process(delta: float) -> void:
	flash = maxf(0,flash-delta)
	if health == 0:
		reset_time -= delta
		if reset_time <= 0:
			health = 3
	queue_redraw()

func _draw() -> void:
	var wood := Color("745135")
	draw_rect(Rect2(-3,-51,6,51),wood)
	draw_rect(Rect2(-14,-3,28,3),wood)
	var cloth := Color("b6a47d") if flash <= 0 else Color("e4d0a1")
	if health > 0:
		draw_rect(Rect2(-8,-49,16,27),Color("514636"))
		draw_rect(Rect2(-6,-47,12,23),cloth)
		draw_rect(Rect2(-7,-60,14,12),Color("514636"))
		draw_rect(Rect2(-5,-58,10,8),cloth)
		draw_rect(Rect2(-16,-43,32,4),wood)
		if flash > 0:
			for x in [-5,0,5]:
				draw_line(Vector2(x-2,-39),Vector2(x+2,-29),Color("ede0bf"),1)
	for i in range(3):
		draw_rect(Rect2(-8+i*6,-68,4,3),Color("7b9d60") if i < health else Color("4b483c"))
