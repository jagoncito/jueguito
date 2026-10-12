extends "res://scripts/main.gd"
## La partida de isla conserva los mismos controles, inventario y acciones.
var buildings_by_id := {}
var portals := {}
var room_cache := {}
var current_portal := ""
var near_portal := ""
var region_id := ""
var region_name: Label
var initial_note: Label
var zone_objects: Array[Node2D] = []
var cave_resources: Array[BituResource] = []
var nature_catalog: Dictionary
var active_objects_rect := Rect2()
var requested_zoom := -1
var nearby_candidates: Array = []

func _ready() -> void:
	if OS.has_feature("web"):
		var view = JavaScriptBridge.eval("new URLSearchParams(location.search).get('vista')")
		var scenes := {"dragon":"dragon","recursos":"recursos","personajes":"personajes","granja":"main"}
		if view != null and scenes.has(String(view)):
			set_process(false)
			get_tree().call_deferred("change_scene_to_file","res://scenes/"+scenes[String(view)]+".tscn")
			return
	_register_inputs()
	for id in TOMATO_IDS: textures[id] = load("res://assets/objetos/cultivos/%s.png" % id)
	for id in ["madera","mineral","flor"]: textures[id] = BituResourceArt.loot_texture(id)
	var info: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://assets/objetos/pesca/pez.json"))
	var fish := AtlasTexture.new()
	fish.atlas = load("res://assets/objetos/pesca/pez.png")
	fish.region = Rect2(info.region[0],info.region[1],info.region[2],info.region[3])
	fish.filter_clip = true
	textures["pez"] = fish
	terrain = BituIslandTerrain.new()
	add_child(terrain)
	objects = Node2D.new()
	objects.y_sort_enabled = true
	add_child(objects)
	_build_island()
	player = BituPlayer.new()
	player.equipment_enabled = true
	player.position = BituIslandLayout.point(BituIslandLayout.data().spawn)
	objects.add_child(player)
	_spawn_npcs()
	player.work_impact.connect(_on_work_impact)
	player.work_finished.connect(_on_work_finished)
	player.work_cancelled.connect(func(): task=null; progress.visible=false; _notify("No hay espacio para apoyar los pies. Prueba desde otro lado."))
	player.attack_impact.connect(_on_attack_impact)
	fishing = BituFishing.new()
	fishing.player = player
	fishing.terrain = terrain
	add_child(fishing)
	fishing.bite.connect(func(): _notify("¡Picada! Mantén clic para recoger; suelta si sube la tensión."))
	fishing.finished.connect(func(success: bool):
		progress.visible=false; tension_bar.visible=false
		if success: _spawn_drop("pez",player.global_position+Vector2(0,8))
		else: _notify(fishing.failure_reason+" Puedes volver a lanzar.")
	)
	practice_target = BituPracticeTarget.new()
	practice_target.position = Vector2(1390,850)
	objects.add_child(practice_target)
	zone_objects.append(practice_target)
	camera = Camera2D.new()
	camera.zoom = Vector2.ONE*ZOOMS[zoom_index]
	add_child(camera)
	_build_ui()
	_setup_house_interior()
	_refresh_backpack()
	set_region(BituIslandLayout.region(player.position))
	_notify("Despiertas en las ruinas. El sendero costero lleva al astillero. M abre el mapa.")
	_prepare_island_capture()
	_update_camera()
	(terrain as BituIslandTerrain).prime_view(camera.position,get_viewport().get_visible_rect().size,ZOOMS[zoom_index])
	print("BITU_ISLAND_READY:",JSON.stringify({"spawn":[player.position.x,player.position.y],"sites":BituIslandLayout.data().sites.size(),"npcs":npcs.size(),"trees":trees.size()}))
	print("BITU_READY")

func _build_island() -> void:
	nature_catalog = JSON.parse_string(FileAccess.get_file_as_string("res://assets/entorno/ruinas-camino/assets.json"))
	for site: Dictionary in BituIslandLayout.data().sites:
		if site.kind == "ruins": continue
		var point := BituIslandLayout.point(site.point)
		if site.kind == "home":
			home = BituHouse.new()
			objects.add_child(home)
			home.position = point-home.get_node("Entrada").position-Vector2(0,25)
			buildings_by_id[site.id] = home
			zone_objects.append(home)
			(terrain as BituIslandTerrain).buildings.append(home)
		else:
			var building := BituIslandBuilding.new()
			building.building_id = site.art
			building.position = point
			objects.add_child(building)
			buildings_by_id[site.id] = building
			zone_objects.append(building)
			(terrain as BituIslandTerrain).buildings.append(building)
		portals[site.id] = point
	for piece: Dictionary in BituIslandLayout.data().ruins:
		var prefab: PackedScene = load("res://assets/entorno/ruinas-camino/prefabs/"+piece.id+".tscn")
		var prop := prefab.instantiate() as Node2D
		prop.position = BituIslandLayout.point(piece.point)
		objects.add_child(prop)
		zone_objects.append(prop)
		# Huella pequeña bajo cada columna/muro; el patio y el arco siguen libres.
		if piece.id != "ruinas-arco":
			var body := StaticBody2D.new()
			body.position = prop.position
			var collider := CollisionShape2D.new()
			var shape := RectangleShape2D.new()
			shape.size = Vector2(80,18) if String(piece.id).contains("muro") else Vector2(24,16)
			collider.shape = shape
			body.add_child(collider)
			objects.add_child(body)
			zone_objects.append(body)
	for cell in terrain.farm_cells:
		var crop := BituCrop.new()
		crop.position = BituTerrain.cell_to_world(cell)
		objects.add_child(crop)
		crops.append(crop)
		zone_objects.append(crop)
		if crops.size()<=6:
			crop.plant()
			crop.growth = 12.0 if crops.size()<=3 else 5.0
	var rng := RandomNumberGenerator.new()
	rng.seed = 120126
	var attempts := 0
	while trees.size()<190 and attempts<5000:
		attempts += 1
		var at := Vector2(rng.randf_range(-3300,3200),rng.randf_range(-2300,2000))
		if not BituIslandLayout.is_land(at) or BituIslandLayout.is_river(at) or BituIslandLayout.on_path(at,118) or BituIslandLayout.shore_distance(at)<110: continue
		var forbidden := false
		for site: Dictionary in BituIslandLayout.data().sites:
			if at.distance_to(BituIslandLayout.point(site.point))<520: forbidden=true; break
		if BituIslandLayout.rect(BituIslandLayout.data().farm_rect).grow(120).has_point(at): forbidden=true
		for tree in trees:
			if at.distance_to(tree.position)<100: forbidden=true; break
		if forbidden: continue
		var tree := BituTree.new()
		tree.variant = trees.size()%3
		if at.y < -900 and trees.size()%3==0:
			tree.landscape_art = _nature_spec("costa-pino")
			tree.landscape_texture = load("res://assets/entorno/ruinas-camino/atlas/costa.png")
		tree.cell = BituTerrain.world_to_cell(at)
		tree.position = BituTerrain.cell_to_world(tree.cell)
		objects.add_child(tree)
		trees.append(tree)
		terrain.add_obstacle(tree.cell)
		zone_objects.append(tree)
	for point in [Vector2(-2360,-1220),Vector2(-2740,-1770),Vector2(-2040,-1730),Vector2(2960,1510),Vector2(2600,1060)]: _world_resource("ore",point)
	for point in [Vector2(840,-1190),Vector2(1250,-1160),Vector2(540,-1550),Vector2(-1910,800),Vector2(-550,550),Vector2(2640,1080),Vector2(3100,1570)]: _world_resource("flower",point)
	for pair in [[Vector2(3100,1500),"Astillero ↖"],[Vector2(1670,620),"Casas y granja ←"],[Vector2(-470,370),"Granja ↓"],[Vector2(-1390,-380),"Mina y herrería ↖"],[Vector2(630,-1140),"Unamahloni →"],[Vector2(-2170,1040),"Pesca y cocina ↙"]]:
		var sign := BituIslandFixture.new()
		sign.kind = "senal"
		sign.caption = pair[1]
		sign.position = pair[0]
		objects.add_child(sign)
		zone_objects.append(sign)
	_landscape_details()

func _nature_spec(id: String) -> Dictionary:
	for asset: Dictionary in nature_catalog.assets:
		if asset.id == id: return asset
	return {}

func _landscape_details() -> void:
	# Escarpes tras la mina y en la costa oriental, sin invadir los senderos.
	var ridges := [Vector2(-3160,-1870),Vector2(-3040,-1990),Vector2(-2930,-2130),Vector2(-2810,-2250),Vector2(-2660,-2360),Vector2(-2470,-2390),Vector2(-2310,-2380),Vector2(-2140,-2310),Vector2(-1930,-2130),Vector2(-1850,-1940),Vector2(-2980,-1630),Vector2(-3240,-1480)]
	for i in range(ridges.size()): _nature_prop("costa-acantilado-a" if i%2==0 else "costa-acantilado-b",ridges[i],true)
	for at in [Vector2(3750,1740),Vector2(3770,1900),Vector2(3670,2110),Vector2(3070,2160),Vector2(2900,2020),Vector2(2730,1560),Vector2(3120,1130),Vector2(3250,920)]:
		if BituIslandLayout.is_land(at) and not BituIslandLayout.on_path(at,100): _nature_prop("costa-acantilado-esquina-a",at,true)
	var rng := RandomNumberGenerator.new(); rng.seed=121026
	for i in range(95):
		var at := Vector2(rng.randf_range(-3200,3300),rng.randf_range(-2300,1900))
		if not BituIslandLayout.is_land(at) or BituIslandLayout.is_river(at) or BituIslandLayout.on_path(at,100): continue
		var forbidden := false
		for site: Dictionary in BituIslandLayout.data().sites:
			if at.distance_to(BituIslandLayout.point(site.point))<430: forbidden=true; break
		if forbidden or BituIslandLayout.rect(BituIslandLayout.data().farm_rect).grow(100).has_point(at): continue
		_nature_prop(["costa-roca","costa-arbusto-a","costa-flores-blancas","costa-hierbas"][i%4],at,i%4==0)

func _nature_prop(id: String, at: Vector2, solid: bool) -> void:
	if not BituIslandLayout.is_land(at) or BituIslandLayout.on_path(at,110): return
	var prefab: PackedScene=load("res://assets/entorno/ruinas-camino/prefabs/"+id+".tscn")
	var prop := prefab.instantiate() as Node2D
	prop.position=at
	objects.add_child(prop)
	zone_objects.append(prop)
	if solid:
		var body := StaticBody2D.new(); body.position=at
		var collider := CollisionShape2D.new(); var shape := RectangleShape2D.new()
		shape.size=Vector2(104,24) if id.contains("acantilado") else Vector2(34,16)
		collider.shape=shape; collider.position.y=-shape.size.y/2; body.add_child(collider); objects.add_child(body); zone_objects.append(body)

func _world_resource(kind: String, point: Vector2) -> void:
	var cell := BituTerrain.world_to_cell(point)
	_create_resource(kind,[cell,cell+Vector2i(1,0),cell+Vector2i(0,1)])
	zone_objects.append(resources[-1])

func _spawn_npcs() -> void:
	for id in NPC_ORDER:
		for site: Dictionary in BituIslandLayout.data().sites:
			if site.get("npc","") != id: continue
			var npc := BituNPC.new()
			npc.character_id = id
			npc.position = BituIslandLayout.point(site.point)+BituIslandLayout.point(site.npc_offset)
			npc.observer = player
			npc.show_name = true
			objects.add_child(npc)
			npc.set_meta("home",site.id)
			npcs.append(npc)
			zone_objects.append(npc)
	print("BITU_NPCS_READY:6")

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var hud := Control.new()
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(hud)
	var top := _panel()
	top.position = Vector2(20,18)
	hud.add_child(top)
	var title := VBoxContainer.new()
	top.add_child(title)
	title.add_child(_label("BĪTU",22,Color("e6cc83")))
	region_name = _label("Costa de las ruinas",14)
	title.add_child(region_name)
	var actions := HBoxContainer.new()
	hud.add_child(actions)
	actions.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	actions.offset_left=-240; actions.offset_right=-20; actions.offset_top=20; actions.offset_bottom=54
	var map_button := Button.new(); map_button.text = "M · Mapa"
	var bag_button := Button.new(); bag_button.text = "Tab · Mochila"
	actions.add_child(map_button); actions.add_child(bag_button)
	var prompt := _panel()
	hud.add_child(prompt)
	prompt.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	prompt.offset_left = -305; prompt.offset_right = 305; prompt.offset_top = -105; prompt.offset_bottom = -35
	var content := VBoxContainer.new()
	prompt.add_child(content)
	hint = _label("",14)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(hint)
	progress = ProgressBar.new(); progress.show_percentage=false; progress.custom_minimum_size.y=7; progress.visible=false
	content.add_child(progress)
	tension_bar = ProgressBar.new(); tension_bar.show_percentage=false; tension_bar.custom_minimum_size.y=7; tension_bar.visible=false
	var fill := StyleBoxFlat.new(); fill.bg_color=Color("d59448"); tension_bar.add_theme_stylebox_override("fill",fill)
	content.add_child(tension_bar)
	status = _label("",14,Color("e6cc83"))
	hud.add_child(status)
	status.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	status.offset_left=-300; status.offset_right=300; status.offset_top=-150; status.offset_bottom=-115
	status.custom_minimum_size.x = 580
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	initial_note = _label("WASD · andar    Shift · correr    E · interactuar    Esta prueba no guarda progreso",12,Color("a7b797"))
	hud.add_child(initial_note)
	initial_note.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	initial_note.offset_left=20; initial_note.offset_right=-20; initial_note.offset_top=-27; initial_note.offset_bottom=-5
	initial_note.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	menus = BituMenus.new(); menus.game = self; add_child(menus)
	backpack = menus.backpack; xp_label = menus.xp_label
	map_button.pressed.connect(menus.toggle_map)
	bag_button.pressed.connect(menus.toggle_backpack)

func _setup_house_interior() -> void:
	var layer := CanvasLayer.new(); layer.layer=100; add_child(layer)
	fade = ColorRect.new(); fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); fade.color=Color(0,0,0,0); fade.mouse_filter=Control.MOUSE_FILTER_IGNORE; layer.add_child(fade)

func _process(delta: float) -> void:
	super._process(delta)
	if player == null or transitioning: return
	if not indoors:
		var region := BituIslandLayout.region(player.global_position)
		if region.id != region_id: _change_region(region)
	if not indoors and requested_zoom>=0:
		var next_zoom: float = ZOOMS[requested_zoom]
		var next_camera := _camera_point_for_zoom(next_zoom)
		var size_px: Vector2 = get_viewport().get_visible_rect().size
		(terrain as BituIslandTerrain).update_view(next_camera,size_px,next_zoom)
		if (terrain as BituIslandTerrain).view_ready(next_camera,size_px,next_zoom):
			zoom_index = requested_zoom
			requested_zoom = -1
	_update_camera()
	if not indoors:
		(terrain as BituIslandTerrain).update_view(camera.position,get_viewport().get_visible_rect().size,ZOOMS[zoom_index])
		_refresh_nearby_objects()

func _camera_point_for_zoom(zoom: float) -> Vector2:
	var at := player.global_position+Vector2(0,-100)
	var visible_size: Vector2 = get_viewport().get_visible_rect().size/zoom
	var bounds: Rect2 = (interior as BituIslandRoom).bounds.grow(100) if indoors else BituIslandLayout.rect(BituIslandLayout.data().bounds)
	if indoors: bounds.position += BituHouseInterior.CENTER
	at.x = clampf(at.x,bounds.position.x+minf(visible_size.x/2,bounds.size.x/2),bounds.end.x-minf(visible_size.x/2,bounds.size.x/2))
	at.y = clampf(at.y,bounds.position.y+minf(visible_size.y/2,bounds.size.y/2),bounds.end.y-minf(visible_size.y/2,bounds.size.y/2))
	return at

func _update_camera() -> void:
	camera.position = _camera_point_for_zoom(ZOOMS[zoom_index])
	camera.zoom = Vector2.ONE*ZOOMS[zoom_index]

func _unhandled_input(event: InputEvent) -> void:
	if not indoors and not transitioning and event is InputEventMouseButton and event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN]:
		var current := requested_zoom if requested_zoom>=0 else zoom_index
		requested_zoom = clampi(current+(1 if event.button_index==MOUSE_BUTTON_WHEEL_UP else -1),0,ZOOMS.size()-1)
		get_viewport().set_input_as_handled()
		return
	super._unhandled_input(event)

func set_region(region: Dictionary) -> void:
	region_id = region.id
	if region_name != null: region_name.text = region.name
	_update_camera()
	_refresh_nearby_objects(true)
	print("BITU_ISLAND_REGION:",region_id)

func _refresh_nearby_objects(force := false) -> void:
	var size_px: Vector2 = get_viewport().get_visible_rect().size/ZOOMS[zoom_index]
	var view := Rect2(camera.position-size_px/2,size_px)
	if not force and active_objects_rect.has_area() and active_objects_rect.grow(-128).encloses(view.grow(600)): return
	active_objects_rect = view.grow(768)
	nearby_candidates.clear()
	for node in zone_objects:
		var active := active_objects_rect.has_point(node.global_position)
		if active and (node is BituCrop or node is BituResource or node is BituTree or node is BituNPC): nearby_candidates.append(node)
		if node.visible != active: node.visible = active
		var mode := Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
		if node.process_mode != mode: node.process_mode = mode

func _interaction_candidates() -> Array:
	return nearby_candidates

func _change_region(region: Dictionary) -> void:
	# Las regiones exteriores son geográficas, no una puerta ni una pausa.
	region_id = region.id
	region_name.text = region.name
	print("BITU_ISLAND_REGION:",region_id)

func _near_house_portal() -> bool:
	near_portal = ""
	if player == null: return false
	if indoors:
		return player.global_position.distance_to(BituHouseInterior.CENTER+(interior as BituIslandRoom).exit_point)<45
	var distance := 48.0
	for id in portals:
		var point: Vector2 = portals[id]
		var next := player.global_position.distance_to(point)
		if next<distance: distance=next; near_portal=id
	return not near_portal.is_empty()

func _find_target() -> void:
	super._find_target()
	if _near_house_portal(): hint.text = "E · Salir" if indoors else "E · Entrar: "+String(BituIslandLayout.site(near_portal).name)
	elif indoors: hint.text = "Mina · clic sobre la mena para minar" if current_portal=="mina" else "E junto a la puerta · salir"

func _change_house_zone() -> void:
	if transitioning or not _near_house_portal(): return
	transitioning=true
	requested_zoom = -1
	menus.close_all()
	fishing.cancel(); player.end_work(); _finish_work(); player.velocity=Vector2.ZERO; player.process_mode=Node.PROCESS_MODE_DISABLED
	var tween := create_tween(); tween.tween_property(fade,"color:a",1.0,.15); await tween.finished
	if not indoors:
		current_portal=near_portal
		return_point=portals[current_portal]+Vector2(0,28)
		if not room_cache.has(current_portal):
			var room := BituIslandRoom.new(); room.room_id=current_portal; add_child(room); room_cache[current_portal]=room
			for ore in room.ore_nodes: resources.append(ore); cave_resources.append(ore)
		interior=room_cache[current_portal]
		for room in room_cache.values(): room.visible=false; room.process_mode=Node.PROCESS_MODE_DISABLED
		interior.visible=true; interior.process_mode=Node.PROCESS_MODE_INHERIT
		player.reparent(interior.furnishings)
		player.global_position=BituHouseInterior.CENTER+(interior as BituIslandRoom).spawn_point
		player.face_towards(Vector2.UP)
		indoors=true
	else:
		player.reparent(objects); player.global_position=return_point; player.face_towards(Vector2.DOWN)
		interior.visible=false; interior.process_mode=Node.PROCESS_MODE_DISABLED; indoors=false
	terrain.visible=not indoors; terrain.process_mode=Node.PROCESS_MODE_DISABLED if indoors else Node.PROCESS_MODE_INHERIT
	objects.visible=not indoors; objects.process_mode=Node.PROCESS_MODE_DISABLED if indoors else Node.PROCESS_MODE_INHERIT
	region_name.text=location_name()
	_update_camera(); player.animate_pose(0)
	tween=create_tween(); tween.tween_property(fade,"color:a",0.0,.15); await tween.finished
	player.process_mode=Node.PROCESS_MODE_INHERIT; transitioning=false
	print("BITU_ISLAND_PORTAL:",current_portal,":",indoors)

func _primary_click(point: Vector2) -> void:
	if indoors:
		if transitioning or player.busy: return
		if current_portal=="mina" and _click_resource(point): return
		player.begin_attack(point)
		return
	super._primary_click(point)

func _spawn_drop(id: String, point: Vector2, amount := 1) -> void:
	var drop := BituLoot.new(); drop.item_id=id; drop.amount=amount; drop.position=point
	if indoors: interior.furnishings.add_child(drop)
	else: objects.add_child(drop)
	drops.append(drop)

func map_position() -> Vector2:
	return portals[current_portal] if indoors else player.global_position

func location_name() -> String:
	return BituIslandLayout.site(current_portal).name if indoors else BituIslandLayout.region(player.global_position).name

func _prepare_island_capture() -> void:
	if not OS.has_feature("web"): return
	if bool(JavaScriptBridge.eval("new URLSearchParams(location.search).get('muestra') === 'mochila'")):
		for pair in [["tomate",1000],["tomate-pristino",3],["tomate-siru",1],["mineral",18],["madera",64],["flor",5],["pez",2]]: inventory.add_item(pair[0],pair[1])
		_notify("Muestras de inventario para revisar la mochila")
	if bool(JavaScriptBridge.eval("new URLSearchParams(location.search).get('vista') === 'casa'")):
		player.position=portals.granja+Vector2(0,28)
		set_region(BituIslandLayout.region(player.position))
		_change_house_zone()
		return
	var requested = JavaScriptBridge.eval("new URLSearchParams(location.search).get('lugar')")
	if requested == null or BituIslandLayout.site(String(requested)).is_empty(): return
	player.position=BituIslandLayout.point(BituIslandLayout.site(String(requested)).point)+Vector2(0,75)
	set_region(BituIslandLayout.region(player.position))
	print("BITU_ISLAND_CAPTURE:",requested)
