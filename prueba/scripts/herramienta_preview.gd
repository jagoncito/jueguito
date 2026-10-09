extends Node2D

var actors: Array[BituPlayer] = []

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("18251e"))
	_label("PICO–HACHA · HIERRO",Vector2(36,24),28,Color("e6cc83"))
	_label("Un mango · dos funciones · mejoras visuales independientes",Vector2(36,64),17)
	_label("Escala ampliada ×4 · dragón bípedo de 80 px · herramienta dibujada con las manos",Vector2(36,96),16)
	var titles := ["AGARRE", "MINAR · lado del pico", "TALAR · lado del hacha"]
	for index in range(3):
		var actor := BituPlayer.new()
		actor.equipment_enabled = true
		actor.position = Vector2(170+index*400,490)
		actor.scale = Vector2(4,4)
		add_child(actor)
		actor.set_physics_process(false)
		actor.set_process(false)
		actors.append(actor)
		actor.work_finished.connect(actor.end_work)
		_label(titles[index],Vector2(40+index*400,527),19,Color("e6cc83"))
	_label("1 · movimiento de minería     2 · movimiento de tala     R · restaurar poses",Vector2(36,573),16)
	_label("Marco equipado 64 × 64 · icono 64 × 64 · botín 32 × 32 · mango sujeto por ambas manos",Vector2(36,604),16)
	_label("Pico y hacha se sustituyen por separado; el mango conserva el mismo punto de agarre.",Vector2(36,635),16)
	_label("Rasgos originales del dragón · poses completas coordinadas con las herramientas del juego.",Vector2(36,676),14,Color("a7b797"))
	print("BITU_TOOL_READY")

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.physical_keycode == KEY_1:
		actors[1].begin_work("minar",actors[1].to_global(Vector2(35,-22)),actors[1].to_global(Vector2(35,0)))
	elif event.physical_keycode == KEY_2:
		actors[2].begin_work("talar",actors[2].to_global(Vector2(35,-22)),actors[2].to_global(Vector2(35,0)))
	elif event.physical_keycode == KEY_R:
		for actor in actors:
			actor.end_work()

func _process(delta: float) -> void:
	for actor in actors:
		actor.animate_pose(delta)

func _label(value: String, point: Vector2, size: int, color: Color = Color("e1ddba")) -> void:
	var label := Label.new()
	label.text = value
	label.position = point
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",color)
	add_child(label)
