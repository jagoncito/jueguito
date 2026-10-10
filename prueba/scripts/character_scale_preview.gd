extends Node2D
## Compara personajes en píxeles de mundo; ampliación común, nunca individual.
const DIRECTORY := "res://assets/personajes/escala-juego/"
const ORDER := ["flavia","unamahloni","elfa-museo","comerciante","cocinero","enano","dragon"]
const NAMES := ["Flavia","Unamahloni","Elfa","Comerciante","Cocinero","Enano","Dragón"]
var catalog: Dictionary
var actors: Array[Node2D] = []
var direction := 0
var variant := 0
var elapsed := 0.0
var walking := false
var group: Node2D
var info: Label
var zoom := 2.0

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	RenderingServer.set_default_clear_color(Color("162c2b"))
	catalog = JSON.parse_string(FileAccess.get_file_as_string(DIRECTORY+"sprites.json"))
	_label("BĪTU · ESCALA DE PERSONAJES EN EL MOTOR",Vector2(28,24),24)
	_label("← → ocho vistas · Espacio marcha dragón · V poses dragón · Z zoom común 1× / 2×",Vector2(28,62),18)
	info = _label("",Vector2(28,100),18)
	group = Node2D.new()
	group.position = Vector2(50,400)
	add_child(group)
	for index in range(ORDER.size()):
		var actor: Node2D
		if ORDER[index] == "dragon":
			actor = BituDragonVisual.new()
			actor.position = Vector2(index*82,0)
		else:
			var sprite := Sprite2D.new()
			sprite.centered = false
			sprite.position = Vector2(index*82-64,-112)
			actor = sprite
		group.add_child(actor)
		actors.append(actor)
		var height := 80 if ORDER[index] == "dragon" else int(catalog.characters[ORDER[index]].height_px)
		var label := _label("%s · %d px" % [NAMES[index],height],Vector2(40+index*172,465),16)
		label.name = "Name%d" % index
	_label("Suelo: 64 × 32 px · fotogramas: 128 × 128 px · apoyo común: (64, 112)",Vector2(28,535),18)
	_label("Seis NPC: ocho vistas en reposo cada uno. Solo el protagonista tiene marcha.",Vector2(28,569),16)
	_label("Puerta de referencia: 90 px de mundo. Z cambia la ampliación de todos a la vez.",Vector2(28,600),16)
	_refresh()
	print("BITU_CHARACTER_SCALE_READY")

func _refresh() -> void:
	group.scale = Vector2.ONE*zoom
	info.text = "Vista %s · ampliación común %d× · %s" % [catalog.directions[direction],int(zoom),"marcha del protagonista" if walking else "reposo / poses del protagonista"]
	for index in range(ORDER.size()):
		get_node("Name%d" % index).position.x = 40+index*82*zoom
		var name: String = ORDER[index]
		var action := "reposo"
		var phase := 0
		if name == "dragon":
			action = ["andar-a","paso-a","andar-b","paso-b"][int(elapsed*7)%4] if walking else ["reposo","cargar","golpe","arrodillado"][variant%4]
			(actors[index] as BituDragonVisual).show_pose(action,direction)
			continue
		var ch: Dictionary = catalog.characters[name]
		for frame: Dictionary in ch.frames:
			if frame.direction == catalog.directions[direction] and frame.action == action and frame.phase == phase:
				var atlas := AtlasTexture.new()
				atlas.atlas = load(DIRECTORY+ch.atlas)
				atlas.region = Rect2(frame.region[0],frame.region[1],128,128)
				atlas.filter_clip = true
				(actors[index] as Sprite2D).texture = atlas
				break
	queue_redraw()

func _process(delta: float) -> void:
	if walking:
		elapsed += delta
		_refresh()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_LEFT: direction = posmod(direction-1,8)
			KEY_RIGHT: direction = posmod(direction+1,8)
			KEY_SPACE: walking = not walking
			KEY_V: variant += 1
			KEY_Z: zoom = 1.0 if zoom == 2.0 else 2.0
		_refresh()

func _draw() -> void:
	if group == null:
		return
	for index in range(7):
		var center := group.position+Vector2(index*82,0)*zoom
		var points := PackedVector2Array([center+Vector2(-32,0)*zoom,center+Vector2(0,-16)*zoom,center+Vector2(32,0)*zoom,center+Vector2(0,16)*zoom,center+Vector2(-32,0)*zoom])
		draw_polyline(points,Color("647e61"),1)
	var base := Vector2(1220,400)
	draw_line(base,base-Vector2(0,90*zoom),Color("e9cf95"),2)
	draw_line(base+Vector2(-7,0),base+Vector2(7,0),Color("e9cf95"),2)
	draw_line(base+Vector2(-7,-90*zoom),base+Vector2(7,-90*zoom),Color("e9cf95"),2)

func _label(value: String, point: Vector2, size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = point
	label.add_theme_font_size_override("font_size",size)
	label.add_theme_color_override("font_color",Color("eddcb7"))
	add_child(label)
	return label
