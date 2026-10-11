class_name BituInventorySlot
extends Button

var bag: PanelContainer
var index := 0
var item_icon: TextureRect
var quantity: Label

func _ready() -> void:
	custom_minimum_size = Vector2(70,70)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	item_icon = TextureRect.new()
	item_icon.position = Vector2(8,7)
	item_icon.size = Vector2(54,54)
	item_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	item_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	item_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(item_icon)
	quantity = Label.new()
	quantity.position = Vector2(4,45)
	quantity.size = Vector2(60,20)
	quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	quantity.add_theme_font_size_override("font_size",15)
	quantity.add_theme_constant_override("outline_size",4)
	quantity.add_theme_color_override("font_outline_color",Color("12221e"))
	quantity.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(quantity)
	for state in ["normal","hover","pressed","focus"]:
		var style := StyleBoxFlat.new()
		style.bg_color = Color("223b35") if state == "normal" else Color("36534a")
		style.border_color = Color("b99c62") if state in ["hover","focus"] else Color("4d6656")
		style.set_border_width_all(2)
		style.set_corner_radius_all(5)
		add_theme_stylebox_override(state,style)
	mouse_entered.connect(func(): bag.show_details(index))
	pressed.connect(func(): bag.show_details(index))

func refresh() -> void:
	var item: Dictionary = bag.inventory.item_at(index)
	item_icon.texture = bag.textures.get(item.get("id",""))
	quantity.text = "1k" if item.get("amount",0) == 1000 else str(item.amount) if not item.is_empty() and int(item.amount)>1 else ""
	tooltip_text = "%s · %d\nArrastra para mover · Mayús + arrastrar: mitad" % [bag.names.get(item.get("id",""),"Objeto"),item.get("amount",0)] if not item.is_empty() else "Espacio libre"

func _get_drag_data(_point: Vector2) -> Variant:
	var item: Dictionary = bag.inventory.item_at(index)
	if item.is_empty(): return null
	var preview := TextureRect.new()
	preview.texture = item_icon.texture
	preview.custom_minimum_size = Vector2(54,54)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_drag_preview(preview)
	return {"bag":bag,"source":index,"split":Input.is_key_pressed(KEY_SHIFT)}

func _can_drop_data(_point: Vector2, data: Variant) -> bool:
	if not data is Dictionary or data.get("bag") != bag or int(data.source) == index: return false
	var target: Dictionary = bag.inventory.item_at(index)
	var origin: Dictionary = bag.inventory.item_at(int(data.source))
	return not origin.is_empty() and (not data.split or target.is_empty() or target.id == origin.id)

func _drop_data(_point: Vector2, data: Variant) -> void:
	bag.inventory.move_stack(int(data.source),index,bool(data.split))
	bag.show_details(index)
