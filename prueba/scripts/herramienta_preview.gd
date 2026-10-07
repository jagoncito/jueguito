extends Node2D

const TOOL := preload("res://assets/herramientas/pico-hacha/pico-hacha-hierro.tscn")
var tools: Array[Node2D] = []

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("18251e"))
	_label("PICO–HACHA · HIERRO",Vector2(36,24),28,Color("e6cc83"))
	_label("Un mango · dos funciones · mejoras visuales independientes",Vector2(36,64),17)
	_label("Escala ampliada ×4 · humano de referencia: 80 px · herramienta: 48,5 × 60,5 px",Vector2(36,96),16)
	var titles := ["AGARRE", "MINAR · lado del pico", "TALAR · lado del hacha"]
	for index in range(3):
		var actor := BituPlayer.new()
		actor.position = Vector2(170+index*400,490)
		actor.scale = Vector2(4,4)
		add_child(actor)
		actor.set_physics_process(false)
		var tool: Node2D = TOOL.instantiate()
		tool.position = Vector2(17,-25)
		actor.add_child(tool)
		tools.append(tool)
		if index == 1:
			tool.rotation = deg_to_rad(-70)
		elif index == 2:
			tool.rotation = deg_to_rad(70)
		# La mano se dibuja delante del agarre. Es una referencia, no una animación humana terminada.
		var hand := Polygon2D.new()
		hand.polygon = PackedVector2Array([Vector2(14,-29),Vector2(20,-29),Vector2(20,-21),Vector2(14,-21)])
		hand.color = Color("c69b72")
		actor.add_child(hand)
		_label(titles[index],Vector2(40+index*400,527),19,Color("e6cc83"))
	_label("1 · movimiento de minería     2 · movimiento de tala     R · restaurar poses",Vector2(36,573),16)
	_label("Marco equipado 64 × 64 · icono 64 × 64 · botín 32 × 32 · giro alrededor de la mano",Vector2(36,604),16)
	_label("Pico y hacha se sustituyen por separado; el mango conserva el mismo punto de agarre.",Vector2(36,635),16)
	_label("Personaje y movimientos de prueba. Pendientes: coordinación del cuerpo y vistas definitivas.",Vector2(36,676),14,Color("a7b797"))
	print("BITU_TOOL_READY")

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.physical_keycode == KEY_1:
		tools[1].play_work("minar")
	elif event.physical_keycode == KEY_2:
		tools[2].play_work("talar")
	elif event.physical_keycode == KEY_R:
		for tool in tools:
			tool.reset_pose()
		tools[1].rotation = deg_to_rad(-70)
		tools[2].rotation = deg_to_rad(70)

func _label(value: String, point: Vector2, size: int, color: Color = Color("e1ddba")) -> void:
	var label := Label.new()
	label.text = value
	label.position = point
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",color)
	add_child(label)
