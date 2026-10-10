extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	assert(scene.terrain.surface_frames.size() == 6, "Dos variantes por cada suelo")
	assert(scene.terrain.surface_sources.size() == 2, "Fuentes compartidas, sin texturas por casilla")
	assert(scene.terrain.surface_material(Vector2i(7,7)) == "hierba")
	assert(scene.terrain.surface_material(Vector2i(17,20)) == "tierra")
	assert(scene.terrain.surface_material(Vector2i(22,10)) == "arena")
	assert(scene.terrain.surface_material(Vector2i(24,10)) == "agua")
	assert(scene.terrain.surface_material(Vector2i(12,16)) == "tierra", "Parcelas conservadas")
	var home: BituHouse
	for object in scene.objects.get_children():
		if object is BituHouse:
			home = object
	assert(home != null, "Casa nativa presente")
	assert(home.get_node("Entrada").global_position.distance_to(home.position + Vector2(60.3717,-123.3638)) < 0.1)
	# Approach the actual front door: collision must stop at the foundation,
	# without blocking the empty yard below the sprite's logical anchor.
	scene.player.position = home.get_node("Entrada").global_position + Vector2(0,45)
	Input.action_press("move_up")
	await create_timer(0.6).timeout
	Input.action_release("move_up")
	assert(scene.player.get_slide_collision_count() > 0, "La fachada detiene al jugador")
	assert(not Geometry2D.is_point_in_polygon(scene.player.position-home.position, BituHouse.FOUNDATION), "No penetrar los cimientos")
	scene.player.position = home.position + Vector2(0,-30)
	var start: Vector2 = scene.player.position
	Input.action_press("move_right")
	await create_timer(0.3).timeout
	Input.action_release("move_right")
	assert(scene.player.position.x > start.x+30, "Patio libre de colisión invisible")
	assert(scene.terrain.shore_mask(Vector2i(24,10)) == 1, "Orilla oeste contra tierra")
	assert(scene.terrain.shore_mask(Vector2i(31,10)) == 0, "El límite del mapa no inventa tierra")
	print("BITU_ENVIRONMENT_SMOKE_OK")
	quit()
