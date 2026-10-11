class_name BituIslandBuilding
extends Node2D

var building_id := "flavia"
var specification: Dictionary
var portal: Marker2D
var foundation := PackedVector2Array()

func _ready() -> void:
	specification = BituIslandLayout.art().buildings[building_id]
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	y_sort_enabled = true
	foundation = BituIslandLayout.polygon(specification.foundation)
	var art: Texture2D = load("res://assets/mundo/isla-bitu/"+specification.file)
	var entry := BituIslandLayout.point(specification.entry)
	var front := BituIslandLayout.polygon(specification.front)
	for left in range(0,art.get_width(),24):
		var width := mini(24,art.get_width()-left)
		var x := left+width/2.0-entry.x
		var depth := _front_depth(x,front)
		var slice := Node2D.new()
		slice.position = Vector2(x,depth)
		var sprite := Sprite2D.new()
		var atlas := AtlasTexture.new()
		atlas.atlas = art
		atlas.region = Rect2(left,0,width,art.get_height())
		atlas.filter_clip = true
		sprite.texture = atlas
		sprite.centered = false
		sprite.position = Vector2(-width/2.0,-entry.y-depth)
		slice.add_child(sprite)
		add_child(slice)
	if building_id == "mina":
		# Dos flancos y pared trasera: dejar la boca y el corredor abiertos.
		var factor: float = specification.uniform_scale
		var source_entry := Vector2(895,865)
		for raw in [[[150,750],[610,850],[635,350],[300,360]],[[980,960],[1400,750],[1400,510],[1020,350],[935,440],[940,735]],[[640,370],[970,440],[1060,270],[640,210]]]:
			var poly := PackedVector2Array()
			for p: Array in raw: poly.append((BituIslandLayout.point(p)-source_entry)*factor)
			_collision(poly)
	else:
		_collision(foundation)
	portal = Marker2D.new()
	portal.name = "Entrada"
	add_child(portal)

func _collision(poly: PackedVector2Array) -> void:
	var body := StaticBody2D.new()
	var shape := CollisionPolygon2D.new()
	shape.polygon = poly
	body.add_child(shape)
	add_child(body)

func _front_depth(x: float, front: PackedVector2Array) -> float:
	for i in range(front.size()-1):
		if x <= front[i+1].x:
			var f := clampf((x-front[i].x)/maxf(1.0,front[i+1].x-front[i].x),0.0,1.0)
			return lerpf(front[i].y,front[i+1].y,f)
	return front[-1].y
