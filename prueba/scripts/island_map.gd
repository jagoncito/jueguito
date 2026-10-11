class_name BituIslandMap
extends Control

var game: Node2D
var head: AtlasTexture
var location: Vector2
var plot := Rect2()
var factor := 1.0

func _ready() -> void:
	custom_minimum_size = Vector2(870,470)
	mouse_filter = Control.MOUSE_FILTER_STOP
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var catalog: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/dragon/dragon-jugable.json"))
	var frame: Dictionary = catalog.frames["reposo-S"]
	head = AtlasTexture.new()
	head.atlas = load("res://assets/personajes/dragon/"+frame.file)
	var r: Array = frame.region
	head.region = Rect2(r[0]+28,r[1],153,134)
	head.filter_clip = true
	resized.connect(queue_redraw)

func update_location() -> void:
	location = game.map_position() if game.has_method("map_position") else game.player.global_position
	queue_redraw()

func project(at: Vector2) -> Vector2:
	var bounds := BituIslandLayout.rect(BituIslandLayout.data().bounds)
	factor = minf((size.x-230)/bounds.size.x,(size.y-32)/bounds.size.y)
	plot = Rect2(Vector2(12,12),bounds.size*factor)
	return plot.position+(at-bounds.position)*factor

func _draw() -> void:
	if head == null: return
	var data := BituIslandLayout.data()
	project(Vector2.ZERO)
	draw_style_box(_map_style(),Rect2(Vector2.ZERO,size))
	var land := PackedVector2Array()
	for raw: Array in data.coast: land.append(project(BituIslandLayout.point(raw)))
	draw_colored_polygon(land,Color("648363"))
	draw_polyline(land+PackedVector2Array([land[0]]),Color("dcc28d"),3)
	# Montañas y bosque conservan la orientación del terreno real.
	for i in range(12):
		var p := project(Vector2(-2900+posmod(i*211,1300),-2240+posmod(i*173,1200)))
		draw_colored_polygon(PackedVector2Array([p+Vector2(-9,7),p+Vector2(0,-11),p+Vector2(10,7)]),Color("bec0a3"))
	for i in range(40):
		var world := Vector2(-2500+posmod(i*617,4600),-1750+posmod(i*433,2000))
		if BituIslandLayout.is_land(world): draw_circle(project(world),3,Color("3f624b"))
	var river := PackedVector2Array()
	for raw: Array in data.river: river.append(project(BituIslandLayout.point(raw)))
	draw_polyline(river,Color("77c2c2"),4)
	for route: Array in data.paths:
		var line := PackedVector2Array()
		for raw: Array in route: line.append(project(BituIslandLayout.point(raw)))
		draw_polyline(line,Color("d4b988"),2)
	for raw: Array in data.docks:
		var poly := PackedVector2Array()
		for p: Array in raw: poly.append(project(BituIslandLayout.point(p)))
		draw_colored_polygon(poly,Color("b89361"))
	var font := ThemeDB.fallback_font
	for index in range(data.sites.size()):
		var site: Dictionary = data.sites[index]
		var p := project(BituIslandLayout.point(site.point))
		draw_circle(p,8,Color("192f29"))
		draw_arc(p,8,0,TAU,24,Color("e8ca87"),1)
		var number := str(index+1)
		var width := font.get_string_size(number,HORIZONTAL_ALIGNMENT_LEFT,-1,11).x
		draw_string(font,p+Vector2(-width/2,4),number,HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("eadab4"))
		var label_point := Vector2(size.x-202,40+index*30)
		draw_string(font,label_point,number+" · "+String(site.name).replace("Casa del comerciante y la elfa","Casa de la pareja").replace("Ruinas de la costa","Ruinas").replace("Astillero de Flavia","Astillero").replace("Casa de pesca y cocina","Pesca y cocina").replace("Casa de Unamahloni","Unamahloni"),HORIZONTAL_ALIGNMENT_LEFT,198,13,Color("eadab4"))
	var current := project(location)
	draw_circle(current,19,Color("132d29"))
	draw_arc(current,19,0,TAU,32,Color("ffcd79"),2)
	draw_texture_rect(head,Rect2(current-Vector2(17,17),Vector2(34,34)),false)
	draw_string(font,Vector2(size.x-202,430),"Tu posición",HORIZONTAL_ALIGNMENT_LEFT,-1,14,Color("ffcd79"))
	draw_texture_rect(head,Rect2(size.x-95,405,32,32),false)
	draw_string(font,Vector2(20,28),"N",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("eadab4"))
	draw_line(Vector2(42,33),Vector2(42,14),Color("eadab4"),2)
	draw_line(Vector2(42,14),Vector2(37,21),Color("eadab4"),2)
	draw_line(Vector2(42,14),Vector2(47,21),Color("eadab4"),2)

func _map_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("214749")
	style.border_color = Color("637e65")
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	return style
