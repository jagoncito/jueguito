class_name BituResource
extends Node2D

var kind := "ore"
var active := true
var zone: Array[Vector2i] = []
var cell := Vector2i.ZERO
var cooldown := 0.0
const RESPAWN_SECONDS := 14.0 # Solo para revisar el prototipo.

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

func _draw() -> void:
	if kind == "ore":
		draw_colored_polygon(PackedVector2Array([Vector2(-23,0),Vector2(-26,-17),Vector2(-13,-35),Vector2(9,-39),Vector2(25,-22),Vector2(22,1)]),Color("596965"))
		draw_colored_polygon(PackedVector2Array([Vector2(-26,-17),Vector2(-13,-35),Vector2(9,-39),Vector2(0,-19)]),Color("8c9b86"))
		draw_line(Vector2(-17,-19),Vector2(-3,-31),Color("c6b06a"),3)
		draw_line(Vector2(-3,-31),Vector2(8,-19),Color("a18a52"),3)
		draw_rect(Rect2(8,-20,8,4),Color("d4c284"))
	else:
		draw_rect(Rect2(-2,-23,4,24),Color("405f32"))
		draw_rect(Rect2(-12,-13,11,5),Color("719451"))
		draw_rect(Rect2(2,-17,10,5),Color("597c45"))
		for offset in [Vector2(-8,-31),Vector2(3,-31),Vector2(-3,-37),Vector2(-3,-25)]:
			draw_rect(Rect2(offset,Vector2(8,8)),Color("bf9ac2"))
		draw_rect(Rect2(-1,-29,5,5),Color("eed18c"))
