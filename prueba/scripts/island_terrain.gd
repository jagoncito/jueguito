class_name BituIslandTerrain
extends BituTerrain
## Bloques estáticos reutilizables; preparación incremental fuera de la vista.
var draw_rect := Rect2()
var materials_cache := {}
var water_cache := {}
var shore_cache := {}
var buildings: Array[Node2D] = []
const CHUNK_SIZE := 256
const PREFETCH := 384
const PREPARE_BUDGET_USEC := 1500
const MAX_CHUNKS := 128
var chunks := {}
var jobs := {}
var pending: Array[Vector2i] = []
var last_prepare_usec := 0
var max_prepare_usec := 0
var prepared_tiles := 0
var camera_point := Vector2.ZERO

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
	camera_point = at
	var view := Rect2(at-viewport/(zoom*2),viewport/zoom)
	if draw_rect.has_area() and draw_rect.grow(-128).encloses(view): return
	draw_rect = view.grow(PREFETCH)
	var low := Vector2i(floori(draw_rect.position.x/CHUNK_SIZE),floori(draw_rect.position.y/CHUNK_SIZE))
	var high := Vector2i(floori(draw_rect.end.x/CHUNK_SIZE),floori(draw_rect.end.y/CHUNK_SIZE))
	for y in range(low.y,high.y+1):
		for x in range(low.x,high.x+1):
			var key := Vector2i(x,y)
			if not chunks.has(key): _request_chunk(key)
	for key: Vector2i in chunks:
		(chunks[key] as BituIslandTerrainChunk).visible = _chunk_rect(key).grow(32).intersects(draw_rect)
	pending.sort_custom(func(a: Vector2i,b: Vector2i): return _chunk_rect(a).get_center().distance_squared_to(at)<_chunk_rect(b).get_center().distance_squared_to(at))
	_trim_cache()

func view_ready(at: Vector2, viewport: Vector2, zoom: float) -> bool:
	var view := Rect2(at-viewport/(zoom*2),viewport/zoom).grow(32)
	var low := Vector2i(floori(view.position.x/CHUNK_SIZE),floori(view.position.y/CHUNK_SIZE))
	var high := Vector2i(floori(view.end.x/CHUNK_SIZE),floori(view.end.y/CHUNK_SIZE))
	for y in range(low.y,high.y+1):
		for x in range(low.x,high.x+1):
			var key := Vector2i(x,y)
			if not chunks.has(key) or not (chunks[key] as BituIslandTerrainChunk).complete: return false
	return true

func _chunk_rect(key: Vector2i) -> Rect2:
	return Rect2(Vector2(key)*CHUNK_SIZE,Vector2.ONE*CHUNK_SIZE)

func _request_chunk(key: Vector2i) -> void:
	var chunk := BituIslandTerrainChunk.new()
	chunk.position = Vector2(key)*CHUNK_SIZE
	chunk.z_index = -1
	add_child(chunk)
	chunks[key] = chunk
	var bounds := _chunk_rect(key)
	var cells: Array[Vector2i] = []
	var corners: Array[Vector2i] = []
	for at in [bounds.position,bounds.end,Vector2(bounds.position.x,bounds.end.y),Vector2(bounds.end.x,bounds.position.y)]: corners.append(world_to_cell(at))
	var low := corners[0]; var high := corners[0]
	for cell in corners:
		low = Vector2i(mini(low.x,cell.x),mini(low.y,cell.y))
		high = Vector2i(maxi(high.x,cell.x),maxi(high.y,cell.y))
	for y in range(low.y-1,high.y+2):
		for x in range(low.x-1,high.x+2):
			var cell := Vector2i(x,y)
			if bounds.has_point(cell_to_world(cell)): cells.append(cell)
	jobs[key] = {"cells":cells,"index":0}
	pending.append(key)

func prime_view(at: Vector2, viewport: Vector2, zoom: float) -> void:
	# Solo al arrancar: completar el área visible antes de mostrar la partida.
	update_view(at,viewport,zoom)
	var view := Rect2(at-viewport/(zoom*2),viewport/zoom).grow(32)
	for key: Vector2i in pending.duplicate():
		if _chunk_rect(key).intersects(view):
			while jobs.has(key): _prepare_tile(key)

func _process(_delta: float) -> void:
	var started := Time.get_ticks_usec()
	var completed := 0
	while not pending.is_empty() and Time.get_ticks_usec()-started<PREPARE_BUDGET_USEC and completed<2:
		var key := pending[0]
		_prepare_tile(key)
		if not jobs.has(key): completed += 1
	last_prepare_usec = Time.get_ticks_usec()-started
	max_prepare_usec = maxi(max_prepare_usec,last_prepare_usec)

func _prepare_tile(key: Vector2i) -> void:
	var job: Dictionary = jobs[key]
	var chunk: BituIslandTerrainChunk = chunks[key]
	var cell: Vector2i = job.cells[job.index]
	chunk.tiles.append(_tile_data(cell,chunk.position))
	job.index += 1
	prepared_tiles += 1
	if job.index == job.cells.size():
		chunk.finish()
		jobs.erase(key)
		pending.erase(key)

func _tile_data(cell: Vector2i, offset: Vector2) -> Dictionary:
	var center := cell_to_world(cell)-offset
	if is_water(cell):
		var mask := shore_mask(cell)
		var row := 2 if mask>0 else 1
		var edges: Array[Texture2D] = []
		var corners := {3:20,6:21,12:22,9:23}
		if corners.has(mask): edges.append(water_frames[corners[mask]])
		else:
			for i in range(4):
				if mask & (1<<i): edges.append(water_frames[16+i])
		return {"water":true,"texture":water_frames[row*4+posmod(cell.x*17+cell.y*31,4)],"origin":center-HALF_TILE,"edges":edges}
	var points := PackedVector2Array([center+Vector2(0,-16),center+Vector2(32,0),center+Vector2(0,16),center+Vector2(-32,0)])
	var variant := "a" if (cell.x*17+cell.y*31)%2 == 0 else "b"
	var frame: Dictionary = surface_frames[surface_material(cell)+"-"+variant]
	var texture: Texture2D = surface_sources[frame.file]
	var r: Array = frame.region
	var uv := PackedVector2Array([Vector2(r[0]+r[2]/2.0,r[1]),Vector2(r[0]+r[2],r[1]+r[3]/2.0),Vector2(r[0]+r[2]/2.0,r[1]+r[3]),Vector2(r[0],r[1]+r[3]/2.0)])
	for index in range(uv.size()): uv[index] /= texture.get_size()
	var farm := farm_cells.has(cell)
	return {"water":false,"points":points,"uv":uv,"texture":texture,"farm":farm,"tint":Color(0.65,0.55,0.43) if farm else Color.WHITE}

func _trim_cache() -> void:
	if chunks.size()<=MAX_CHUNKS: return
	var candidates: Array = chunks.keys()
	candidates.sort_custom(func(a: Vector2i,b: Vector2i): return _chunk_rect(a).get_center().distance_squared_to(camera_point)>_chunk_rect(b).get_center().distance_squared_to(camera_point))
	for key: Vector2i in candidates:
		if chunks.size()<=MAX_CHUNKS: break
		if _chunk_rect(key).grow(32).intersects(draw_rect): continue
		(chunks[key] as Node).queue_free()
		chunks.erase(key); jobs.erase(key); pending.erase(key)

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
	# Muelles y puentes estáticos se dibujan una vez, por encima del terreno.
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
