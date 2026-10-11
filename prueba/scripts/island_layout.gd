class_name BituIslandLayout
extends RefCounted

static var document: Dictionary = {}
static var buildings: Dictionary = {}
static var coast_points := PackedVector2Array()

static func data() -> Dictionary:
	if document.is_empty(): document = JSON.parse_string(FileAccess.get_file_as_string("res://assets/mundo/isla-bitu/isla.json"))
	return document

static func art() -> Dictionary:
	if buildings.is_empty(): buildings = JSON.parse_string(FileAccess.get_file_as_string("res://assets/mundo/isla-bitu/edificios.json"))
	return buildings

static func point(value: Array) -> Vector2:
	return Vector2(value[0],value[1])

static func polygon(value: Array) -> PackedVector2Array:
	var result := PackedVector2Array()
	for p: Array in value: result.append(point(p))
	return result

static func rect(value: Array) -> Rect2:
	return Rect2(value[0],value[1],value[2],value[3])

static func site(id: String) -> Dictionary:
	for s: Dictionary in data().sites:
		if s.id == id: return s
	return {}

static func region(at: Vector2) -> Dictionary:
	for zone: Dictionary in data().zones:
		if rect(zone.rect).has_point(at): return zone
	return data().zones[0]

static func on_path(at: Vector2, width := 62.0) -> bool:
	for route: Array in data().paths:
		for i in range(route.size()-1):
			if Geometry2D.get_closest_point_to_segment(at,point(route[i]),point(route[i+1])).distance_to(at)<width: return true
	return false

static func on_dock(at: Vector2) -> bool:
	for value: Array in data().docks:
		if Geometry2D.is_point_in_polygon(at,polygon(value)): return true
	return false

static func on_bridge(at: Vector2) -> bool:
	for bridge: Array in data().bridges:
		if point(bridge).distance_to(at)<105.0: return true
	return false

static func is_land(at: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(at,coast()) or on_dock(at)

static func coast() -> PackedVector2Array:
	if coast_points.is_empty(): coast_points = polygon(data().coast)
	return coast_points

static func is_river(at: Vector2) -> bool:
	if on_bridge(at): return false
	var river: Array = data().river
	for i in range(river.size()-1):
		if Geometry2D.get_closest_point_to_segment(at,point(river[i]),point(river[i+1])).distance_to(at)<float(data().river_width)/2.0: return true
	return false

static func is_water(at: Vector2) -> bool:
	return not is_land(at) or is_river(at)

static func shore_distance(at: Vector2) -> float:
	var coast := coast()
	var best := INF
	for i in range(coast.size()): best = minf(best,Geometry2D.get_closest_point_to_segment(at,coast[i],coast[(i+1)%coast.size()]).distance_to(at))
	return best
