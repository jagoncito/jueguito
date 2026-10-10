extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	assert(scene.npcs.size() == 6, "Seis habitantes, sin duplicados")
	for npc: BituNPC in scene.npcs:
		npc.set_process(false)
		npc.observer = null
		var home: Vector2 = npc.position
		var seen := {}
		for sample in range(60):
			npc.motion_clock = sample / 10.0
			npc._process(0)
			seen[npc.direction_index] = true
			assert(npc.position == home, "Giro sin deslizar los pies")
			assert(npc.body.scale == Vector2.ONE and npc.body.position == Vector2(-64,-112), "Escala y apoyo nativos constantes")
		assert(seen.size() == 8, "Se conservan las ocho vistas vigentes")
		npc.motion_clock = 2.0
		npc._process(0)
		var frozen: StringName = npc.body.animation
		npc.review_paused = true
		npc._process(0.8)
		assert(npc.motion_clock == 2.0 and npc.body.animation == frozen, "Pausa real de la muestra")
		npc.review_paused = false
		npc._process(0.8)
		assert(npc.motion_clock > 2.0 and npc.body.animation != frozen, "Reanudar giros")
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = KEY_F6
	scene._unhandled_input(event)
	for npc in scene.npcs:
		assert(npc.review_paused, "F6 pausa el grupo")
	scene._unhandled_input(event)
	for npc in scene.npcs:
		assert(not npc.review_paused, "F6 reanuda el grupo")
	print("BITU_NPCS_SMOKE_OK: seis habitantes, ocho vistas, giro y pausa")
	scene.queue_free()
	await process_frame
	quit(0)
