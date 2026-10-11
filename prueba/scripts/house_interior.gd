class_name BituHouseInterior
extends Node2D

const CENTER := Vector2(2400,0)
const EXIT := Vector2(0,190)
const FLOOR := [Vector2(0,-240),Vector2(480,0),Vector2(0,240),Vector2(-480,0)]
const SOURCE = preload("res://assets/entorno/casa-interior/fuente.png")
var furnishings: Node2D

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	furnishings = Node2D.new()
	furnishings.y_sort_enabled = true
	add_child(furnishings)
	# Regions retain source pixels; the spacious floor is built separately.
	_add_furniture(Rect2(10,750,231,224),Vector2(-260,-70),Vector2(110,55),0.48)
	_add_furniture(Rect2(244,781,198,146),Vector2(210,22),Vector2(86,42),0.48)
	_add_furniture(Rect2(451,812,126,119),Vector2(-75,-177),Vector2(58,28),0.48)
	_add_furniture(Rect2(580,750,128,199),Vector2(105,-175),Vector2(62,30),0.48)
	_add_furniture(Rect2(708,816,126,146),Vector2(285,-70),Vector2(58,28),0.48)
	_add_furniture(Rect2(827,739,177,255),Vector2(220,-95),Vector2(72,35),0.48)
	for i in range(4):
		var body := StaticBody2D.new()
		body.position = CENTER
		var line := CollisionShape2D.new()
		var shape := SegmentShape2D.new()
		shape.a = FLOOR[i]
		shape.b = FLOOR[(i+1)%4]
		line.shape = shape
		body.add_child(line)
		add_child(body)

func _add_furniture(region: Rect2, point: Vector2, footprint: Vector2, factor: float) -> void:
	var body := StaticBody2D.new()
	body.position = CENTER+point
	var sprite := Sprite2D.new()
	var atlas := AtlasTexture.new()
	atlas.atlas = SOURCE
	atlas.region = region
	atlas.filter_clip = true
	sprite.texture = atlas
	sprite.scale = Vector2.ONE*factor
	sprite.position.y = -region.size.y*factor/2+8
	var material := ShaderMaterial.new()
	var shader := Shader.new()
	shader.code = "shader_type canvas_item; void fragment(){ vec4 c=texture(TEXTURE,UV); if(c.a<0.97){discard;} COLOR=vec4(c.rgb,1.0); }"
	material.shader = shader
	sprite.material = material
	body.add_child(sprite)
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = footprint
	collision.shape = shape
	collision.position.y = -footprint.y/2
	body.add_child(collision)
	furnishings.add_child(body)

func _draw() -> void:
	var poly := PackedVector2Array()
	for point in FLOOR: poly.append(CENTER+point)
	draw_colored_polygon(poly,Color("946944"))
	# Plank joints: clipped to the diamond without independent tile nodes.
	for y in range(-224,225,16):
		var width := 480.0-absf(y)*2.0
		draw_line(CENTER+Vector2(-width,y),CENTER+Vector2(width,y),Color("65492f"),2)
		for x in range(-400,401,80):
			if absf(x)+absf(y)*2 < 430:
				draw_line(CENTER+Vector2(x,y),CENTER+Vector2(x,y+12),Color("765235"),1)
	for pair in [[FLOOR[3],FLOOR[0]],[FLOOR[0],FLOOR[1]]]:
		var a: Vector2 = CENTER+pair[0]
		var b: Vector2 = CENTER+pair[1]
		draw_colored_polygon(PackedVector2Array([a,b,b-Vector2(0,125),a-Vector2(0,125)]),Color("d2c19a"))
		draw_line(a,b,Color("665039"),10)
		draw_line(a-Vector2(0,125),b-Vector2(0,125),Color("57412f"),10)
		for n in range(1,6):
			var p := a.lerp(b,n/6.0)
			draw_line(p,p-Vector2(0,125),Color("665039"),8)
	draw_line(CENTER+EXIT+Vector2(-25,0),CENTER+EXIT+Vector2(25,0),Color("dfbe74"),8)
