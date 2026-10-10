class_name BituHouse
extends Node2D

const ART = preload("res://assets/entorno/agua-casa/sprites/casa.png")
const FRONT := [Vector2(-304,-148), Vector2(-184,-88), Vector2(-142,-75), Vector2(-10,-104), Vector2(211,-158)]
const FOUNDATION := [Vector2(-304,-148), Vector2(-184,-88), Vector2(-142,-75), Vector2(-10,-104), Vector2(211,-158), Vector2(211,-231), Vector2(-48,-272), Vector2(-304,-190)]

func _ready() -> void:
	y_sort_enabled = true
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	# Keep the original pixels. Column anchors follow the irregular front wall,
	# allowing the dragon to pass in front of the porch and behind the roof.
	for left in range(0,640,32):
		var x := float(left - 368 + 16)
		var depth := front_depth(x)
		var column := Node2D.new()
		column.position = Vector2(x,depth)
		var texture := AtlasTexture.new()
		texture.atlas = ART
		texture.region = Rect2(left,0,32,512)
		texture.filter_clip = true
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.centered = false
		sprite.position = Vector2(-16,-496-depth)
		column.add_child(sprite)
		add_child(column)
	var body := StaticBody2D.new()
	var collision := CollisionPolygon2D.new()
	collision.polygon = FOUNDATION
	body.add_child(collision)
	add_child(body)
	var entry := Marker2D.new()
	entry.name = "Entrada"
	entry.position = Vector2(60.3717,-123.3638)
	add_child(entry)

static func front_depth(x: float) -> float:
	for index in range(FRONT.size()-1):
		if x <= FRONT[index+1].x:
			var ratio := clampf((x-FRONT[index].x)/(FRONT[index+1].x-FRONT[index].x),0,1)
			return lerpf(FRONT[index].y,FRONT[index+1].y,ratio)
	return FRONT[-1].y
