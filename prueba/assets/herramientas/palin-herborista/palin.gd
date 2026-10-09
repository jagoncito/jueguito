extends Node2D

signal impact(function: StringName)
signal work_finished

const SOURCE_GRIP := Vector2(440,820)
const SOURCE_TIP := Vector2(1170,155)
const SOURCE_SCALE := 1.0/32.0
const IMPACT_ANGLE := 85.0
const DURATION := 2.0 # Provisional: incluye agacharse, extraer y levantarse.
var working := false
var externally_posed := false
var motion: Tween
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
		view_catalog = JSON.parse_string(FileAccess.get_file_as_string("res://assets/herramientas/palin-herborista/palin-vistas.json"))
		view_texture = load("res://assets/herramientas/palin-herborista/palin-vistas.png")
	direction_index = index
	current_view = view_catalog.views[view_catalog.directions[index]]
	var region: Array = current_view.region
	if not view_atlases.has(index):
		var atlas := AtlasTexture.new()
		atlas.atlas = view_texture
		atlas.region = Rect2(region[0],region[1],region[2],region[3])
		atlas.filter_clip = true
		view_atlases[index] = atlas
	var sprite := $Palin as Sprite2D
	sprite.texture = view_atlases[index]
	sprite.scale = Vector2.ONE*float(current_view.scale)
	sprite.position = (Vector2(region[0]+region[2]*.5,region[1]+region[3]*.5)-Vector2(current_view.grip[0],current_view.grip[1]))*float(current_view.scale)

func tip_offset() -> Vector2:
	if current_view.is_empty():
		return (SOURCE_TIP-SOURCE_GRIP)*SOURCE_SCALE
	return (Vector2(current_view.tip[0],current_view.tip[1])-Vector2(current_view.grip[0],current_view.grip[1]))*float(current_view.scale)

func contact_vector() -> Vector2:
	return tip_offset().rotated(deg_to_rad(IMPACT_ANGLE))

func contact_point() -> Vector2:
	return to_global(tip_offset())

func reset_pose() -> void:
	if motion != null and motion.is_valid():
		motion.kill()
	working = false
	rotation = 0.0 if externally_posed else deg_to_rad(-20)

func play_work() -> void:
	if working:
		return
	working = true
	motion = create_tween()
	motion.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if externally_posed:
		motion.tween_interval(1.5)
		motion.tween_callback(func(): impact.emit(&"recolectar"))
		motion.tween_interval(.5)
		motion.tween_callback(func():
			working = false
			work_finished.emit()
		)
		return
	for frame in [[-20.0,0.25],[55.0,0.30],[25.0,0.20],[65.0,0.30],[40.0,0.20],[IMPACT_ANGLE,0.25]]:
		motion.tween_property(self,"rotation",deg_to_rad(frame[0]),frame[1]).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	motion.tween_callback(func(): impact.emit(&"recolectar"))
	motion.tween_property(self,"rotation",deg_to_rad(55),0.20)
	motion.tween_property(self,"rotation",deg_to_rad(-20),0.30)
	motion.tween_callback(func():
		working = false
		work_finished.emit()
	)
