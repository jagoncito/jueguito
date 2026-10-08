class_name BituTerrain
extends Node2D

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
	return cell.x >= 8 and cell.x <= 15 and cell.y >= 4 and cell.y <= 9

func is_walkable(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < MAP_SIZE and cell.y >= 0 and cell.y < MAP_SIZE and not blocked.has(cell)

func _ready() -> void:
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			var cell := Vector2i(x, y)
			if is_water(cell) or is_house(cell) or x == 0 or y == 0 or x == MAP_SIZE - 1 or y == MAP_SIZE - 1:
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
			if is_water(cell):
				if (x + y) % 3 == 0:
					draw_line(center + Vector2(-9, -2), center + Vector2(6, -2), Color(0.34, 0.57, 0.57), 2)
			elif farm_cells.has(cell):
				draw_polyline(points + PackedVector2Array([points[0]]), Color(0.43, 0.34, 0.22), 1)
			elif (x * 5 + y * 3) % 7 == 0:
				draw_rect(Rect2(center + Vector2(-8, -4), Vector2(3, 5)), Color(0.39, 0.53, 0.27))
				draw_rect(Rect2(center + Vector2(5, 3), Vector2(2, 4)), Color(0.22, 0.35, 0.19))
