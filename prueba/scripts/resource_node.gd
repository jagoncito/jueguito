class_name BituResource
extends Node2D

var kind := "ore"
var active := true
var zone: Array[Vector2i] = []
var cell := Vector2i.ZERO
var cooldown := 0.0
var damaged := false
var sprite: Sprite2D
const RESPAWN_SECONDS := 14.0 # Solo para revisar el prototipo.

func _ready() -> void:
	sprite = Sprite2D.new()
	add_child(sprite)
	_update_art()

func visual_id() -> String:
	return ("ore-damaged" if damaged else "ore") if kind == "ore" else "yde"

func _update_art() -> void:
	if sprite != null:
		BituResourceArt.configure(sprite,visual_id())

func show_damage() -> void:
	if kind == "ore" and active:
		damaged = true
		_update_art()

func contains_visual_point(point: Vector2) -> bool:
	return active and BituResourceArt.contains(visual_id(),point)

func harvest() -> void:
	active = false
	visible = false
	cooldown = RESPAWN_SECONDS

func advance(delta: float) -> void:
	if active:
		return
	cooldown -= delta
	if cooldown <= 0:
		var candidates: Array[Vector2i] = []
		for point in zone:
			if point != cell:
				candidates.append(point)
		cell = candidates.pick_random() if not candidates.is_empty() else cell
		position = BituTerrain.cell_to_world(cell)
		active = true
		visible = true
		damaged = false
		_update_art()

func _draw() -> void:
	var half_width := 25.0 if kind == "ore" else 12.0
	draw_colored_polygon(PackedVector2Array([Vector2(-half_width,0),Vector2(0,-4),Vector2(half_width,0),Vector2(0,4)]),Color(0.04,0.07,0.04,0.25))
