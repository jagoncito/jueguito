class_name BituIslandRoom
extends BituHouseInterior
## Interior amplio montado con muebles existentes, a escala constante.
var room_id := "granja"
var floor_shape := PackedVector2Array()
var exit_point := Vector2(0,225)
var floor_color := Color("926b47")
var spawn_point := Vector2(0,185)
var bounds := Rect2()
var ore_nodes: Array[BituResource] = []

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	furnishings = Node2D.new()
	furnishings.y_sort_enabled = true
	add_child(furnishings)
	floor_shape = PackedVector2Array([Vector2(-560,-240),Vector2(280,-240),Vector2(280,-130),Vector2(560,-130),Vector2(560,260),Vector2(-560,260)])
	if room_id in ["pareja","tienda","astillero"]:
		floor_shape = PackedVector2Array([Vector2(-650,-260),Vector2(540,-260),Vector2(650,-130),Vector2(650,260),Vector2(-650,260)])
	if room_id == "museo":
		floor_shape = PackedVector2Array([Vector2(-870,-310),Vector2(-300,-310),Vector2(-300,-390),Vector2(300,-390),Vector2(300,-310),Vector2(870,-310),Vector2(870,310),Vector2(-870,310)])
		floor_color = Color("888a78")
	if room_id == "mina":
		floor_shape = PackedVector2Array([Vector2(-220,340),Vector2(-280,70),Vector2(-560,-150),Vector2(-520,-450),Vector2(-190,-700),Vector2(140,-660),Vector2(310,-400),Vector2(480,-180),Vector2(320,130),Vector2(160,340)])
		exit_point = Vector2(-30,302)
		spawn_point = exit_point-Vector2(0,40)
		floor_color = Color("615e53")
	bounds = Rect2(floor_shape[0],Vector2.ZERO)
	for p in floor_shape: bounds = bounds.expand(p)
	for i in range(floor_shape.size()): _wall_collision(floor_shape[i],floor_shape[(i+1)%floor_shape.size()])
	if room_id == "mina":
		for at in [Vector2(-300,-230),Vector2(-140,-550),Vector2(170,-330)]:
			var ore := BituResource.new()
			ore.kind = "ore"
			ore.position = CENTER+at
			ore.zone = [BituTerrain.world_to_cell(ore.position)]
			ore.cell = ore.zone[0]
			furnishings.add_child(ore)
			ore_nodes.append(ore)
		_fixture("yunque",Vector2(-135,25),Vector2(48,30))
	elif room_id == "museo":
		for at in [Vector2(-570,-90),Vector2(-270,-90),Vector2(150,-90),Vector2(560,-90),Vector2(-570,170),Vector2(560,170)]: _fixture("vitrina",at,Vector2(150,64))
		_prop("biblioteca",Vector2(-190,-260))
		_prop("biblioteca",Vector2(180,-260))
		_prop("escritorio",Vector2(0,-220))
	elif room_id == "tienda":
		for at in [Vector2(-520,-180),Vector2(-360,-180),Vector2(420,-180)]: _prop("biblioteca",at)
		_prop("cajon",Vector2(515,150)); _prop("barril",Vector2(480,85))
		_prop("mesa",Vector2(-320,65))
		_fixture("mostrador",Vector2(200,10),Vector2(230,65))
	elif room_id == "astillero":
		for at in [Vector2(-460,-155),Vector2(-210,-155),Vector2(80,-155)]: _prop("mesa",at)
		for at in [Vector2(490,160),Vector2(465,-140),Vector2(-450,130)]: _prop("cajon",at)
		_prop("tablones",Vector2(280,-140)); _prop("barril",Vector2(-520,25))
	else:
		var bed := "cama-doble" if room_id == "pareja" else "cama"
		_prop(bed,Vector2(350,-70))
		_prop("armario",Vector2(200,-145))
		_prop("cofre",Vector2(430,70))
		_prop("mesa",Vector2(-135,20))
		_prop("cocina",Vector2(-390,-150))
		_prop("chimenea",Vector2(-480,90))
		if room_id == "alquimista":
			_prop("biblioteca",Vector2(-110,-160))
			_fixture("laboratorio",Vector2(-330,120),Vector2(135,58))
		elif room_id == "herreria":
			floor_color = Color("82715b")
			_fixture("yunque",Vector2(-330,100),Vector2(60,35))
			_prop("cajon",Vector2(-430,185))
		elif room_id == "pareja":
			_prop("biblioteca",Vector2(-170,-150))
			_prop("escritorio",Vector2(-350,135))
		else: _prop("sillon",Vector2(190,90))
		# Separación doméstica con paso amplio por su extremo inferior.
		_wall_collision(Vector2(145,-220),Vector2(145,-40))
	queue_redraw()

func _wall_collision(a: Vector2, b: Vector2) -> void:
	var body := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var line := SegmentShape2D.new()
	line.a = CENTER+a; line.b = CENTER+b
	shape.shape = line
	body.add_child(shape)
	add_child(body)

func _prop(id: String, at: Vector2) -> void:
	var spec: Dictionary = BituIslandLayout.art().props[id]
	var body := StaticBody2D.new()
	body.position = CENTER+at
	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/mundo/isla-bitu/"+spec.file)
	sprite.centered = false
	sprite.position = Vector2(-sprite.texture.get_width()/2.0,-sprite.texture.get_height()+8)
	body.add_child(sprite)
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(sprite.texture.get_width()*0.72,mini(50,sprite.texture.get_height()*0.30))
	collision.shape = shape
	collision.position.y = -shape.size.y/2
	body.add_child(collision)
	furnishings.add_child(body)

func _fixture(kind: String, at: Vector2, size_px: Vector2) -> void:
	var fixture := BituIslandFixture.new()
	fixture.kind = kind
	fixture.dimensions = size_px
	fixture.position = CENTER+at
	furnishings.add_child(fixture)

func _draw() -> void:
	if floor_shape.is_empty(): return
	var poly := PackedVector2Array()
	for p in floor_shape: poly.append(CENTER+p)
	draw_colored_polygon(poly,floor_color)
	for y in range(int(bounds.position.y)+12,int(bounds.end.y),20):
		var intersections: Array[float] = []
		for i in range(floor_shape.size()):
			var a := floor_shape[i]; var b := floor_shape[(i+1)%floor_shape.size()]
			if (a.y<=y and b.y>y) or (b.y<=y and a.y>y): intersections.append(a.x+(y-a.y)*(b.x-a.x)/(b.y-a.y))
		intersections.sort()
		for index in range(0,intersections.size()-1,2): draw_line(CENTER+Vector2(intersections[index],y),CENTER+Vector2(intersections[index+1],y),floor_color.darkened(.24),2)
		for x in range(int(bounds.position.x)+posmod(y,80),int(bounds.end.x),80):
			if Geometry2D.is_point_in_polygon(Vector2(x,y),floor_shape): draw_line(CENTER+Vector2(x,y),CENTER+Vector2(x,y+12),floor_color.darkened(.13),1)
	for i in range(floor_shape.size()):
		var a := CENTER+floor_shape[i]; var b := CENTER+floor_shape[(i+1)%floor_shape.size()]
		if (floor_shape[i].y+floor_shape[(i+1)%floor_shape.size()].y)/2<-90:
			var height := 90.0 if room_id == "mina" else 112.0
			var wall := PackedVector2Array([a,b,b-Vector2(0,height),a-Vector2(0,height)])
			draw_colored_polygon(wall,Color("4c5652") if room_id == "mina" else Color("c0b18c"))
			draw_line(a,b,Color("4c3d2c"),8)
			draw_line(a-Vector2(0,height),b-Vector2(0,height),Color("4c3d2c"),8)
			var span := maxi(1,ceili(a.distance_to(b)/125.0))
			for j in range(1,span):
				var p := a.lerp(b,float(j)/span)
				draw_line(p,p-Vector2(0,height),Color("766247"),6)
	draw_line(CENTER+exit_point-Vector2(32,0),CENTER+exit_point+Vector2(32,0),Color("e6c37b"),8)
	var font := ThemeDB.fallback_font
	draw_string(font,CENTER+exit_point+Vector2(-29,20),"E · Salir",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("f4dfac"))
