class_name BituLoot
extends Node2D

var item_id := "tomate"
var amount := 1
var remaining_seconds := 600.0
var texture: Texture2D
var shimmer_time := 0.0

func _ready() -> void:
	if texture != null:
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var factor := 32.0 / float(maxi(texture.get_width(),texture.get_height()))
		sprite.scale = Vector2(factor,factor)
		sprite.position = Vector2(0,-16)
		add_child(sprite)

func _process(delta: float) -> void:
	shimmer_time += delta
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(-11,-3,22,5),Color(0.04,0.07,0.04,0.25))
	if texture == null:
		if item_id == "madera":
			draw_colored_polygon(PackedVector2Array([Vector2(-13,-19),Vector2(-6,-25),Vector2(13,-15),Vector2(6,-9)]),Color("87613d"))
			draw_line(Vector2(-7,-21),Vector2(10,-13),Color("ad8250"),3)
			draw_rect(Rect2(6,-16,6,6),Color("d1ab70"))
			return
		var color := Color("a7b4a3") if item_id == "mineral" else Color("c5a4c7")
		draw_rect(Rect2(-9,-25,18,18),color)
		draw_rect(Rect2(-7,-23,7,5),color.lightened(0.2))
