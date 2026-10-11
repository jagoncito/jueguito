class_name BituBackpackMenu
extends PanelContainer

signal close_requested
var inventory: BituInventory
var textures: Dictionary
var names: Dictionary
var slots: Array[BituInventorySlot] = []
var capacity: Label
var detail_title: Label
var detail_text: Label
var detail_icon: TextureRect
var xp_label: Label
var selected_index := -1

static func label(value: String, size_px := 16, color := Color("eadfc7")) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size",size_px)
	item.add_theme_color_override("font_color",color)
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return item

static func panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("182d28")
	style.border_color = Color("b69c68")
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.set_content_margin_all(24)
	style.shadow_color = Color(0,0,0,0.35)
	style.shadow_size = 12
	return style

func _ready() -> void:
	custom_minimum_size = Vector2(760,560)
	add_theme_stylebox_override("panel",panel_style())
	mouse_filter = Control.MOUSE_FILTER_STOP
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation",16)
	add_child(content)
	var header := HBoxContainer.new()
	content.add_child(header)
	var title := label("MOCHILA",26,Color("e5c783"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	capacity = label("",15,Color("9eb7a6"))
	header.add_child(capacity)
	var close := Button.new()
	close.text = "Cerrar ×"
	close.pressed.connect(func(): close_requested.emit())
	header.add_child(close)
	content.add_child(label("Recursos · cada calidad y variante conserva su propia pila",14,Color("9eb7a6")))
	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation",22)
	content.add_child(body)
	var grid := GridContainer.new()
	grid.columns = 6
	grid.add_theme_constant_override("h_separation",6)
	grid.add_theme_constant_override("v_separation",6)
	body.add_child(grid)
	for index in range(BituInventory.SLOT_COUNT):
		var slot := BituInventorySlot.new()
		slot.bag = self
		slot.index = index
		grid.add_child(slot)
		slots.append(slot)
	var details := VBoxContainer.new()
	details.custom_minimum_size.x = 200
	details.add_theme_constant_override("separation",12)
	body.add_child(details)
	details.add_child(label("OBJETO",12,Color("9eb7a6")))
	detail_icon = TextureRect.new()
	detail_icon.custom_minimum_size = Vector2(120,92)
	detail_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	detail_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	detail_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	details.add_child(detail_icon)
	detail_title = label("Selecciona un objeto",17,Color("e5c783"))
	detail_title.size = Vector2(200,44)
	detail_title.custom_minimum_size.x = 200
	detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	details.add_child(detail_title)
	detail_text = label("Mueve las pilas entre espacios. Suelta fuera para conservar su posición.",14)
	detail_text.size = Vector2(200,100)
	detail_text.custom_minimum_size.x = 200
	detail_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	details.add_child(detail_text)
	content.add_child(HSeparator.new())
	var equipment := HBoxContainer.new()
	equipment.add_theme_constant_override("separation",12)
	content.add_child(equipment)
	equipment.add_child(label("HERRAMIENTAS",12,Color("9eb7a6")))
	for tool in ["Pico–hacha","Palín","Caña","Regadera"]:
		var tag := Label.new()
		tag.text = "  "+tool+"  "
		tag.add_theme_font_size_override("font_size",14)
		tag.add_theme_color_override("font_color",Color("e5c783"))
		equipment.add_child(tag)
	var footer := HBoxContainer.new()
	content.add_child(footer)
	var help := label("Arrastrar: mover · Mayús: dividir · Tab / Esc: cerrar",13,Color("9eb7a6"))
	help.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(help)
	var sort_button := Button.new()
	sort_button.text = "Ordenar"
	sort_button.pressed.connect(inventory.sort_items)
	footer.add_child(sort_button)
	xp_label = label("Tomates cosechados: 0",12,Color("9eb7a6"))
	content.add_child(xp_label)
	inventory.changed.connect(refresh)
	refresh()
	visible = false

func refresh() -> void:
	for slot in slots: slot.refresh()
	if capacity != null: capacity.text = "%d / 24 espacios" % inventory.used_slots()
	if selected_index>=0: show_details(selected_index)

func show_details(index: int) -> void:
	selected_index = index
	var item := inventory.item_at(index)
	detail_icon.texture = textures.get(item.get("id",""))
	if item.is_empty():
		detail_title.text = "Espacio libre"
		detail_text.text = "Puedes colocar aquí otra pila. Las herramientas tienen su propio apartado."
		return
	detail_title.text = names.get(item.id,"Objeto")
	var quality := "Prístino" if String(item.id).contains("pristino") else "Común"
	var variant := "Siru" if String(item.id).contains("siru") else "Normal"
	detail_text.text = "%d unidades\nCalidad: %s\nVariante: %s\n\nHasta 1.000 por pila." % [item.amount,quality,variant]
