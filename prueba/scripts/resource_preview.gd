extends Node2D
## Comparación visual: mismas texturas del juego, sin modificar sus reglas.

var tree: BituTree
var ore: BituResource

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("15232a"))
	_label("RECURSOS · TERRENO Y BOTÍN",Vector2(28,18),26)
	_label("Terreno y dragón ampliados ×1,5 · botín 32×32 · mochila 64×64 · filtro nearest",Vector2(28,58),16)
	_label("Tres vistas de árbol · estado picado del cobre · flor plantada frente a flor recogida",Vector2(28,82),15)
	for index in range(3):
		var actor := BituPlayer.new()
		actor.position = Vector2(160+index*400,420)
		actor.scale = Vector2.ONE*1.5
		add_child(actor)
		actor.set_physics_process(false)
		actor.set_process(false)
		actor.animate_pose(0)
	tree = BituTree.new()
	tree.position = Vector2(300,420)
	tree.scale = Vector2.ONE*1.5
	add_child(tree)
	ore = BituResource.new()
	ore.position = Vector2(700,420)
	ore.scale = Vector2.ONE*1.5
	add_child(ore)
	var flower := BituResource.new()
	flower.kind = "flower"
	flower.position = Vector2(1100,420)
	flower.scale = Vector2.ONE*1.5
	add_child(flower)
	for index in range(3):
		var x := 28+index*400
		var names := ["ÁRBOL · 192–208 px","MENA DE COBRE · 56×52 px","FLOR DE YDE · 36 px"]
		_label(names[index],Vector2(x,437),18)
		_label("Botín en suelo · 32×32",Vector2(x,515),14)
		_label("Recogido · mochila 64×64",Vector2(x,600),14)
		var item: String = ["madera","mineral","flor"][index]
		var drop := BituLoot.new()
		drop.item_id = item
		drop.texture = BituResourceArt.loot_texture(item)
		drop.position = Vector2(x+305,551)
		add_child(drop)
		var icon := TextureRect.new()
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture = drop.texture
		icon.position = Vector2(x+273,574)
		icon.size = Vector2(64,64)
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(icon)
	_button("Cambiar árbol",Vector2(28,472),func():
		tree.variant = (tree.variant+1)%3
		tree._update_art()
	)
	_button("Árbol / tocón",Vector2(190,472),func():
		tree.active = not tree.active
		tree._update_art()
	)
	_button("Cobre entero / picado",Vector2(428,472),func():
		ore.damaged = not ore.damaged
		ore._update_art()
	)
	_label("Revisión visual independiente. En la granja: clic sobre el recurso cercano para extraer; botín por proximidad.",Vector2(28,685),15)
	print("BITU_RESOURCES_PREVIEW_READY")

func _draw() -> void:
	for index in range(3):
		var x := 28+index*400
		for point in [Vector2(x+132,420),Vector2(x+272,420)]:
			draw_colored_polygon(PackedVector2Array([point+Vector2(-48,0),point+Vector2(0,-24),point+Vector2(48,0),point+Vector2(0,24)]),Color("496145"))
			draw_polyline(PackedVector2Array([point+Vector2(-48,0),point+Vector2(0,-24),point+Vector2(48,0),point+Vector2(0,24),point+Vector2(-48,0)]),Color("6f8054"))
		draw_rect(Rect2(x+289,519,32,32),Color("3e5653"),false)
		draw_rect(Rect2(x+273,574,64,64),Color("6f8054"),false)

func _label(value: String, point: Vector2, size: int) -> void:
	var label := Label.new()
	label.text = value
	label.position = point
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",Color("edd5a0"))
	add_child(label)

func _button(value: String, point: Vector2, action: Callable) -> void:
	var button := Button.new()
	button.text = value
	button.position = point
	button.pressed.connect(action)
	add_child(button)
