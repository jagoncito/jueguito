class_name BituMenus
extends CanvasLayer
## Menús persistentes: pausan la simulación y consumen los clics del overlay.
var game: Node2D
var backpack: BituBackpackMenu
var map_panel: PanelContainer
var island_map: BituIslandMap
var map_subtitle: Label
var shade: ColorRect
var root_control: Control
var xp_label: Label
var review_enabled := false
var review_clock := 0.0

func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	root_control = Control.new()
	root_control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root_control)
	shade = ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.02,0.07,0.06,0.75)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	root_control.add_child(shade)
	backpack = BituBackpackMenu.new()
	backpack.inventory = game.inventory
	backpack.textures = game.textures
	backpack.names = game.NAMES
	root_control.add_child(backpack)
	backpack.close_requested.connect(close_all)
	xp_label = backpack.xp_label
	map_panel = PanelContainer.new()
	map_panel.add_theme_stylebox_override("panel",BituBackpackMenu.panel_style())
	map_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	root_control.add_child(map_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation",12)
	map_panel.add_child(content)
	var header := HBoxContainer.new()
	content.add_child(header)
	var title := BituBackpackMenu.label("ISLA BĪTU",26,Color("e5c783"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	var close := Button.new()
	close.text = "Cerrar ×"
	close.pressed.connect(close_all)
	header.add_child(close)
	map_subtitle = BituBackpackMenu.label("",14,Color("9eb7a6"))
	content.add_child(map_subtitle)
	island_map = BituIslandMap.new()
	island_map.game = game
	content.add_child(island_map)
	content.add_child(BituBackpackMenu.label("M / Esc · cerrar    Cabeza del dragón · ubicación actual",13,Color("9eb7a6")))
	map_panel.visible = false
	shade.visible = false
	get_viewport().size_changed.connect(_layout)
	call_deferred("_layout")
	if OS.has_feature("web"):
		review_enabled = bool(JavaScriptBridge.eval("new URLSearchParams(location.search).get('verificar') === '1'"))

func _screen_rect(control: Control) -> Array:
	var transform := control.get_global_transform_with_canvas()
	var start := transform*Vector2.ZERO
	var end := transform*control.size
	return [start.x,start.y,end.x-start.x,end.y-start.y]

func _process(delta: float) -> void:
	if not review_enabled: return
	review_clock += delta
	if review_clock < .15: return
	review_clock = 0
	var slot_data := []
	var counts := {}
	for slot in backpack.slots:
		var item: Dictionary = game.inventory.item_at(slot.index)
		slot_data.append({"rect":_screen_rect(slot),"id":item.get("id",""),"amount":item.get("amount",0),"quantity":slot.quantity.text})
		if not item.is_empty(): counts[item.id] = game.inventory.count(item.id)
	var position: Vector2 = game.map_position() if game.has_method("map_position") else game.player.global_position
	var marker: Vector2 = island_map.get_global_transform_with_canvas()*island_map.project(position)
	var viewport := get_viewport().get_visible_rect().size
	var state := {"player":[game.player.global_position.x,game.player.global_position.y],"position":[position.x,position.y],"map":map_panel.visible,"backpack":backpack.visible,"paused":get_tree().paused,"indoors":game.indoors,"busy":game.player.busy,"slots":slot_data,"counts":counts,"head":[marker.x,marker.y],"viewport":[viewport.x,viewport.y],"bag_rect":_screen_rect(backpack),"map_rect":_screen_rect(map_panel)}
	JavaScriptBridge.eval("window.bituReviewState="+JSON.stringify(state))

func _layout() -> void:
	var viewport := get_viewport().get_visible_rect().size
	for panel in [backpack,map_panel]:
		var minimum: Vector2 = panel.get_combined_minimum_size()
		panel.size = minimum
		var factor := minf(1.0,minf((viewport.x-36)/minimum.x,(viewport.y-36)/minimum.y))
		panel.scale = Vector2.ONE*factor
		panel.position = (viewport-minimum*factor)/2

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if game.transitioning: return
		if event.physical_keycode == KEY_TAB:
			toggle_backpack()
			get_viewport().set_input_as_handled()
		elif event.physical_keycode == KEY_M:
			toggle_map()
			get_viewport().set_input_as_handled()
		elif event.physical_keycode == KEY_ESCAPE and is_open():
			close_all()
			get_viewport().set_input_as_handled()

func is_open() -> bool:
	return backpack.visible or map_panel.visible

func toggle_backpack() -> void:
	if game.transitioning: return
	var opening := not backpack.visible
	map_panel.visible = false
	backpack.visible = opening
	backpack.refresh()
	_update_pause()
	_layout()
	call_deferred("_layout")
	print("BITU_BACKPACK:",opening)

func toggle_map() -> void:
	if game.transitioning: return
	var opening := not map_panel.visible
	backpack.visible = false
	map_panel.visible = opening
	island_map.update_location()
	map_subtitle.text = game.location_name() if game.has_method("location_name") else "Bītu · mapa de la isla"
	_update_pause()
	_layout()
	print("BITU_MAP:",opening,":",island_map.location)

func close_all() -> void:
	backpack.visible = false
	map_panel.visible = false
	_update_pause()

func _update_pause() -> void:
	shade.visible = is_open()
	get_tree().paused = is_open()
	if is_open():
		game.player.velocity = Vector2.ZERO
		backpack.refresh()

func _exit_tree() -> void:
	if is_inside_tree(): get_tree().paused = false
