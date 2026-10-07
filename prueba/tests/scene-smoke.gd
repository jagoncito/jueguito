extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	var resource: BituResource = scene.resources[0]
	scene.player.position = resource.position + Vector2(0,-15)
	scene._find_target()
	assert(scene.target == resource, "Detectar la mena próxima")
	scene._interact()
	assert(scene.player.busy, "Extracción bloquea movimiento")
	scene._process(2.01)
	assert(not resource.active and not scene.player.busy, "Extracción termina y consume recurso")
	scene._process(0.02)
	assert(scene.inventory.count("mineral") == 1, "Botín físico entra por proximidad")
	scene.player.position = BituTerrain.cell_to_world(Vector2i(22,12))
	Input.action_press("move_right")
	Input.action_press("move_down")
	await create_timer(1.0).timeout
	Input.action_release("move_right")
	Input.action_release("move_down")
	assert(not scene.terrain.is_water(BituTerrain.world_to_cell(scene.player.position)), "Colisión impide entrar al agua")
	assert(scene.player.get_slide_collision_count() > 0, "Movimiento encuentra colisión real")
	print("BITU_SCENE_SMOKE_OK")
	scene.queue_free()
	await process_frame
	quit(0)
