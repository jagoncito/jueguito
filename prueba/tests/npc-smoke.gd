extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	assert(scene.npcs.size()==6,"Los seis NPC están en la partida")
	assert(scene.objects.y_sort_enabled,"Profundidad común con el protagonista")
	for npc: BituNPC in scene.npcs:
		assert(npc.body.sprite_frames.get_animation_names().size()==8)
		assert(npc.body.scale==Vector2.ONE and npc.body.position==Vector2(-64,-112))
		assert(scene.terrain.is_walkable(BituTerrain.world_to_cell(npc.position)),"No aparecer en agua o cimientos")
		var seen := {}
		for direction in range(8):
			npc.set_direction(direction)
			seen[npc.body.animation] = true
		assert(seen.size()==8)
		# Interacción próxima, giro hacia el jugador y nombre correcto; sin mover NPC.
		var support := npc.position
		scene.player.position = npc.position+Vector2(0,28)
		scene._find_target()
		assert(scene.target==npc,"Interacción contextual del habitante próximo")
		scene._interact()
		assert(scene.status.text.begins_with(npc.display_name()))
		assert(npc.direction_index==0 and npc.position==support,"Hablar sin marcha ni teletransporte")
	# Colisión en pies: caminar hacia un habitante no atraviesa su apoyo.
	var first: BituNPC = scene.npcs[0]
	scene.player.position = first.position+Vector2(0,35)
	Input.action_press("move_up")
	await create_timer(.3).timeout
	Input.action_release("move_up")
	assert(scene.player.position.y>first.position.y+10)
	# El ajuste gráfico conserva el origen del suelo y no modifica la colisión.
	var before: Vector2 = scene.player.position
	scene.player.dragon.show_pose("sin-equipo",0)
	var original_scale: float = scene.player.dragon.body.scale.x
	scene.player.dragon.set_presentation_height(72)
	assert(is_equal_approx(scene.player.dragon.body.scale.x/original_scale,.9))
	assert(scene.player.position==before)
	scene.player.dragon.set_presentation_height(80)
	assert(is_equal_approx(scene.player.dragon.body.scale.x,original_scale))
	# Ocho vistas y ambos extremos mantienen contacto al reducir el dibujo.
	var worker := BituPlayer.new()
	worker.equipment_enabled = true
	root.add_child(worker)
	worker.set_process(false)
	worker.set_physics_process(false)
	for height in [80.0,72.0]:
		worker.dragon.set_presentation_height(height)
		for direction in range(8):
			var ground: Vector2 = BituPlayer.DIRECTIONS[direction].normalized()*35
			for action in [&"minar",&"talar"]:
				var contact := ground+Vector2(0,-22 if action == &"minar" else -24)
				worker.begin_work(action,contact,ground)
				worker.animate_pose(0,.33)
				assert(worker.tool.contact_point(action).distance_to(contact)<1,"Contacto real a ambas escalas")
				worker.end_work()
			worker.begin_gathering(ground+Vector2(0,-5),ground)
			worker.herbal_tool.motion.pause()
			worker.herbal_tool.motion.custom_step(1.5)
			worker.animate_pose(0)
			assert(worker.herbal_tool.contact_point().distance_to(ground+Vector2(0,-5))<1,"Palín conserva contacto a ambas escalas")
			worker.end_work()
	worker.queue_free()
	print("BITU_NPC_SMOKE_OK")
	quit(0)
