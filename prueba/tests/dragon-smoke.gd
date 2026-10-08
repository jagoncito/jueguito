extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	var actor: BituPlayer = scene.player
	var visual := actor.dragon
	assert(visual.head.texture == load("res://assets/personajes/dragon-avatar/dragon-idle.png"), "La cara debe usar el original, sin regeneración")
	for feature in [Vector2(480,548),Vector2(785,669),Vector2(595,742),Vector2(745,767)]:
		var point: Vector2 = (feature-Vector2(650,815))*visual.HEAD_SCALE
		assert(Geometry2D.is_point_in_polygon(point,visual.head.polygon), "Ojos y sonrisa enteros dentro del contorno")
	Input.action_press("move_down")
	await create_timer(0.25).timeout
	assert(visual.head.visible and not visual.back_head.visible, "Cara al caminar hacia la cámara")
	assert(actor.walk_time > 0, "Caminar anima el rig")
	assert(actor.primary_hand.position.distance_to(actor.tool_mount.position)<1, "La mano sigue el agarre al caminar")
	Input.action_release("move_down")
	Input.action_press("move_up")
	await create_timer(0.25).timeout
	assert(not visual.head.visible and visual.back_head.visible, "Vista de espalda al alejarse")
	Input.action_release("move_up")
	Input.action_press("move_left")
	await create_timer(0.15).timeout
	assert(actor.facing == -1 and visual.head.scale.x == -1, "Orientación izquierda reflejada")
	Input.action_release("move_left")
	actor.begin_work(&"minar",actor.global_position+Vector2(-30,0))
	for index in range(12):
		await create_timer(0.025).timeout
		var second_grip := actor.to_local(actor.tool.to_global(Vector2(0,-13.125)))
		assert(actor.primary_hand.position.distance_to(actor.tool_mount.position)<1, "Agarre principal durante el golpe")
		assert(actor.secondary_hand.position.distance_to(second_grip)<1, "Segunda mano sobre el mango en movimiento")
	actor.end_work()
	# El zoom de revisión no debe cambiar orientación ni registro de contacto.
	var enlarged := BituPlayer.new()
	enlarged.equipment_enabled = true
	enlarged.scale = Vector2(3,3)
	root.add_child(enlarged)
	var local_contact := Vector2(31,-8)
	actor.begin_work(&"minar",actor.to_global(local_contact))
	enlarged.begin_work(&"minar",enlarged.to_global(local_contact))
	assert(enlarged.facing_back == actor.facing_back, "La escala no cambia la vista de trabajo")
	assert(enlarged.tool_mount.position.is_equal_approx(actor.tool_mount.position), "Registro de golpe en coordenadas locales")
	assert(is_equal_approx(enlarged.tool_mount.rotation,actor.tool_mount.rotation), "La escala no cambia el ángulo de impacto")
	actor.end_work()
	enlarged.end_work()
	enlarged.queue_free()
	scene.queue_free()
	await process_frame
	print("BITU_DRAGON_SMOKE_OK")
	quit(0)
