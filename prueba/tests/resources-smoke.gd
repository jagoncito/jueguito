extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var catalog := BituResourceArt.catalog()
	assert(catalog["frames"].size() == 12,"Doce recortes de terreno, estados y botín")
	for id in catalog["frames"]:
		var texture := BituResourceArt.texture(id)
		var image := texture.atlas.get_image()
		assert(texture.region.position.x >= 0 and texture.region.end.x <= image.get_width())
		assert(texture.region.position.y >= 0 and texture.region.end.y <= image.get_height())
		assert(image.get_pixel(0,0).a == 0,"Atlas con fondo transparente")
		assert(not BituResourceArt.contains(id,BituResourceArt.bounds(id).position-Vector2.ONE))
	assert(is_equal_approx(BituResourceArt.bounds("tree-0").size.y,192))
	assert(is_equal_approx(BituResourceArt.bounds("tree-1").size.y,208))
	assert(is_equal_approx(BituResourceArt.bounds("ore").size.x,56))
	assert(is_equal_approx(BituResourceArt.bounds("yde").size.y,36))
	assert(BituResourceArt.contains("ore",Vector2(15,-20)),"Cobre seleccionable en su dibujo")
	assert(BituResourceArt.contains("tree-0",Vector2(0,-30)),"Tronco seleccionable")
	assert(BituResourceArt.contains("yde",Vector2(0,-28)),"Pétalos seleccionables")
	for pair in [["ore","loot-copper"],["yde","loot-yde"],["tree-0","loot-wood"]]:
		assert(BituResourceArt.texture(pair[0]).region != BituResourceArt.texture(pair[1]).region,"Botín no es el recurso en miniatura")
	var scene: Node2D = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	assert(scene.trees[0].variant == 0 and scene.trees[1].variant == 1 and scene.trees[2].variant == 2)
	var tree: BituTree = scene.trees[0]
	for hit in range(4):
		tree.hit()
	assert(tree.visual_id() == "stump-0" and not tree.contains_visual_point(Vector2.ZERO))
	var ore: BituResource = scene.resources[0]
	ore.show_damage()
	assert(ore.visual_id() == "ore-damaged")
	ore.harvest()
	var old_cell := ore.cell
	ore.advance(BituResource.RESPAWN_SECONDS)
	assert(ore.active and ore.visible and not ore.damaged and ore.cell != old_cell)
	for item_id in ["madera","mineral","flor"]:
		scene._spawn_drop(item_id,Vector2(9000,9000))
		var drop: BituLoot = scene.drops.back()
		var size := drop.sprite.texture.get_size()*drop.sprite.scale
		assert(size.x <= 28.01 and size.y <= 28.01,"Botín dentro del marco 32 con margen")
		var icon: TextureRect = scene._texture_view(drop.texture)
		assert(icon.custom_minimum_size == Vector2(64,64))
		icon.free()
		assert(drop.remaining_seconds == 600,"No cambiar caducidad del botín")
	scene.queue_free()
	await process_frame
	var preview: Node2D = load("res://scenes/recursos.tscn").instantiate()
	root.add_child(preview)
	await process_frame
	assert(preview.tree.sprite.texture is AtlasTexture)
	for child in preview.get_children():
		if child is TextureRect:
			assert(child.size == Vector2(64,64),"Icono de revisión a 64, no al tamaño del atlas fuente")
	preview.queue_free()
	await process_frame
	print("BITU_RESOURCES_SMOKE_OK")
	quit(0)
