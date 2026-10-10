extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	var actor: BituPlayer = scene.player
	var dummy: BituPracticeTarget = scene.practice_target
	actor.position=dummy.position+Vector2(35,0)
	scene._primary_click(dummy.position+Vector2(0,-35))
	assert(actor.activity=="zarpazo" and actor.direction_index==2,"Clic enemigo mira a sus pies y ataca")
	scene._primary_click(dummy.position+Vector2(0,-35))
	await create_timer(.32).timeout
	assert(dummy.health==2,"Un único contacto por ataque, sin duplicar clics")
	await create_timer(.25).timeout
	assert(not actor.busy,"Zarpazo devuelve movimiento")
	actor.position=dummy.position+Vector2(90,0)
	scene._primary_click(dummy.position+Vector2(0,-35))
	await create_timer(.6).timeout
	assert(dummy.health==2,"Atacar fuera de alcance no daña")
	actor.position=dummy.position+Vector2(35,0)
	scene._primary_click(actor.position+Vector2(50,0))
	await create_timer(.6).timeout
	assert(dummy.health==2,"Zarpazo al aire no daña objetivo detrás")
	# Prioridad del recurso aun estando fuera de alcance: nunca zarpazo accidental.
	actor.position=Vector2(-300,700)
	scene._primary_click(scene.resources[0].position+Vector2(15,-20))
	assert(not actor.busy and scene.task==null,"Mena lejana pide acercarse, no ataca")
	actor.position=BituTerrain.cell_to_world(Vector2(22,22))
	var water := BituTerrain.cell_to_world(Vector2(23,22))
	var fish: BituFishing = scene.fishing
	fish.set_process(false)
	scene._primary_click(water)
	assert(fish.stage==BituFishing.Stage.CASTING and actor.busy,"Clic en agua desde costa inicia caña")
	scene._primary_click(dummy.position)
	assert(actor.activity=="pesca","Clic ocupado no cambia pesca por ataque")
	fish.advance(.81,false);fish.advance(fish.bite_delay+.01,false)
	assert(fish.stage==BituFishing.Stage.REELING,"Lanzamiento y picada preceden desafío")
	var initial_tension := fish.tension
	fish.advance(.3,true)
	assert(fish.tension>initial_tension and fish.progress>0,"Recoger acerca pez y aumenta tensión")
	var initial_progress := fish.progress
	var high_tension := fish.tension
	fish.advance(.2,false)
	assert(fish.tension<high_tension and fish.progress<initial_progress,"Aflojar controla sedal; avance puede retroceder")
	var pulling := true
	for frame in range(1500):
		if fish.stage!=BituFishing.Stage.REELING: break
		if fish.tension>.70: pulling=false
		elif fish.tension<.25: pulling=true
		fish.advance(1.0/60.0,pulling)
	assert(fish.stage==BituFishing.Stage.LANDING,"Responder a tensión permite capturar")
	fish.advance(.51,false)
	await create_timer(.1).timeout
	assert(not actor.busy and scene.inventory.count("pez")==1,"Captura produce botín real y vuelve a reposo")
	assert(fish.start(water),"Se puede volver a pescar")
	fish.advance(.81,false);fish.advance(fish.bite_delay+.01,false)
	for frame in range(400):
		fish.advance(1.0/60.0,true)
		if fish.stage==BituFishing.Stage.IDLE: break
	assert(fish.stage==BituFishing.Stage.IDLE and not actor.busy,"Tirar sin aflojar rompe el sedal")
	assert(scene.inventory.count("pez")==1,"Fallo no duplica capturas")
	fish.start(water)
	var cancel := InputEventKey.new();cancel.pressed=true;cancel.physical_keycode=KEY_ESCAPE
	scene._unhandled_input(cancel)
	assert(fish.stage==BituFishing.Stage.IDLE and not actor.busy,"Esc limpia pesca y libera control")
	assert(not fish.start(BituTerrain.cell_to_world(Vector2(28,22))),"No pescar lejos de costa")
	assert(not fish.start(actor.position),"No lanzar caña sobre tierra")
	print("BITU_ACTIONS_SMOKE_OK")
	scene.queue_free()
	await process_frame
	quit()
