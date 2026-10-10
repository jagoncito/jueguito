extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func wait_free(actor: BituPlayer) -> void:
	for frame in range(240):
		if not actor.busy: return
		await physics_frame
	assert(false,"Acción termina y devuelve control")

func run() -> void:
	for action in ["move_left","move_right","move_up","move_down"]:
		if not InputMap.has_action(action): InputMap.add_action(action)
	var actor := BituPlayer.new()
	actor.equipment_enabled = true
	root.add_child(actor)
	actor.work_finished.connect(actor.end_work)
	var visual := actor.dragon
	assert(visual.catalog.frames.size()==216,"Conjunto completo de movimiento, trabajo, pesca y garras")
	var sources := {}
	for key in visual.catalog.frames:
		var frame: Dictionary = visual.catalog.frames[key]
		if not sources.has(frame.file): sources[frame.file] = load(visual.DIRECTORY+frame.file).get_image()
		var image: Image = sources[frame.file]
		assert(image.get_pixel(frame.hand[0],frame.hand[1]).a>0.5,"Palma sobre dibujo: "+key)
		assert(frame.scale>0 and frame.anchor.size()==2,"Escala uniforme y apoyo válidos")
		assert(frame.region[0]+frame.region[2]<=image.get_width() and frame.region[1]+frame.region[3]<=image.get_height(),"Recorte dentro de fuente")
	var work_hits := [0]
	var attack_hits := [0]
	var plant_hits := [0]
	var expected := [Vector2.ZERO]
	var tool_id := actor.tool.get_instance_id()
	actor.work_impact.connect(func(action: StringName):
		if action==&"recolectar":
			plant_hits[0]+=1
			assert(actor.herbal_tool.contact_point().distance_to(expected[0])<1,"Palín alcanza tierra")
		else:
			work_hits[0]+=1
			assert(actor.tool.get_instance_id()==tool_id,"La misma herramienta sirve para ambos trabajos")
			assert(actor.tool.contact_point(action).distance_to(expected[0])<1,"Extremo activo toca recurso")
			var frame: Dictionary = visual.catalog.frames[visual.current_frame]
			assert(frame.working_end==("axe_edge" if action==&"talar" else "pick_tip"),"Pico y filo diferenciados")
	)
	actor.attack_impact.connect(func(_direction: Vector2): attack_hits[0]+=1)
	for index in range(8):
		actor.position=Vector2.ZERO
		actor.face_towards(BituPlayer.DIRECTIONS[index])
		actor.walk_time=0
		actor.animate_pose(0)
		assert(not actor.tool.visible and not visual.has_baked_tool(),"Manos libres al descansar")
		var resting_top := visual.body.position.y+visual.body.texture.get_image().get_used_rect().position.y*visual.body.scale.y
		for running in [false,true]:
			actor.sprinting=running
			var distinct := {}
			var factor := 0.0
			for phase in range(4):
				actor.walk_time=0.1+phase*1.15
				actor.animate_pose(0)
				if phase==0: factor=visual.body.scale.x
				assert(visual.body.scale==Vector2.ONE*factor,"Una escala por ciclo, sin estirar cuerpo")
				var image: Image=visual.body.texture.get_image()
				var top := visual.body.position.y+image.get_used_rect().position.y*factor
				assert(absf(resting_top-top)<2.0,"No crecer al andar/correr")
				distinct[hash(image.get_data())]=true
			assert(distinct.size()==4,"Cuatro pasos diferentes por dirección")
		actor.sprinting=false
		actor.walk_time=0
		for action in [&"minar",&"talar"]:
			visual.show_pose("golpe" if action==&"minar" else "golpe-talar",index)
			expected[0]=visual.contact_global(action)
			actor.begin_work(action,expected[0],actor.to_global(BituPlayer.DIRECTIONS[index]*35))
			assert(actor.direction_index==index,"El golpe mira a la base del recurso")
			await wait_free(actor)
		actor.position=Vector2.ZERO
		expected[0]=BituPlayer.DIRECTIONS[index].normalized()*35+Vector2(0,-5)
		actor.begin_gathering(expected[0],BituPlayer.DIRECTIONS[index]*35)
		await wait_free(actor)
		assert(actor.kneel_amount==0 and not actor.herbal_mount.visible,"Recolección recupera de pie")
		actor.begin_attack(actor.to_global(BituPlayer.DIRECTIONS[index]*35))
		assert(not actor.begin_attack(Vector2.ZERO),"Clics repetidos no duplican zarpazo")
		await wait_free(actor)
		actor.begin_fishing(actor.to_global(BituPlayer.DIRECTIONS[index]*35))
		for pose in ["pesca-cargar","pesca-esperar","pesca-recoger"]:
			actor.set_fishing_pose(pose)
			assert(visual.contact_global(&"sedal").is_finite(),"Sedal unido a punta de caña en ocho vistas")
		actor.end_work()
	assert(work_hits[0]==16 and plant_hits[0]==8 and attack_hits[0]==8,"Una señal por golpe/extracción en ocho vistas")
	# Desplazar el cuerpo físico antes del trabajo; el contacto sigue al recurso.
	actor.position=Vector2.ZERO
	actor.face_towards(Vector2.LEFT)
	expected[0]=Vector2(-35,-22)
	actor.begin_work(&"minar",expected[0],Vector2(-35,0))
	var initial := actor.position
	await wait_free(actor)
	assert(actor.position.distance_to(initial)>3,"Apoyo mueve colisión y pies, no solo dibujo")
	for action in ["move_left","move_right","move_up","move_down"]:
		if not InputMap.has_action(action): InputMap.add_action(action)
	Input.action_press("move_right"); Input.action_press("move_down")
	await create_timer(0.2).timeout
	assert(is_equal_approx(actor.velocity.length(),BituPlayer.SPEED),"Diagonal normalizada")
	Input.action_press("sprint")
	await create_timer(0.2).timeout
	assert(is_equal_approx(actor.velocity.length(),BituPlayer.SPRINT_SPEED) and visual.current_frame.begins_with("sprint-"),"Correr con Shift")
	Input.action_release("sprint");Input.action_release("move_right");Input.action_release("move_down")
	await create_timer(0.05).timeout
	assert(actor.walk_time==0,"Parada devuelve reposo")
	print("BITU_DRAGON_SMOKE_OK")
	actor.queue_free()
	await process_frame
	quit()
