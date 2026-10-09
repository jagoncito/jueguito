extends Node2D
## Las mismas poses del juego, simultáneamente en las ocho direcciones.

var actors: Array[BituPlayer] = []
var cooldowns: Array[float] = []
var time := 0.0
var mode := 0
var mode_label: Label
const MODES := ["REPOSO","MARCHA","MINAR","TALAR","PALÍN"]
const LABELS := ["SUR · frontal","SUROESTE","OESTE · perfil","NOROESTE","NORTE · espalda","NORESTE","ESTE · perfil","SURESTE"]

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("15232a"))
	_label("DRAGÓN · OCHO DIRECCIONES",Vector2(28,16),25)
	_label("1 Reposo · 2 Marcha · 3 Minar · 4 Talar · 5 Palín    |    poses del juego ×2",Vector2(28,51),16)
	mode_label = _label("REPOSO",Vector2(1030,20),20)
	for index in range(8):
		var actor := BituPlayer.new()
		actor.equipment_enabled = true
		actor.position = Vector2(160+(index%4)*320,290+(index/4)*320)
		actor.scale = Vector2(2,2)
		add_child(actor)
		actor.set_physics_process(false)
		actor.set_process(false)
		actor.face_towards(BituPlayer.DIRECTIONS[index])
		actor.animate_pose(0)
		actors.append(actor)
		cooldowns.append(0.0)
		actor.work_finished.connect(func():
			actor.end_work()
			cooldowns[index] = 0.35
		)
		_label(LABELS[index],Vector2(28+(index%4)*320,370+(index/4)*320),16)
	# Capturas reproducibles de las poses reales, sin depender del rendimiento WebGL.
	if OS.has_feature("web"):
		var requested = JavaScriptBridge.eval("new URLSearchParams(location.search).get('captura')")
		if requested != null:
			_capture_pose(String(requested))
	print("BITU_DRAGON_PREVIEW_READY")

func _capture_pose(requested: String) -> void:
	var names := ["reposo","marcha","minar","talar","palin"]
	if not names.has(requested):
		return
	mode = names.find(requested)
	mode_label.text = MODES[mode]
	for index in range(actors.size()):
		var actor := actors[index]
		if mode >= 2:
			_start_action(index)
			if mode == 4:
				actor.herbal_tool.motion.pause()
				actor.herbal_tool.motion.custom_step(0.5)
				actor.posture.pause()
				actor.posture.custom_step(0.5)
			else:
				actor.tool.motion.pause()
				actor.tool.motion.custom_step(0.34)
		elif mode == 1:
			actor.walk_time = 1.0
		actor.animate_pose(0)
	set_process(false)
	var frames: Array[String] = []
	for actor in actors:
		frames.append(actor.dragon.current_frame)
	print("BITU_DRAGON_CAPTURE_READY:",JSON.stringify({"mode":requested,"frames":frames}))

func _start_action(index: int) -> void:
	var actor := actors[index]
	var direction: Vector2 = BituPlayer.DIRECTIONS[index].normalized()
	var ground := actor.to_global(direction*35)
	if mode == 4:
		actor.begin_gathering(actor.to_global(direction*35+Vector2(0,-5)),ground)
	else:
		actor.begin_work(&"minar" if mode == 2 else &"talar",actor.to_global(direction*35+Vector2(0,-22)),ground)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode >= KEY_1 and event.physical_keycode <= KEY_5:
			mode = event.physical_keycode-KEY_1
			mode_label.text = MODES[mode]
			set_process(true)
			queue_redraw()
			for index in range(8):
				actors[index].end_work()
				cooldowns[index] = 0.0

func _process(delta: float) -> void:
	time += delta
	for index in range(actors.size()):
		var actor := actors[index]
		actor.walk_time = time*9 if mode == 1 else 0.0
		cooldowns[index] = maxf(0,cooldowns[index]-delta)
		if mode >= 2 and not actor.busy and cooldowns[index] == 0:
			_start_action(index)
		actor.animate_pose(delta)

func _draw() -> void:
	if mode < 2:
		return
	for index in range(actors.size()):
		var direction: Vector2 = BituPlayer.DIRECTIONS[index].normalized()
		var point := actors[index].to_global(direction*35+Vector2(0,-5 if mode == 4 else -22))
		# Referencia de contacto, detrás del personaje según la perspectiva.
		draw_circle(point,7,Color("ae86b4") if mode == 4 else Color("7c8c87"))
		draw_circle(point,3,Color("e0c788"))

func _label(value: String, point: Vector2, size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = point
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",Color("edd5a0"))
	add_child(label)
	return label
