extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	var resource: BituResource = scene.resources[0]
	scene._click_resource(resource.position+Vector2(15,-20))
	assert(scene.task == null, "Clic lejano no extrae ni mueve al personaje")
	scene.player.position = resource.position + Vector2(-40,10)
	scene._find_target()
	assert(scene.target == resource, "Detectar la mena próxima")
	scene._interact()
	assert(scene.task == null, "E ya no inicia minería")
	scene._click_resource(resource.position+Vector2(80,10))
	assert(scene.task == null, "Clic en suelo no usa el recurso cercano")
	var flower: BituResource = scene.resources[1]
	var flower_position := flower.position
	flower.position = resource.position+Vector2(-25,0)
	scene._find_target()
	assert(scene.target == flower, "Hay otro recurso más cercano")
	scene._click_resource(resource.position+Vector2(15,-20))
	assert(scene.task == resource, "El clic elige la mena señalada, no la flor más cercana")
	flower.position = flower_position
	assert(scene.player.busy, "Extracción bloquea movimiento")
	assert(scene.player.tool.visible and scene.player.tool.working, "Herramienta equipada realmente animada")
	assert(scene.player.work_kind == &"minar", "Extremo de minería seleccionado")
	await create_timer(0.4).timeout
	assert(resource.active and scene.inventory.count("mineral") == 0, "Primer golpe no entrega antes de acabar")
	assert(scene.task_hits == 1, "Un impacto por movimiento")
	scene._click_resource(resource.position+Vector2(15,-20))
	assert(scene.task_hits == 1, "Interactuar otra vez no reinicia ni duplica el trabajo")
	await create_timer(1.95).timeout
	assert(resource.active and scene.task_hits == 4 and scene.inventory.count("mineral") == 0, "Cuatro golpes aún no completan la minería inicial")
	await create_timer(0.95).timeout
	assert(scene.task_hits == 5, "La minería inicial necesita exactamente cinco golpes")
	assert(not resource.active and not scene.player.busy, "Extracción termina y consume recurso")
	assert(scene.task == null and not scene.player.tool.working, "Recuperar control tras el golpe final")
	assert(scene.inventory.count("mineral") == 1, "Botín físico entra por proximidad")
	var tree: BituTree = scene.trees[0]
	assert(scene.terrain.blocked.has(tree.cell), "El árbol empieza con colisión")
	scene.player.position = tree.position+Vector2(-40,10)
	scene._find_target()
	assert(scene.target == tree, "Se puede seleccionar el árbol")
	scene._click_resource(tree.position+Vector2(0,-30))
	assert(scene.player.work_kind == &"talar", "Cambiar automáticamente al lado de hacha")
	await create_timer(0.4).timeout
	assert(tree.active and tree.hits == 1, "Tala da feedback sin eliminar tras el primer golpe")
	assert(scene.inventory.count("madera") == 0, "No dar madera antes de talar")
	await create_timer(1.95).timeout
	assert(tree.active and tree.hits == 4 and scene.inventory.count("madera") == 0, "Cuatro golpes aún no completan la tala inicial")
	await create_timer(0.95).timeout
	assert(tree.hits == 5, "La tala inicial necesita exactamente cinco golpes")
	assert(not tree.active and tree.hits == BituTree.HITS_REQUIRED, "Árbol pasa a tocón tras los golpes")
	assert(scene.inventory.count("madera") == 3, "Madera recogida sin duplicación")
	assert(scene.terrain.is_walkable(tree.cell), "Quitar la colisión al talar")
	scene._find_target()
	assert(scene.target != tree, "El tocón no permite volver a extraer madera")
	scene._click_resource(tree.position+Vector2(0,-10))
	assert(scene.task == null, "Clic en tocón no duplica madera")
	var flowers: BituResource = scene.resources[1]
	scene.player.position = flowers.position+Vector2(-35,10)
	scene._find_target()
	scene._interact()
	assert(scene.task == null, "E ya no recoge flores")
	var plant_hits := [0]
	scene.player.herbal_tool.impact.connect(func(action: StringName):
		assert(action == &"recolectar", "Impacto propio de herboristería")
		assert(scene.player.herbal_tool.contact_point().distance_to(flowers.global_position+Vector2(0,-5)) < 1, "El palín alcanza la tierra junto a la planta")
		plant_hits[0] += 1
	)
	scene._click_resource(flowers.position+Vector2(0,-28))
	assert(scene.task == flowers and scene.player.busy, "Un clic inicia recolección de la flor elegida")
	assert(not scene.player.tool_mount.visible, "Recolectar flores guarda la herramienta")
	assert(scene.player.herbal_mount.visible and scene.player.herbal_tool.working, "Se equipa y anima el palín")
	await create_timer(0.5).timeout
	assert(scene.player.kneel_amount > 0.9, "El personaje está arrodillado al recolectar")
	assert(scene.player.primary_hand.position.distance_to(scene.player.herbal_mount.position) < 1, "La mano sigue el agarre del palín")
	scene._click_resource(flowers.position+Vector2(0,-28))
	assert(scene.task_time >= 0.5, "Otro clic no reinicia la recolección")
	assert(flowers.active and scene.inventory.count("flor") == 0, "No entregar flores antes de terminar")
	await create_timer(1.6).timeout
	assert(scene.inventory.count("flor") == 1 and scene.player.tool_mount.visible, "Recogida de flores y reposo conservados")
	assert(not scene.player.herbal_mount.visible and scene.player.kneel_amount == 0, "Guardar palín y volver de pie")
	assert(not flowers.active and flowers.cooldown > 0, "La flor inicia respawn al terminar")
	assert(plant_hits[0] == 1, "Una extracción, un botín")
	flowers.advance(BituResource.RESPAWN_SECONDS)
	scene.player.position = flowers.position+Vector2(35,10)
	scene._click_resource(flowers.position+Vector2(0,-28))
	assert(scene.player.facing == -1, "Recolectar también desde el lado derecho")
	await create_timer(2.1).timeout
	assert(scene.inventory.count("flor") == 2 and plant_hits[0] == 2, "Palín orientado y extracción completa en ambos sentidos")
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
