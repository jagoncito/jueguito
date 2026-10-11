class_name BituIslandTerrain
extends BituTerrain
## Terreno de la isla: solo se dibujan las casillas próximas a la cámara.
var draw_rect := Rect2()
var materials_cache := {}
var water_cache := {}
var shore_cache := {}
var buildings: Array[Node2D] = []
var active_region := ""

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var surfaces: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(SURFACE_DIRECTORY+"suelos.json"))
	surface_frames = surfaces.frames
	for frame: Dictionary in surface_frames.values():
		if not surface_sources.has(frame.file): surface_sources[frame.file] = load(SURFACE_DIRECTORY+frame.file)
	for row in range(6):
		for column in range(4):
			var frame := AtlasTexture.new()
			frame.atlas = WATER_ATLAS
			frame.region = Rect2(column*64,row*32,64,32)
			frame.filter_clip = true
			water_frames.append(frame)
	var ruin_assets: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/entorno/ruinas-camino/assets.json"))
	for asset: Dictionary in ruin_assets.assets:
		if asset.id == "terreno-pavimento":
			for variant in ["a","b"]: surface_frames["piedra-"+variant] = {"file":"ruinas-terreno","region":asset.region}
	surface_sources["ruinas-terreno"] = load("res://assets/entorno/ruinas-camino/atlas/terreno.png")
	var farm := BituIslandLayout.rect(BituIslandLayout.data().farm_rect)
	for x in range(-12,12):
		for y in range(-7,7):
			var at: Array = BituIslandLayout.site("granja").point
			var center := BituIslandLayout.point(at)+Vector2(x*64.0,y*32.0+155)
			var cell := world_to_cell(center)
			if farm.has_point(cell_to_world(cell)) and x%2 == 0 and y%2 == 0: farm_cells.append(cell)
	_build_boundaries()
	update_view(BituIslandLayout.point(BituIslandLayout.data().spawn),Vector2(1280,720),1.5)

func is_water(cell: Vector2i) -> bool:
	if not water_cache.has(cell): water_cache[cell] = BituIslandLayout.is_water(cell_to_world(cell))
	return water_cache[cell]

func is_house(cell: Vector2i) -> bool:
	var at := cell_to_world(cell)
	for building in buildings:
		if building is BituHouse and Geometry2D.is_point_in_polygon(at-building.position,BituHouse.FOUNDATION): return true
		if building is BituIslandBuilding and building.building_id != "mina" and Geometry2D.is_point_in_polygon(at-building.position,building.foundation): return true
	return false

func is_walkable(cell: Vector2i) -> bool:
	return not is_water(cell) and not blocked.has(cell) and not is_house(cell)

func update_view(at: Vector2, viewport: Vector2, zoom: float) -> void:
	var desired := Rect2(at-viewport/(zoom*2)-Vector2(192,192),viewport/zoom+Vector2(384,384))
	if draw_rect.has_area() and draw_rect.grow(-110).encloses(Rect2(at-viewport/(zoom*2),viewport/zoom)):
		return
	draw_rect = desired
	queue_redraw()

func _build_boundaries() -> void:
	var coast := BituIslandLayout.polygon(BituIslandLayout.data().coast)
	for i in range(coast.size()):
		var a := coast[i]
		var b := coast[(i+1)%coast.size()]
		# Dividir los bordes largos permite dejar libres solo los muelles.
		var count := maxi(1,ceili(a.distance_to(b)/48.0))
		for step in range(count):
			var start := a.lerp(b,float(step)/count)
			var end := a.lerp(b,float(step+1)/count)
			if not BituIslandLayout.on_dock((start+end)/2): _segment(start,end)
	for raw: Array in BituIslandLayout.data().docks:
		var poly := BituIslandLayout.polygon(raw)
		for i in range(poly.size()):
			var a := poly[i]
			var b := poly[(i+1)%poly.size()]
			var count := maxi(1,ceili(a.distance_to(b)/32.0))
			for step in range(count):
				var start := a.lerp(b,float(step)/count)
				var end := a.lerp(b,float(step+1)/count)
				if not Geometry2D.is_point_in_polygon((start+end)/2,coast): _segment(start,end)
	var river: Array = BituIslandLayout.data().river
	for i in range(river.size()-1):
		var a := BituIslandLayout.point(river[i])
		var b := BituIslandLayout.point(river[i+1])
		var length := a.distance_to(b)
		var cuts: Array[float] = [0.0,1.0]
		for raw: Array in BituIslandLayout.data().bridges:
			var bridge := BituIslandLayout.point(raw)
			var near := Geometry2D.get_closest_point_to_segment(bridge,a,b)
			if near.distance_to(bridge)<35:
				var t := a.distance_to(near)/length
				cuts.append(clampf(t-45.0/length,0,1))
				cuts.append(clampf(t+45.0/length,0,1))
		cuts.sort()
		for index in range(0,cuts.size()-1,2):
			var start := a.lerp(b,cuts[index])
			var end := a.lerp(b,cuts[index+1])
			var normal := (b-a).normalized().orthogonal()*31
			var body := StaticBody2D.new()
			var polygon := CollisionPolygon2D.new()
			polygon.polygon = PackedVector2Array([start+normal,end+normal,end-normal,start-normal])
			body.add_child(polygon)
			add_child(body)

func _segment(a: Vector2, b: Vector2) -> void:
	var body := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var line := SegmentShape2D.new()
	line.a = a
	line.b = b
	shape.shape = line
	body.add_child(shape)
	add_child(body)

func shore_mask(cell: Vector2i) -> int:
	if shore_cache.has(cell): return shore_cache[cell]
	var mask := 0
	for i in range(4):
		if not is_water(cell+SHORE_DIRECTIONS[i]): mask |= 1<<i
	shore_cache[cell] = mask
	return mask

func surface_material(cell: Vector2i) -> String:
	if materials_cache.has(cell): return materials_cache[cell]
	var at := cell_to_world(cell)
	var material := "hierba"
	if is_water(cell): material = "agua"
	elif at.distance_to(BituIslandLayout.point(BituIslandLayout.site("ruinas").point))<210: material = "piedra"
	elif farm_cells.has(cell) or BituIslandLayout.on_path(at): material = "tierra"
	elif BituIslandLayout.shore_distance(at)<84: material = "arena"
	materials_cache[cell] = material
	return material

func _draw() -> void:
	if not draw_rect.has_area(): return
	var bounds: Array[Vector2i] = []
	for at in [draw_rect.position,draw_rect.end,Vector2(draw_rect.position.x,draw_rect.end.y),Vector2(draw_rect.end.x,draw_rect.position.y)]: bounds.append(world_to_cell(at))
	var low := bounds[0]
	var high := bounds[0]
	for p in bounds:
		low = Vector2i(mini(low.x,p.x),mini(low.y,p.y))
		high = Vector2i(maxi(high.x,p.x),maxi(high.y,p.y))
	var water: Array[Vector2i] = []
	for y in range(low.y-1,high.y+2):
		for x in range(low.x-1,high.x+2):
			var cell := Vector2i(x,y)
			var center := cell_to_world(cell)
			if not draw_rect.grow(32).has_point(center): continue
			if is_water(cell):
				water.append(cell)
				var row := 2 if shore_mask(cell)>0 else 1
				draw_texture(water_frames[row*4+posmod(x*17+y*31,4)],center-HALF_TILE)
			else:
				var points := PackedVector2Array([center+Vector2(0,-16),center+Vector2(32,0),center+Vector2(0,16),center+Vector2(-32,0)])
				draw_colored_polygon(points,Color("567946"))
				_draw_surface(cell,points)
				if farm_cells.has(cell): draw_polyline(points+PackedVector2Array([points[0]]),Color("806047"),1)
	for cell in water:
		var mask := shore_mask(cell)
		var corners := {3:20,6:21,12:22,9:23}
		if corners.has(mask): draw_texture(water_frames[corners[mask]],cell_to_world(cell)-HALF_TILE)
		else:
			for i in range(4):
				if mask & (1<<i): draw_texture(water_frames[16+i],cell_to_world(cell)-HALF_TILE)
	for raw: Array in BituIslandLayout.data().docks:
		var poly := BituIslandLayout.polygon(raw)
		draw_colored_polygon(poly,Color("967047"))
		draw_polyline(poly+PackedVector2Array([poly[0]]),Color("4c3b2c"),4)
		var b := Rect2(poly[0],Vector2.ZERO)
		for p in poly: b = b.expand(p)
		for y in range(int(b.position.y),int(b.end.y),16):
			var intersections: Array[float] = []
			for i in range(poly.size()):
				var a := poly[i]; var end := poly[(i+1)%poly.size()]
				if (a.y<=y and end.y>y) or (end.y<=y and a.y>y): intersections.append(a.x+(y-a.y)*(end.x-a.x)/(end.y-a.y))
			intersections.sort()
			if intersections.size()>=2: draw_line(Vector2(intersections[0],y),Vector2(intersections[1],y),Color("60452d"),2)
	for raw: Array in BituIslandLayout.data().bridges:
		var center := BituIslandLayout.point(raw)
		var poly := PackedVector2Array([center+Vector2(-110,-35),center+Vector2(95,-60),center+Vector2(110,35),center+Vector2(-95,60)])
		draw_colored_polygon(poly,Color("a78254"))
		for x in range(-90,100,15): draw_line(center+Vector2(x,-40),center+Vector2(x+8,40),Color("63482e"),2)
		draw_line(poly[0],poly[1],Color("e0b77b"),5)
		draw_line(poly[3],poly[2],Color("503e2c"),5)
