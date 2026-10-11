extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var scene = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	var bag = scene.inventory
	var crop = scene.crops[0]
	var growth: float = crop.growth
	scene.player.position = scene.home.get_node("Entrada").global_position+Vector2(0,45)
	assert(scene._near_house_portal())
	scene._interact()
	assert(scene.transitioning)
	scene._interact()
	await create_timer(0.45).timeout
	assert(scene.indoors and not scene.transitioning)
	assert(scene.player.visible and scene.player.is_visible_in_tree())
	assert(not scene.objects.visible and scene.interior.visible)
	assert(scene.inventory == bag and scene.crops[0] == crop)
	assert(scene.player.global_position.distance_to(BituHouseInterior.CENTER+BituHouseInterior.EXIT) < 42)
	Input.action_press("move_up")
	await create_timer(0.3).timeout
	Input.action_release("move_up")
	assert(scene.player.global_position.y < BituHouseInterior.CENTER.y+158-15)
	# Wall collision remains stable at the rear corner.
	scene.player.global_position = BituHouseInterior.CENTER+Vector2(0,-215)
	Input.action_press("move_up")
	await create_timer(0.4).timeout
	Input.action_release("move_up")
	assert(scene.player.global_position.y > -241)
	scene.player.global_position = BituHouseInterior.CENTER+BituHouseInterior.EXIT-Vector2(0,32)
	scene._interact()
	await create_timer(0.45).timeout
	assert(not scene.indoors and scene.objects.visible and not scene.interior.visible)
	assert(scene.player.get_parent() == scene.objects)
	assert(scene.inventory == bag and scene.crops[0] == crop)
	assert(crop.growth >= growth)
	assert(scene.player.global_position.distance_to(scene.return_point)<1)
	assert(not Geometry2D.is_point_in_polygon(scene.player.position-scene.home.position,BituHouse.FOUNDATION))
	print("BITU_INTERIOR_SMOKE_OK")
	quit()
