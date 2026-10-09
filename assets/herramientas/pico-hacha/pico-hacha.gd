extends Node2D

signal impact(function: StringName)
signal work_finished

const REST_ANGLE := 35.0
const MOTIONS := {
	"minar": [[70.0,0.20],[-70.0,0.13],[-62.0,0.07],[REST_ANGLE,0.22]],
	"talar": [[-55.0,0.20],[70.0,0.13],[62.0,0.07],[REST_ANGLE,0.22]]
}
var motion: Tween
var working := false
var externally_posed := false
const SOURCE_GRIP := Vector2(630,900)
const SOURCE_SCALE := 0.0625
const CONTACTS := {"minar":Vector2(250,414),"talar":Vector2(1000,350)}
var direction_index := -1
var view_catalog: Dictionary = {}
var current_view: Dictionary = {}
var view_texture: Texture2D
var view_atlases: Dictionary = {}

func set_direction(index: int) -> void:
	index = posmod(index,8)
	if direction_index == index:
		return
	if view_catalog.is_empty():
		view_catalog = JSON.parse_string(FileAccess.get_file_as_string("res://assets/herramientas/pico-hacha/pico-hacha-vistas.json"))
		view_texture = load("res://assets/herramientas/pico-hacha/pico-hacha-vistas.png")
	direction_index = index
	current_view = view_catalog.views[view_catalog.directions[index]]
	for part in {"pick":"Pico","handle":"Mango","axe":"Hacha"}:
		var key := "%s-%s" % [index,part]
		var region: Array = current_view.pieces[part]
		if not view_atlases.has(key):
			var atlas := AtlasTexture.new()
			atlas.atlas = view_texture
			atlas.region = Rect2(region[0],region[1],region[2],region[3])
			atlas.filter_clip = true
			view_atlases[key] = atlas
		var sprite := get_node({"pick":"Pico","handle":"Mango","axe":"Hacha"}[part]) as Sprite2D
		sprite.texture = view_atlases[key]
		sprite.scale = Vector2.ONE*float(current_view.scale)
		sprite.position = (Vector2(region[0]+region[2]*.5,region[1]+region[3]*.5)-Vector2(current_view.grip[0],current_view.grip[1]))*float(current_view.scale)

func contact_offset(function: StringName) -> Vector2:
	if current_view.is_empty():
		return (CONTACTS[String(function)]-SOURCE_GRIP)*SOURCE_SCALE
	var point: Array = current_view.contacts[String(function)]
	return (Vector2(point[0],point[1])-Vector2(current_view.grip[0],current_view.grip[1]))*float(current_view.scale)

func _ready() -> void:
	reset_pose()

func reset_pose() -> void:
	if motion != null and motion.is_valid():
		motion.kill()
	working = false
	rotation = 0.0 if externally_posed else deg_to_rad(REST_ANGLE)

func play_work(function: StringName) -> void:
	if working or not MOTIONS.has(String(function)):
		return
	working = true
	motion = create_tween()
	motion.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if externally_posed:
		motion.tween_interval(.33)
		motion.tween_callback(func(): impact.emit(function))
		motion.tween_interval(.29)
		motion.tween_callback(func():
			working = false
			work_finished.emit()
		)
		return
	var frames: Array = MOTIONS[String(function)]
	for index in range(frames.size()):
		var frame: Array = frames[index]
		motion.tween_property(self,"rotation",deg_to_rad(float(frame[0])),float(frame[1])).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		if index == 1:
			motion.tween_callback(func(): impact.emit(function))
	motion.tween_callback(func():
		working = false
		work_finished.emit()
	)

func contact_point(function: StringName) -> Vector2:
	# Para colocar efectos visuales al impactar; no determina el alcance jugable.
	if not CONTACTS.has(String(function)):
		return global_position
	return to_global(contact_offset(function))

func impact_vector(function: StringName) -> Vector2:
	if not MOTIONS.has(String(function)):
		return Vector2.ZERO
	var local_point := contact_offset(function)
	return local_point.rotated(deg_to_rad(float(MOTIONS[String(function)][1][0])))

func set_part_texture(part: StringName, replacement: Texture2D) -> bool:
	# Las texturas nuevas conservan las dimensiones y registro de su región.
	var paths := {"pick":"Pico", "axe":"Hacha", "handle":"Mango"}
	if not paths.has(String(part)) or replacement == null:
		return false
	var sprite := get_node(paths[String(part)]) as Sprite2D
	if replacement.get_size() != sprite.texture.get_size():
		return false
	sprite.texture = replacement
	return true
