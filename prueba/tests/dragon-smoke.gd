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
	assert(visual.catalog.frames.size() == 72,"Catálogo de ocho direcciones y nueve poses")
	assert(visual.body.scale.x == visual.body.scale.y,"Sin estirar anatomía en un eje")
	assert(actor.tool_mount.get_index()<visual.get_index(),"Cuerpo y dedos ocluyen herramienta")
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
		actor.walk_time = 1.0
		actor.animate_pose(0)
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
