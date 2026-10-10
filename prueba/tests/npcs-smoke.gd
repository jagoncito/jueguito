extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	assert(scene.comparison_characters.size() == 6, "Los seis personajes aparecen en la granja")
	var heights := {"flavia":80,"unamahloni":80,"cocinero":80,"enano":64,"elfa-museo":80,"comerciante":84}
	for character in scene.comparison_characters:
		character.set_process(false)
		assert(character.get_parent() == scene.objects and scene.objects.y_sort_enabled, "Comparten profundidad con el protagonista")
		assert(character.definition.height_px == heights[String(character.definition.id)], "Escalas originales de comparación")
		var home: Vector2 = character.home_position
		var initial_direction := ""
		var phases: Dictionary = {}
		var scales: Dictionary = {}
		for sample in range(61):
			character.motion_clock = sample / 10.0
			character.update_pose()
			assert(character.position.distance_to(home) <= 24.001, "Recorrido corto y acotado")
			assert(is_equal_approx(character.position.y,home.y), "El suelo permanece estable")
			var direction: String = character.current_frame.split("-")[0]
			if initial_direction.is_empty():
				initial_direction = direction
			phases[character.current_frame] = true
			if scales.has(direction):
				assert(character.body.scale == scales[direction], "Sin cambio de escala dentro de la marcha")
			else:
				scales[direction] = character.body.scale
			var frame: Dictionary = character.definition.frames[character.current_frame]
			assert(character.body.position.is_equal_approx(-Vector2(frame.anchor[0],frame.anchor[1])*float(frame.scale)), "Los pies usan el ancla registrada")
		if character.definition.motion == "walk":
			for direction in ["E","W"]:
				for phase in range(4):
					assert(phases.has("%s-%d" % [direction,phase]), "Marcha con cuatro dibujos reales en ida y vuelta")
		else:
			assert(phases.size() == 8, "Ocho vistas sin deslizamiento de una pose estática")
			assert(character.position == home, "Los giros conservan la posición")
		character.motion_clock = 1.4
		character.update_pose()
		var frozen_frame: String = character.current_frame
		var frozen_position: Vector2 = character.position
		character.review_paused = true
		character._process(0.5)
		assert(character.current_frame == frozen_frame and character.position == frozen_position, "La pausa permite comparar una pose fija")
		character.review_paused = false
		character._process(0.5)
		assert(character.motion_clock > 1.4, "Se puede reanudar la muestra")
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = KEY_F6
	scene._unhandled_input(event)
	for character in scene.comparison_characters:
		assert(character.review_paused, "F6 pausa a todo el grupo")
	scene._unhandled_input(event)
	for character in scene.comparison_characters:
		assert(not character.review_paused, "F6 reanuda a todo el grupo")
	print("BITU_NPCS_SMOKE_OK: seis personajes, marcha real, giros y pausa")
	scene.queue_free()
	await process_frame
	quit(0)
