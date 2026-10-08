class_name BituTree
extends BituDecoration

const HITS_REQUIRED := 4 # Parámetro de la prueba, no dificultad definitiva.
var cell := Vector2i.ZERO
var active := true
var hits := 0
var feedback: Tween

func hit() -> bool:
	if not active:
		return false
	hits += 1
	if feedback != null and feedback.is_valid():
		feedback.kill()
	if hits >= HITS_REQUIRED:
		active = false
		skew = 0
		queue_redraw()
		return true
	feedback = create_tween()
	feedback.tween_property(self,"skew",deg_to_rad(3.0 if hits % 2 else -3.0),0.07)
	feedback.tween_property(self,"skew",0.0,0.12)
	return false

func _draw() -> void:
	if active:
		super._draw()
	else:
		draw_rect(Rect2(-16,-3,32,7),Color(0.05,0.09,0.05,0.24))
		draw_rect(Rect2(-12,-14,24,16),Color("6e5339"))
		draw_rect(Rect2(-12,-14,24,5),Color("b08b55"))
		draw_rect(Rect2(-7,-13,14,2),Color("d0aa6a"))
		draw_rect(Rect2(-9,-6,4,8),Color("96724a"))
