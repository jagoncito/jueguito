class_name BituTree
extends BituDecoration

const HITS_REQUIRED := 5 # Inicio acordado; las mejoras futuras podrán reducirlo hasta uno.
var cell := Vector2i.ZERO
var active := true
var hits := 0
var feedback: Tween
var variant := 0
var sprite: Sprite2D

func _ready() -> void:
	sprite = Sprite2D.new()
	add_child(sprite)
	_update_art()

func visual_id() -> String:
	return ("tree-%d" if active else "stump-%d") % (variant % 3)

func _update_art() -> void:
	if sprite != null:
		BituResourceArt.configure(sprite,visual_id())

func contains_visual_point(point: Vector2) -> bool:
	return active and BituResourceArt.contains(visual_id(),point)

func hit() -> bool:
	if not active:
		return false
	hits += 1
	if feedback != null and feedback.is_valid():
		feedback.kill()
	if hits >= HITS_REQUIRED:
		active = false
		skew = 0
		_update_art()
		queue_redraw()
		return true
	feedback = create_tween()
	feedback.tween_property(self,"skew",deg_to_rad(3.0 if hits % 2 else -3.0),0.07)
	feedback.tween_property(self,"skew",0.0,0.12)
	return false

func _draw() -> void:
	draw_colored_polygon(PackedVector2Array([Vector2(-32,0),Vector2(0,-9),Vector2(32,0),Vector2(0,9)]),Color(0.05,0.09,0.05,0.24))
