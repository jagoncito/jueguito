extends SceneTree

var impacts: Array[StringName] = []
var completed := 0

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var tool: Node2D = load("res://assets/herramientas/pico-hacha/pico-hacha-hierro.tscn").instantiate()
	root.add_child(tool)
	var source := load("res://assets/herramientas/pico-hacha/pico-hacha-hierro.png") as Texture2D
	assert(source.get_size() == Vector2(1254,1254), "Medidas del original")
	var pick := tool.get_node("Pico") as Sprite2D
	var handle := tool.get_node("Mango") as Sprite2D
	var axe := tool.get_node("Hacha") as Sprite2D
	var old_axe := axe.texture
	var old_handle := handle.texture
	var replacement := AtlasTexture.new()
	replacement.atlas = source
	replacement.region = Rect2(240,164,314,968)
	assert(tool.set_part_texture("pick",replacement), "Aceptar pieza registrada")
	assert(pick.texture == replacement and axe.texture == old_axe and handle.texture == old_handle, "Cambiar pico conserva hacha y mango")
	assert(not tool.set_part_texture("axe",replacement), "Rechazar pieza con medidas incompatibles")
	for sprite in [pick,handle,axe]:
		var texture := sprite.texture as AtlasTexture
		var expected_center := (texture.region.get_center()-Vector2(630,900))*0.0625
		assert(sprite.position.is_equal_approx(expected_center), "Registro común alrededor del agarre")
		assert(sprite.scale == Vector2(0.0625,0.0625), "Escala uniforme")
	tool.impact.connect(func(action: StringName): impacts.append(action))
	tool.work_finished.connect(func(): completed += 1)
	assert(tool.supports_action(&"minar") and tool.supports_action(&"talar"), "El mismo pico–hacha sirve para ambas acciones")
	tool.play_work(&"pescar")
	assert(not tool.working and tool.motion == null and impacts.is_empty(), "Una acción ajena no inicia animación ni emite impactos")
	tool.play_work("minar")
	tool.play_work("talar")
	await create_timer(0.75).timeout
	assert(impacts == [&"minar"] and completed == 1 and not tool.working, "Un impacto sin solapar acciones")
	assert(is_equal_approx(tool.rotation,deg_to_rad(35)), "Recuperar pose de agarre")
	tool.play_work("talar")
	await create_timer(0.75).timeout
	assert(impacts == [&"minar",&"talar"] and completed == 2, "Animación de tala independiente")
	assert(tool.contact_point("minar") != tool.contact_point("talar"), "Efectos en extremos distintos")
	tool.queue_free()
	await process_frame
	print("BITU_TOOL_SMOKE_OK")
	quit(0)
