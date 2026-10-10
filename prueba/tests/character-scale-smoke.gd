extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var preview: Node2D = load("res://scenes/personajes.tscn").instantiate()
	root.add_child(preview)
	preview.set_process(false)
	assert(preview.actors.size() == 7)
	for name in preview.ORDER:
		if name == "dragon":
			assert((preview.actors[6] as BituDragonVisual).catalog.frames.size() == 112)
		else:
			var frames: Array = preview.catalog.characters[name].frames
			assert(frames.size() == 8,"Todos los NPC tienen el mismo número de sprites")
			var directions := {}
			for frame: Dictionary in frames:
				assert(frame.action == "reposo" and frame.phase == 0)
				directions[frame.direction] = true
			assert(directions.size() == 8,"Una vista real por dirección")
	for direction in range(8):
		preview.direction = direction
		for variant in range(4):
			preview.variant = variant
			preview.walking = false
			preview._refresh()
			for actor: Node2D in preview.actors:
				assert(actor.scale == Vector2.ONE)
				if actor is Sprite2D:
					assert(actor.texture != null)
				else:
					assert(actor.body.texture != null)
		preview.walking = true
		for phase in range(4):
			preview.elapsed = (phase+0.1)/7
			preview._refresh()
	for name in preview.catalog.characters:
		var prefab: Node2D = load("res://assets/personajes/escala-juego/%s/personaje.tscn" % name).instantiate()
		root.add_child(prefab)
		var body: AnimatedSprite2D = prefab.get_node("Cuerpo")
		assert(body.scale == Vector2.ONE and body.position == Vector2(-64,-112))
		assert(body.sprite_frames.has_animation(body.animation))
		prefab.queue_free()
	print("BITU_CHARACTER_SCALE_SMOKE_OK")
	quit(0)
