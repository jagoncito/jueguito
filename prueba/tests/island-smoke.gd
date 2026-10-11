extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game = load("res://scenes/island.tscn").instantiate()
	root.add_child(game)
	await physics_frame
	await physics_frame
	assert(game.player.position==BituIslandLayout.point(BituIslandLayout.data().spawn),"El comienzo es en las ruinas")
	assert(game.npcs.size()==6 and game.portals.size()==10,"Todos los habitantes y destinos están presentes")
	for npc: BituNPC in game.npcs:
		var site := BituIslandLayout.site(npc.get_meta("home"))
		assert(npc.position.distance_to(BituIslandLayout.point(site.point))<160,"Cada NPC está en el patio de su propiedad")
	game.player.set_physics_process(false)
	# Comprobar las rutas trazadas mediante la colisión real del personaje.
	for node: Node2D in game.zone_objects:
		node.visible=true
		node.process_mode=Node.PROCESS_MODE_INHERIT
	await physics_frame
	var errors: Array[String] = []
	for route: Array in BituIslandLayout.data().paths:
		for i in range(route.size()-1):
			var a := BituIslandLayout.point(route[i])
			var b := BituIslandLayout.point(route[i+1])
			for j in range(ceili(a.distance_to(b)/20.0)+1):
				var at := a.lerp(b,minf(1.0,j*20.0/maxf(1,a.distance_to(b))))
				if BituIslandLayout.is_water(at): errors.append("Sendero sobre agua sin puente: %s" % at); break
			game.player.global_position=a
			var collision := KinematicCollision2D.new()
			if game.player.test_move(game.player.global_transform,b-a,collision):
				var collider: Node=collision.get_collider()
				var owner := collider.get_parent()
				var name: String=owner.building_id if owner is BituIslandBuilding else collider.display_name() if collider is BituNPC else str(collider.get_path())
				errors.append("Sendero bloqueado %s -> %s por %s" % [a,b,name])
	for error in errors: push_error(error)
	if not errors.is_empty(): quit(1); return
	game.player.set_physics_process(true)
	for id in game.portals:
		game.player.global_position=game.portals[id]+Vector2(0,28)
		game.set_region(BituIslandLayout.region(game.player.position))
		await physics_frame
		assert(game._near_house_portal(),"Entrada al alcance: "+id)
		game._interact()
		await settled(game)
		assert(game.indoors and not game.transitioning,"Entrada funcional: "+id)
		assert(game.player.is_visible_in_tree() and game.player.get_parent()==game.interior.furnishings)
		assert(game.map_position()==game.portals[id],"El mapa sitúa el interior en su edificio")
		var room: BituIslandRoom=game.interior
		if id == "mina":
			var ore := room.ore_nodes[0]
			game.player.global_position=ore.position+Vector2(35,10)
			game._begin_extraction(ore)
			await create_timer(4.4).timeout
			assert(not ore.active and game.task==null,"La mena de la galería se mina con cinco golpes")
			assert(game.drops.size()>0 or game.inventory.count("mineral")>0,"Botín de minería en el interior")
		game.player.global_position=BituHouseInterior.CENTER+room.exit_point-Vector2(0,28)
		game._interact()
		await settled(game)
		assert(not game.indoors and not game.transitioning,"Salida funcional: "+id)
		assert(game.player.global_position.distance_to(game.return_point)<1,"Se regresa al mismo acceso")
	# La nueva costa y el muelle reutilizan la pesca real, con captura y botín.
	game.player.global_position=Vector2(-3130,1710)
	game.set_region(BituIslandLayout.region(game.player.global_position))
	game.fishing.set_process(false)
	assert(BituIslandLayout.is_land(game.player.global_position),"Apoyo de pesca dentro del muelle")
	assert(game.fishing.start(Vector2(-3130,1790)),"Lanzamiento desde el muelle del pescador")
	game.fishing.advance(.81,false)
	game.fishing.advance(game.fishing.bite_delay+.01,false)
	var pulling := true
	for frame in range(1500):
		if game.fishing.stage!=BituFishing.Stage.REELING: break
		if game.fishing.tension>.70: pulling=false
		elif game.fishing.tension<.25: pulling=true
		game.fishing.advance(1.0/60.0,pulling)
	assert(game.fishing.stage==BituFishing.Stage.LANDING,"Captura con tensión en la costa de isla")
	game.fishing.advance(.51,false)
	await create_timer(.2).timeout
	assert(game.inventory.count("pez")==1 and not game.player.busy,"Botín del muelle entra en la mochila")
	game.fishing.set_process(true)
	# Cruzar una frontera exterior andando, sin teletransporte del fundido.
	game.inventory.add_item("madera",9)
	game.player.global_position=Vector2(1420,540)
	game.set_region(BituIslandLayout.region(game.player.global_position))
	Input.action_press("move_left")
	await create_timer(.9).timeout
	Input.action_release("move_left")
	await create_timer(.35).timeout
	assert(game.region_id=="vecinos" and not game.transitioning,"Cruce exterior real con fundido")
	assert(game.player.global_position.x<1400 and game.player.global_position.x>1200,"La transición conserva coordenadas continuas")
	assert(game.inventory.count("madera")==9,"La transición conserva mochila")
	var visible := Rect2(game.camera.position-root.get_visible_rect().size/(game.camera.zoom*2),root.get_visible_rect().size/game.camera.zoom)
	assert((game.terrain as BituIslandTerrain).draw_rect.encloses(visible),"El terreno cubre la cámara limitada por la región")
	game.player.position=BituIslandLayout.point(BituIslandLayout.data().spawn)
	game.set_region(BituIslandLayout.region(game.player.position))
	game.menus.toggle_map()
	assert(paused and game.menus.map_panel.visible and not game.backpack.visible)
	assert(game.menus.island_map.location==game.player.global_position)
	game.menus.toggle_backpack()
	assert(paused and game.backpack.visible and not game.menus.map_panel.visible)
	game.menus.close_all()
	assert(not paused)
	print("BITU_ISLAND_SMOKE_OK: ruinas, hogares, senderos,10interiores, mapa y pausa de menús")
	quit()

func settled(game: Node) -> void:
	var deadline := Time.get_ticks_msec()+5000
	while game.transitioning and Time.get_ticks_msec()<deadline: await process_frame
	await physics_frame
