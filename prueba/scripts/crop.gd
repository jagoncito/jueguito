class_name BituCrop
extends Node2D

var planted := false
var growth := 0.0
var water := 0.0
const GROW_SECONDS := 12.0
const WATER_SECONDS := 8.0

func stage() -> int:
	return 0 if not planted else mini(3, 1 + int(growth / 4.0))

func is_ripe() -> bool:
	return planted and growth >= GROW_SECONDS

func advance(delta: float) -> void:
	if planted and not is_ripe() and water > 0:
		var active_delta := minf(delta, water)
		growth = minf(GROW_SECONDS, growth + active_delta)
		water = maxf(0, water - active_delta)
		queue_redraw()

func plant() -> void:
	planted = true
	growth = 0
	water = 0
	queue_redraw()

func irrigate() -> void:
	water = WATER_SECONDS
	queue_redraw()

func harvest() -> void:
	planted = false
	growth = 0
	water = 0
	queue_redraw()

func _draw() -> void:
	if not planted:
		return
	var s := stage()
	var stem_color := Color("5d8745") if water > 0 or is_ripe() else Color("526d3d")
	var height := 12 + s * 10
	draw_rect(Rect2(-2,-height,4,height),stem_color)
	for level in range(s+1):
		var y := -8-level*8
		draw_rect(Rect2(-13,y,12,4),Color("71984b"))
		draw_rect(Rect2(2,y-5,12,4),Color("466b39"))
	if is_ripe():
		for point in [Vector2(-12,-23),Vector2(7,-29),Vector2(-9,-37)]:
			draw_rect(Rect2(point,Vector2(8,8)),Color("be4430"))
			draw_rect(Rect2(point+Vector2(1,1),Vector2(3,2)),Color("ed8052"))
	if water > 0 and not is_ripe():
		draw_rect(Rect2(-4,3,8,2),Color("658d99"))
