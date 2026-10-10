class_name BituTerrain
extends Node2D

const HOUSE_ANCHOR := Vector2i(18, 11)
const WATER_ATLAS = preload("res://assets/entorno/agua-casa/agua-atlas.png")
const SHORE_DIRECTIONS := [Vector2i(-1,0), Vector2i(0,-1), Vector2i(1,0), Vector2i(0,1)]
var water_frames: Array[AtlasTexture] = []
const SURFACE_DIRECTORY := "res://assets/entorno/terreno/"
var surface_sources: Dictionary = {}
var surface_frames: Dictionary = {}

const MAP_SIZE := 32
const HALF_TILE := Vector2(32, 16)
var blocked: Dictionary = {}
var farm_cells: Array[Vector2i] = []

static func cell_to_world(cell: Vector2) -> Vector2:
	return Vector2((cell.x - cell.y) * 32.0, (cell.x + cell.y) * 16.0)

static func world_to_cell(point: Vector2) -> Vector2i:
	return Vector2i(roundi(point.x / 64.0 + point.y / 32.0), roundi(point.y / 32.0 - point.x / 64.0))

func is_water(cell: Vector2i) -> bool:
	return cell.x >= 24 - int(cell.y > 18) and cell.y <= 24

func is_house(cell: Vector2i) -> bool:
	return Geometry2D.is_point_in_polygon(cell_to_world(cell) - cell_to_world(HOUSE_ANCHOR), BituHouse.FOUNDATION)

func is_walkable(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < MAP_SIZE and cell.y >= 0 and cell.y < MAP_SIZE and not blocked.has(cell)

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var surfaces: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(SURFACE_DIRECTORY+"suelos.json"))
	surface_frames = surfaces.frames
	for frame in surface_frames.values():
		if not surface_sources.has(frame.file):
			surface_sources[frame.file] = load(SURFACE_DIRECTORY+frame.file)
	for row in range(6):
		for column in range(4):
			var frame := AtlasTexture.new()
			frame.atlas = WATER_ATLAS
			frame.region = Rect2(column * 64, row * 32, 64, 32)
			frame.filter_clip = true
			water_frames.append(frame)
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			var cell := Vector2i(x, y)
			if is_house(cell):
				blocked[cell] = null
			elif is_water(cell) or x == 0 or y == 0 or x == MAP_SIZE - 1 or y == MAP_SIZE - 1:
				add_obstacle(cell)
	for x in range(12, 17):
		for y in range(16, 19):
			farm_cells.append(Vector2i(x, y))

func add_obstacle(cell: Vector2i) -> void:
	if blocked.has(cell):
		return
	var body := StaticBody2D.new()
	blocked[cell] = body
	body.position = cell_to_world(cell)
	var shape := CollisionPolygon2D.new()
	shape.polygon = PackedVector2Array([Vector2(0, -16), Vector2(32, 0), Vector2(0, 16), Vector2(-32, 0)])
	body.add_child(shape)
	add_child(body)

func remove_obstacle(cell: Vector2i) -> void:
	if not blocked.has(cell) or is_water(cell) or is_house(cell):
		return
	var body := blocked[cell] as StaticBody2D
	blocked.erase(cell)
	body.queue_free()

func _draw() -> void:
	for y in range(MAP_SIZE):
		for x in range(MAP_SIZE):
			var cell := Vector2i(x, y)
			var center := cell_to_world(cell)
			var variation := float((x * 17 + y * 31) % 5) * 0.012
			var color := Color(0.28 + variation, 0.42 + variation, 0.22 + variation)
			if is_water(cell):
				color = Color(0.13 + variation, 0.35 + variation, 0.39 + variation)
			elif x >= 21 and x <= 23 and y <= 26:
				color = Color(0.65 + variation, 0.61 + variation, 0.40 + variation)
			elif (x >= 16 and x <= 18 and y >= 10 and y <= 22) or (y == 11 and x >= 8 and x <= 21):
				color = Color(0.47 + variation, 0.42 + variation, 0.29 + variation)
			if farm_cells.has(cell):
				color = Color(0.28 + variation, 0.22 + variation, 0.16 + variation)
			var points := PackedVector2Array([center + Vector2(0, -16), center + Vector2(32, 0), center + Vector2(0, 16), center + Vector2(-32, 0)])
			draw_colored_polygon(points, color)
			if not is_water(cell):
				_draw_surface(cell,points)
				if farm_cells.has(cell):
					draw_polyline(points + PackedVector2Array([points[0]]), Color(0.43, 0.34, 0.22), 1)
	# First water, then transparent banks: neighboring tiles cannot cover a bank.
	for y in range(MAP_SIZE):
		for x in range(MAP_SIZE):
			var cell := Vector2i(x,y)
			if not is_water(cell):
				continue
			var mask := shore_mask(cell)
			var row := 2 if mask else 1
			if not mask and shore_mask(cell + Vector2i(-1,0)):
				row = 0
			var variant := (x * 17 + y * 31) % 4
			draw_texture(water_frames[row * 4 + variant], cell_to_world(cell) - HALF_TILE)
	for y in range(MAP_SIZE):
		for x in range(MAP_SIZE):
			var cell := Vector2i(x,y)
			if not is_water(cell):
				continue
			var mask := shore_mask(cell)
			var corners := {3:20, 6:21, 12:22, 9:23}
			if corners.has(mask):
				draw_texture(water_frames[corners[mask]], cell_to_world(cell) - HALF_TILE)
			else:
				for direction in range(4):
					if mask & (1 << direction):
						draw_texture(water_frames[16 + direction], cell_to_world(cell) - HALF_TILE)

func surface_material(cell: Vector2i) -> String:
	if is_water(cell):
		return "agua"
	if cell.x >= 21 and cell.x <= 23 and cell.y <= 26:
		return "arena"
	if farm_cells.has(cell) or (cell.x >= 16 and cell.x <= 18 and cell.y >= 10 and cell.y <= 22) or (cell.y == 11 and cell.x >= 8 and cell.x <= 21):
		return "tierra"
	return "hierba"

func _draw_surface(cell: Vector2i, points: PackedVector2Array) -> void:
	var variant := "a" if (cell.x*17+cell.y*31)%2 == 0 else "b"
	var frame: Dictionary = surface_frames[surface_material(cell)+"-"+variant]
	var texture: Texture2D = surface_sources[frame.file]
	var r: Array = frame.region
	var x := float(r[0])
	var y := float(r[1])
	var w := float(r[2])
	var h := float(r[3])
	# Mapear la superficie fuente al rombo exacto de suelo, sin cambiar el mundo físico.
	# La geometría recorta los márgenes del atlas; las texturas se cargan una sola vez.
	var uv := PackedVector2Array([Vector2(x+w/2,y),Vector2(x+w,y+h/2),Vector2(x+w/2,y+h),Vector2(x,y+h/2)])
	for index in range(uv.size()):
		uv[index] /= texture.get_size()
	var tint := Color(0.65,0.55,0.43) if farm_cells.has(cell) else Color.WHITE
	draw_polygon(points,PackedColorArray([tint]),uv,texture)

func shore_mask(cell: Vector2i) -> int:
	var mask := 0
	for index in range(4):
		var neighbor: Vector2i = cell + SHORE_DIRECTIONS[index]
		if neighbor.x >= 0 and neighbor.y >= 0 and neighbor.x < MAP_SIZE and neighbor.y < MAP_SIZE and not is_water(neighbor):
			mask |= 1 << index
	return mask
