extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var actor := BituPlayer.new()
	actor.equipment_enabled = true
	root.add_child(actor)
	actor.set_physics_process(false)
	actor.work_finished.connect(actor.end_work)
	var visual := actor.dragon
	assert(visual.catalog.frames.size() == 80,"Ocho direcciones y cuatro fases de marcha distintas")
	assert(visual.body.scale.x == visual.body.scale.y,"Sin estirar anatomía en un eje")
	assert(actor.tool_mount.get_index()>visual.get_index(),"Herramienta frontal delante del cuerpo")
	assert(visual.hand_cover.get_index()>actor.tool_mount.get_index(),"Dedos sobre el mango")
	var source_images: Dictionary = {}
	for key in visual.catalog.frames:
		var frame: Dictionary = visual.catalog.frames[key]
		if not source_images.has(frame.file):
			source_images[frame.file] = load(visual.DIRECTORY+frame.file).get_image()
		assert(source_images[frame.file].get_pixel(frame.hand[0],frame.hand[1]).a>0.5,"Palma sobre píxeles dibujados: "+key)
	var seen: Dictionary = {}
	var hits := [0]
	var work_hits := [0]
	actor.tool.impact.connect(func(action: StringName):
		assert(actor.tool.contact_point(action).distance_to(actor.to_global(actor.work_contact))<1,"Punta del pico o filo del hacha sobre el recurso al impactar")
		work_hits[0] += 1
	)
	actor.herbal_tool.impact.connect(func(_action: StringName):
		assert(actor.herbal_tool.contact_point().distance_to(actor.to_global(actor.plant_contact))<1,"Palín registrado con tierra en todas las vistas")
		hits[0] += 1
	)
	for index in range(8):
		var direction: Vector2 = BituPlayer.DIRECTIONS[index].normalized()
		actor.face_towards(direction)
		var phases: Dictionary = {}
		for phase in range(4):
			actor.walk_time = 0.1+phase*1.15
			actor.animate_pose(0)
			var texture := visual.body.texture as AtlasTexture
			phases[str(texture.atlas.resource_path,texture.region)] = true
			assert(actor.primary_hand.position.distance_to(actor.tool_mount.position)<0.01,"Agarre registrado en cada fase")
			assert(actor.tool.direction_index == index,"Perspectiva de herramienta acompaña al cuerpo")
			assert((actor.tool_mount.get_index()<visual.get_index()) == visual.tool_behind,"Profundidad del agarre según vista")
			assert(visual.hand_cover.position.is_equal_approx(actor.primary_hand.position+visual.cover_offset),"Dedos registrados sobre la palma")
		assert(phases.size()==4,"Cuatro dibujos distintos por dirección, sin paso intermedio repetido")
		assert(actor.direction_index == index,"Ocho direcciones sin reflejar la cara original")
		seen[visual.current_frame] = true
		assert(actor.primary_hand.position.distance_to(actor.tool_mount.position)<0.01,"Agarre de marcha")
		actor.walk_time = 0
		# El golpe elevado puede estar al norte aunque la mena esté al sur.
		var ground := direction*35
		actor.face_towards(-direction)
		actor.begin_work(&"minar",ground+Vector2(0,-22),ground)
		assert(actor.direction_index == index and visual.direction_index == index,"Girar inmediatamente hacia base del recurso")
		await create_timer(.18).timeout
		assert(visual.current_frame.begins_with("cargar-"),"Carga completa del cuerpo")
		assert(actor.direction_index == index,"Orientación fija durante el golpe")
		assert(actor.primary_hand.position.distance_to(actor.tool_mount.position)<0.01,"Agarre del golpe en palma dibujada")
		await create_timer(.18).timeout
		assert(visual.current_frame.begins_with("golpe-"),"Impacto completo del cuerpo")
		assert(visual.body.scale.x == visual.body.scale.y,"Cabeza, brazos, piernas y cola no se deforman")
		actor.end_work()
		actor.begin_work(&"talar",ground+Vector2(0,-24),ground)
		await create_timer(.36).timeout
		assert(visual.current_frame.begins_with("golpe-"),"Tala completa y filo registrado en ocho vistas")
		actor.end_work()
		actor.face_towards(-direction)
		actor.begin_gathering(ground+Vector2(0,-5),ground)
		assert(actor.direction_index == index,"Recolectar gira el cuerpo entero")
		await create_timer(.5).timeout
		assert(visual.current_frame.begins_with("arrodillado-"),"Recolección arrodillada en ocho vistas")
		assert(actor.primary_hand.position.distance_to(actor.herbal_mount.position)<0.01,"Palma sobre palín sin brazos desplazados")
		await create_timer(1.6).timeout
		assert(not actor.busy and actor.kneel_amount == 0,"Recuperar postura y control")
	assert(seen.size() == 8 and hits[0] == 8 and work_hits[0] == 16,"Ocho vistas distintas, contactos de pico/hacha y ocho extracciones")
	# La marcha sigue el desplazamiento real y las diagonales no son más rápidas.
	for action in ["move_left","move_right","move_up","move_down"]:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
	actor.set_physics_process(true)
	for index in [2,3,4,5,7]:
		var direction: Vector2 = BituPlayer.DIRECTIONS[index]
		var actions: Array[String] = []
		if direction.x < 0: actions.append("move_left")
		if direction.x > 0: actions.append("move_right")
		if direction.y < 0: actions.append("move_up")
		if direction.y > 0: actions.append("move_down")
		var start := actor.position
		for action in actions: Input.action_press(action)
		await create_timer(.3).timeout
		assert(actor.direction_index == index,"Vista según movimiento real, incluida izquierda y espalda")
		assert(actor.position.distance_to(start)>30,"Desplazamiento efectivo")
		assert(is_equal_approx(actor.velocity.length(),BituPlayer.SPEED),"Velocidad diagonal normalizada")
		assert(actor.walk_time>0,"Marcha activa al avanzar")
		for action in actions: Input.action_release(action)
		await create_timer(.04).timeout
		assert(actor.walk_time==0,"Reposo al dejar de desplazarse")
	# Sprint provisional: conserva la dirección y aumenta la velocidad sin
	# cambiar el tamaño ni el ciclo de las poses del personaje.
	var sprint_start := actor.position
	Input.action_press("move_right")
	Input.action_press("sprint")
	await create_timer(.3).timeout
	assert(actor.position.distance_to(sprint_start)>45,"Shift activa el sprint")
	assert(is_equal_approx(actor.velocity.length(),BituPlayer.SPRINT_SPEED),"Velocidad de sprint registrada")
	Input.action_release("sprint")
	Input.action_release("move_right")
	await create_timer(.04).timeout
	actor.set_physics_process(false)
	actor.position = Vector2.ZERO
	var wall := StaticBody2D.new()
	var wall_collision := CollisionShape2D.new()
	var wall_shape := RectangleShape2D.new()
	wall_shape.size = Vector2(10,300)
	wall_collision.shape = wall_shape
	wall.add_child(wall_collision)
	wall.position = Vector2(16,-3)
	root.add_child(wall)
	actor.set_physics_process(true)
	Input.action_press("move_right")
	await create_timer(.3).timeout
	assert(actor.position.x<6 and actor.walk_time==0,"No caminar en el sitio contra un obstáculo")
	Input.action_press("move_up")
	await create_timer(.2).timeout
	assert(actor.direction_index==4,"Al deslizarse, orientar hacia el desplazamiento real")
	Input.action_release("move_right")
	Input.action_release("move_up")
	actor.set_physics_process(false)
	actor.position = Vector2.ZERO
	wall.queue_free()
	# Regresión: la base está al sur y el impacto elevado queda al norte.
	actor.face_towards(Vector2.UP)
	actor.begin_work(&"minar",Vector2(0,-12),Vector2(0,10))
	assert(actor.direction_index == 0 and not actor.facing_back,"La altura del golpe no decide la vista del cuerpo")
	actor.end_work()
	var enlarged := BituPlayer.new()
	enlarged.equipment_enabled = true
	enlarged.scale = Vector2(3,3)
	root.add_child(enlarged)
	enlarged.set_physics_process(false)
	actor.begin_work(&"talar",Vector2(35,-22),Vector2(35,0))
	enlarged.begin_work(&"talar",enlarged.to_global(Vector2(35,-22)),enlarged.to_global(Vector2(35,0)))
	assert(enlarged.direction_index == actor.direction_index,"Escala de revisión no altera dirección")
	assert(enlarged.tool_mount.position.is_equal_approx(actor.tool_mount.position),"Escala no altera registro")
	assert(is_equal_approx(enlarged.tool_mount.rotation,actor.tool_mount.rotation),"Escala no altera agarre")
	actor.queue_free()
	enlarged.queue_free()
	await process_frame
	print("BITU_DRAGON_SMOKE_OK")
	quit(0)
