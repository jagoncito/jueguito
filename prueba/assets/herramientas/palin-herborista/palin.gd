extends Node2D

signal impact(function: StringName)
signal work_finished

const SOURCE_GRIP := Vector2(440,820)
const SOURCE_TIP := Vector2(1170,155)
const SOURCE_SCALE := 1.0/32.0
const IMPACT_ANGLE := 85.0
const DURATION := 2.0 # Provisional: incluye agacharse, extraer y levantarse.
var working := false
var motion: Tween

func contact_vector() -> Vector2:
	return ((SOURCE_TIP-SOURCE_GRIP)*SOURCE_SCALE).rotated(deg_to_rad(IMPACT_ANGLE))

func contact_point() -> Vector2:
	return to_global((SOURCE_TIP-SOURCE_GRIP)*SOURCE_SCALE)

func reset_pose() -> void:
	if motion != null and motion.is_valid():
		motion.kill()
	working = false
	rotation = deg_to_rad(-20)

func play_work() -> void:
	if working:
		return
	working = true
	motion = create_tween()
	for frame in [[-20.0,0.25],[55.0,0.30],[25.0,0.20],[65.0,0.30],[40.0,0.20],[IMPACT_ANGLE,0.25]]:
		motion.tween_property(self,"rotation",deg_to_rad(frame[0]),frame[1]).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	motion.tween_callback(func(): impact.emit(&"recolectar"))
	motion.tween_property(self,"rotation",deg_to_rad(55),0.20)
	motion.tween_property(self,"rotation",deg_to_rad(-20),0.30)
	motion.tween_callback(func():
		working = false
		work_finished.emit()
	)
