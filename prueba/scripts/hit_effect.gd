class_name BituHitEffect
extends Node2D

var wood := false
var herbal := false
var age := 0.0
const LIFETIME := 0.32

func _process(delta: float) -> void:
	age += delta
	if age >= LIFETIME:
		queue_free()
	else:
		queue_redraw()

func _draw() -> void:
	var color := Color("caa26b") if wood else Color("c5cec0")
	if herbal:
		color = Color("997450")
	color.a = 1.0-age/LIFETIME
	for index in range(6):
		var velocity := Vector2((index-2.5)*35.0,-50.0-float(index%3)*20.0)
		var point := (velocity*age+Vector2(0,150*age*age)).round()
		draw_rect(Rect2(point,Vector2(3,2) if wood else Vector2(2,2)),color)
