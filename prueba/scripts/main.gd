extends Node2D

const TOMATO_IDS := ["tomate", "tomate-pristino", "tomate-siru", "tomate-siru-pristino"]
const NAMES := {"tomate":"Tomate", "tomate-pristino":"Tomate prístino", "tomate-siru":"Tomate Siru", "tomate-siru-pristino":"Siru prístino", "mineral":"Mena de cobre", "flor":"Flor de Yde", "madera":"Madera"}
var terrain: BituTerrain
var objects: Node2D
var player: BituPlayer
var camera: Camera2D
var crops: Array[BituCrop] = []
var resources: Array[BituResource] = []
var trees: Array[BituTree] = []
var drops: Array[BituLoot] = []
var inventory := BituInventory.new()
var textures: Dictionary = {}
var slot_views: Array[VBoxContainer] = []
var hint: Label
var status: Label
var progress: ProgressBar
var xp_label: Label
var backpack: PanelContainer
var target: Node2D
var task: Node2D
var task_time := 0.0
var task_hits := 0
var required_hits := 0
var task_complete := false
var tomato_xp := 0
var message_time := 0.0
var full_notice := 0.0
var zoom_index := 2
const ZOOMS := [0.75, 1.0, 1.5, 2.0]
const INTERACTION_RANGE := 47.0

func _ready() -> void:
	# El runtime web impide cambiar la escena por argumentos de arranque.
	# La revisión opcional se abre desde el proyecto, igual que en Godot.
	if OS.has_feature("web") and bool(JavaScriptBridge.eval("new URLSearchParams(location.search).get('vista') === 'dragon'")):
		set_process(false)
		get_tree().call_deferred("change_scene_to_file","res://scenes/dragon.tscn")
		return
	if OS.has_feature("web") and bool(JavaScriptBridge.eval("new URLSearchParams(location.search).get('vista') === 'recursos'")):
		set_process(false)
		get_tree().call_deferred("change_scene_to_file","res://scenes/recursos.tscn")
		return
	_register_inputs()
	for item_id in TOMATO_IDS:
		textures[item_id] = load("res://assets/objetos/cultivos/%s.png" % item_id)
	for item_id in ["madera","mineral","flor"]:
		textures[item_id] = BituResourceArt.loot_texture(item_id)
	terrain = BituTerrain.new()
	add_child(terrain)
	objects = Node2D.new()
	objects.y_sort_enabled = true
	add_child(objects)
	var home := BituDecoration.new()
	home.kind = "house"
	home.position = BituTerrain.cell_to_world(Vector2(15,9))
	objects.add_child(home)
	for cell in [Vector2i(9,15), Vector2i(11,22), Vector2i(18,8), Vector2i(20,21), Vector2i(6,12), Vector2i(7,20), Vector2i(19,4), Vector2i(4,17)]:
		var tree := BituTree.new()
		tree.variant = trees.size() % 3
		tree.cell = cell
		tree.position = BituTerrain.cell_to_world(cell)
		objects.add_child(tree)
		trees.append(tree)
		terrain.add_obstacle(cell)
	for cell in terrain.farm_cells:
		var crop := BituCrop.new()
		crop.position = BituTerrain.cell_to_world(cell)
		objects.add_child(crop)
		crops.append(crop)
		if crops.size() <= 6:
			crop.plant()
			crop.growth = 12.0 if crops.size() <= 3 else 5.0
	var ore_zone: Array[Vector2i] = [Vector2i(19,17),Vector2i(20,18),Vector2i(19,20),Vector2i(20,16)]
	var flower_zone: Array[Vector2i] = [Vector2i(20,13),Vector2i(22,14),Vector2i(21,16),Vector2i(22,18)]
	_create_resource("ore", ore_zone)
	_create_resource("flower", flower_zone)
	player = BituPlayer.new()
	player.equipment_enabled = true
	player.position = BituTerrain.cell_to_world(Vector2(17,16))
	objects.add_child(player)
	player.work_impact.connect(_on_work_impact)
	player.work_finished.connect(_on_work_finished)
	camera = Camera2D.new()
	camera.position = player.position + Vector2(0,-100)
	camera.zoom = Vector2.ONE * ZOOMS[zoom_index]
	add_child(camera)
	for index in range(TOMATO_IDS.size()):
		_spawn_drop(TOMATO_IDS[index], BituTerrain.cell_to_world(Vector2(20+index*0.5,20-index*0.5)))
	_build_ui()
	_refresh_backpack()
	print("BITU_READY")

func _register_inputs() -> void:
	var bindings := {"move_left":KEY_A,"move_right":KEY_D,"move_up":KEY_W,"move_down":KEY_S,"interact":KEY_E,"backpack":KEY_TAB,"sprint":KEY_SHIFT}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = bindings[action]
			InputMap.action_add_event(action,key)

func _create_resource(kind: String, zone: Array[Vector2i]) -> void:
	var resource := BituResource.new()
	resource.kind = kind
	resource.zone = zone
	resource.cell = zone[0]
	resource.position = BituTerrain.cell_to_world(resource.cell)
	objects.add_child(resource)
	resources.append(resource)

func _process(delta: float) -> void:
	camera.position = player.position + Vector2(0,-100)
	camera.zoom = Vector2.ONE * ZOOMS[zoom_index]
	for crop in crops:
		crop.advance(delta)
	for resource in resources:
		resource.advance(delta)
	for index in range(drops.size()-1,-1,-1):
		var drop := drops[index]
		drop.remaining_seconds -= delta
		if drop.remaining_seconds <= 0:
			drops.remove_at(index)
			drop.queue_free()
			continue
		if player.position.distance_to(drop.position) < 29:
			var remainder := inventory.add_item(drop.item_id,drop.amount)
			if remainder < drop.amount:
				print("BITU_PICKUP:",drop.item_id,":",drop.amount-remainder)
				_notify("+%d %s" % [drop.amount-remainder,NAMES[drop.item_id]])
				_refresh_backpack()
				drop.amount = remainder
			if remainder == 0:
				drops.remove_at(index)
				drop.queue_free()
			elif full_notice <= 0:
				_notify("Mochila llena. El objeto sigue en el suelo.")
				full_notice = 3.0
	full_notice -= delta
	message_time -= delta
	if message_time <= 0:
		status.text = ""
	if task != null:
		task_time += delta
		if required_hits == 0:
			progress.value = task_time / 2.0 * 100.0
	_find_target()
	if Input.is_action_just_pressed("interact") and task == null:
		_interact()
	if Input.is_action_just_pressed("backpack"):
		backpack.visible = not backpack.visible

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_click_resource(get_global_mouse_position())
			get_viewport().set_input_as_handled()
			return
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_index = mini(zoom_index+1,ZOOMS.size()-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_index = maxi(zoom_index-1,0)
		else:
			return
		camera.zoom = Vector2.ONE * ZOOMS[zoom_index]

func _click_resource(point: Vector2) -> void:
	if task != null or player.busy:
		return
	var clicked: Node2D
	for candidate in resources + trees:
		if not candidate.active:
			continue
		var local_point: Vector2 = candidate.to_local(point)
		var contains: bool = candidate.contains_visual_point(local_point)
		# Elegir el recurso visible delante si sus dibujos se solapan.
		if contains and (clicked == null or candidate.global_position.y >= clicked.global_position.y):
			clicked = candidate
	if clicked == null:
		return
	if player.global_position.distance_to(clicked.global_position) >= INTERACTION_RANGE:
		_notify("Acércate al recurso para trabajar")
		return
	_begin_extraction(clicked)

func _find_target() -> void:
	target = null
	var best_distance := INTERACTION_RANGE
	for candidate in crops + resources + trees:
		if (candidate is BituResource or candidate is BituTree) and not candidate.active:
			continue
		var distance := player.position.distance_to(candidate.position)
		if distance < best_distance:
			best_distance = distance
			target = candidate
	if task != null:
		if required_hits > 0:
			hint.text = "%s · %d/%d golpes" % ["Talando" if task is BituTree else "Minando",task_hits,required_hits]
		else:
			hint.text = "Recogiendo…"
	elif target is BituTree:
		hint.text = "Clic izquierdo en el árbol · Talar"
	elif target is BituResource:
		hint.text = "Clic izquierdo en la mena · Minar" if target.kind == "ore" else "Clic izquierdo en la flor · Recoger"
	elif target is BituCrop:
		if not target.planted:
			hint.text = "E · Plantar tomate"
		elif target.is_ripe():
			hint.text = "E · Cosechar tomate"
		elif target.water <= 0:
			hint.text = "E · Regar · el crecimiento está pausado"
		else:
			hint.text = "Tomate creciendo · %.0f%%" % (target.growth / 12.0 * 100.0)
	else:
		hint.text = "Acércate a una parcela, mena, flor o árbol"

func _interact() -> void:
	if task != null or player.busy:
		return
	if target is BituCrop:
		if not target.planted:
			target.plant()
			_notify("Tomate plantado. Ahora necesita agua.")
		elif target.is_ripe():
			_spawn_drop("tomate",target.position + Vector2(0,10))
			target.harvest()
			tomato_xp += 1
			xp_label.text = "Tomates cosechados: %d" % tomato_xp
		elif target.water <= 0:
			target.irrigate()
			_notify("Parcela regada")
		else:
			_notify("Tiene agua. Sigue creciendo.")

func _begin_extraction(resource: Node2D) -> void:
	task = resource
	task_time = 0
	task_hits = 0
	task_complete = false
	if task is BituTree:
		required_hits = BituTree.HITS_REQUIRED-task.hits
		player.begin_work(&"talar",task.position+Vector2(0,-24),task.global_position)
	elif task.kind == "ore":
		required_hits = 3
		player.begin_work(&"minar",task.position+Vector2(0,-22),task.global_position)
	else:
		required_hits = 0
		player.begin_gathering(task.position+Vector2(0,-5),task.global_position)
	progress.value = 0
	progress.visible = true

func _on_work_impact(action: StringName) -> void:
	if task == null or task_complete:
		return
	if required_hits == 0:
		if action == &"recolectar":
			var soil := BituHitEffect.new()
			soil.herbal = true
			soil.position = task.position+Vector2(0,-5)
			objects.add_child(soil)
			_deplete_task()
		return
	var expected := &"talar" if task is BituTree else &"minar"
	if action != expected:
		return
	task_hits += 1
	var effect := BituHitEffect.new()
	effect.wood = task is BituTree
	effect.position = task.position+Vector2(0,-24)
	objects.add_child(effect)
	if task is BituTree:
		task.hit()
	else:
		task.show_damage()
	progress.value = float(task_hits)/required_hits*100
	if task_hits >= required_hits:
		_deplete_task()

func _deplete_task() -> void:
	if task_complete:
		return
	task_complete = true
	var item_id := "madera" if task is BituTree else ("mineral" if task.kind == "ore" else "flor")
	var point := task.position+(player.position-task.position).normalized()*20
	_spawn_drop(item_id,point,3 if task is BituTree else 1)
	print("BITU_RESOURCE_DEPLETED:",item_id)
	if task is BituTree:
		terrain.remove_obstacle(task.cell)
	else:
		task.harvest()

func _on_work_finished() -> void:
	if task == null:
		return
	if task_complete:
		_finish_work()
	else:
		player.repeat_work()

func _finish_work() -> void:
	task = null
	player.end_work()
	progress.visible = false

func _spawn_drop(item_id: String, point: Vector2, amount: int = 1) -> void:
	var drop := BituLoot.new()
	drop.item_id = item_id
	drop.amount = amount
	drop.texture = textures.get(item_id)
	drop.position = point
	objects.add_child(drop)
	drops.append(drop)

func _notify(message: String) -> void:
	status.text = message
	message_time = 3.0

func _label(text_value: String, size: int = 16, color: Color = Color("e1ddba")) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",color)
	return label

func _panel() -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.075,0.12,0.10,0.95)
	style.border_color = Color("687550")
	style.set_border_width_all(1)
	style.set_content_margin_all(14)
	panel.add_theme_stylebox_override("panel",style)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	return panel

func _texture_view(texture: Texture2D, dimensions: Vector2 = Vector2(64,64)) -> TextureRect:
	var view := TextureRect.new()
	view.texture = texture
	view.custom_minimum_size = dimensions
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	view.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return view

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var hud := Control.new()
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(hud)
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var header := _panel()
	header.position = Vector2(22,20)
	hud.add_child(header)
	var headings := VBoxContainer.new()
	header.add_child(headings)
	headings.add_child(_label("BĪTU",30,Color("e6cc83")))
	headings.add_child(_label("Primera prueba · tu rincón del archipiélago",15))
	headings.add_child(_label("WASD · mover    Shift · sprint    Rueda · zoom    E · interactuar",14,Color("a7b797")))
	headings.add_child(_label("Clic izquierdo · minar, talar o recoger flores",14,Color("a7b797")))
	backpack = _panel()
	hud.add_child(backpack)
	backpack.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	backpack.offset_left = -302
	backpack.offset_right = -22
	backpack.offset_top = 20
	var bag_content := VBoxContainer.new()
	backpack.add_child(bag_content)
	bag_content.add_child(_label("MOCHILA  ·  Tab",18,Color("e6cc83")))
	bag_content.add_child(_label("Pico–hacha, palín y regadera · equipo",13,Color("a7b797")))
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation",8)
	grid.add_theme_constant_override("v_separation",8)
	bag_content.add_child(grid)
	for index in range(BituInventory.SLOT_COUNT):
		var slot := VBoxContainer.new()
		slot.custom_minimum_size = Vector2(76,85)
		grid.add_child(slot)
		slot_views.append(slot)
	xp_label = _label("Tomates cosechados: 0",14)
	bag_content.add_child(xp_label)
	var footer := _panel()
	footer.position = Vector2(22,557)
	hud.add_child(footer)
	var footer_content := VBoxContainer.new()
	footer.add_child(footer_content)
	footer_content.add_child(_label("CUATRO TOMATES · muestras para comparar",14,Color("e6cc83")))
	var samples := HBoxContainer.new()
	samples.add_theme_constant_override("separation",14)
	footer_content.add_child(samples)
	for item_id in TOMATO_IDS:
		var sample := VBoxContainer.new()
		sample.custom_minimum_size.x = 105
		samples.add_child(sample)
		sample.add_child(_texture_view(textures[item_id]))
		sample.add_child(_label(NAMES[item_id],13))
	var prompt := _panel()
	prompt.position = Vector2(505,618)
	hud.add_child(prompt)
	var prompt_content := VBoxContainer.new()
	prompt.add_child(prompt_content)
	hint = _label("",15)
	prompt_content.add_child(hint)
	progress = ProgressBar.new()
	progress.show_percentage = false
	progress.custom_minimum_size.y = 8
	progress.visible = false
	prompt_content.add_child(progress)
	status = _label("",15,Color("e6cc83"))
	status.position = Vector2(505,585)
	hud.add_child(status)
	var note := _label("Zona y gráficos de entorno provisionales · esta prueba no guarda progreso",13,Color("a7b797"))
	note.position = Vector2(505,691)
	hud.add_child(note)

func _refresh_backpack() -> void:
	for index in range(slot_views.size()):
		var view := slot_views[index]
		for child in view.get_children():
			view.remove_child(child)
			child.queue_free()
		if index < inventory.slots.size():
			var slot := inventory.slots[index]
			if textures.has(slot["id"]):
				view.add_child(_texture_view(textures[slot["id"]]))
			else:
				var icon_frame := Control.new()
				icon_frame.custom_minimum_size = Vector2(64,64)
				var icon := BituLoot.new()
				icon.item_id = slot["id"]
				icon.position = Vector2(32,58)
				icon.scale = Vector2(2,2)
				icon.set_process(false)
				icon_frame.add_child(icon)
				view.add_child(icon_frame)
			view.add_child(_label("%s ×%d" % [NAMES[slot["id"]],slot["amount"]],11))
		else:
			var empty := _label("·",28,Color("4c6049"))
			empty.custom_minimum_size = Vector2(64,64)
			view.add_child(empty)
			view.add_child(_label("Vacío",11,Color("65765b")))
