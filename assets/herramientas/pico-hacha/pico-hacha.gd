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
	return to_global((CONTACTS[String(function)]-SOURCE_GRIP)*SOURCE_SCALE)

func impact_vector(function: StringName) -> Vector2:
	if not MOTIONS.has(String(function)):
		return Vector2.ZERO
	var local_point: Vector2 = (CONTACTS[String(function)]-SOURCE_GRIP)*SOURCE_SCALE
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
