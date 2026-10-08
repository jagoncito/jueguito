extends Node2D
## Revisión ampliada de las mismas animaciones utilizadas en la granja.

var actors: Array[BituPlayer] = []
var time := 0.0

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("15232a"))
	_label("DRAGÓN · PROTAGONISTA",Vector2(28,16),25)
	_label("Cara original intacta · cuerpo bípedo · animaciones del juego ampliadas ×3",Vector2(28,51),16)
	var titles := ["REPOSO", "CAMINAR · con herramienta", "CAMINAR · de espalda", "MINAR", "TALAR", "RECOLECTAR · palín"]
	for index in range(6):
		var actor := BituPlayer.new()
		actor.equipment_enabled = true
		actor.position = Vector2(170+(index%3)*420,338+(index/3)*330)
		actor.scale = Vector2(3,3)
		add_child(actor)
		actor.set_physics_process(false)
		actor.set_process(false)
		actors.append(actor)
		_label(titles[index],Vector2(28+(index%3)*420,350+(index/3)*330),17)
		if index == 2:
			actor.facing_back = true
		elif index == 3 or index == 4:
			actor.begin_work(&"minar" if index == 3 else &"talar",actor.to_global(Vector2(31,-8)))
			actor.work_finished.connect(func(): actor.call_deferred("repeat_work"))
		elif index == 5:
			actor.begin_gathering(actor.to_global(Vector2(32,0)))
			actor.work_finished.connect(func(): _restart_gathering(actor))
	print("BITU_DRAGON_PREVIEW_READY")

func _restart_gathering(actor: BituPlayer) -> void:
	actor.end_work()
	await get_tree().create_timer(0.8).timeout
	if is_instance_valid(actor):
		actor.begin_gathering(actor.to_global(Vector2(32,0)))

func _process(delta: float) -> void:
	time += delta
	for index in range(actors.size()):
		var actor := actors[index]
		actor.walk_time = time*9 if index == 1 or index == 2 else 0.0
		actor.animate_pose(delta)

func _label(value: String, point: Vector2, size: int) -> void:
	var label := Label.new()
	label.text = value
	label.position = point
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",Color("edd5a0"))
	add_child(label)
