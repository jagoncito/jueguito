class_name BituDragonVisual
extends Node2D
## Fotogramas completos: las proporciones están dibujadas, no articuladas.
const DIRECTORY := "res://assets/personajes/dragon/"
const WALK_POSES := ["andar-a","paso-a","andar-b","paso-b"]
const RUN_POSES := ["sprint-a","sprint-paso-a","sprint-b","sprint-paso-b"]
const WORK_TIMES := [0.0,0.12,0.24,0.33,0.40,0.50]
var presentation_height_px := 80.0
var catalog: Dictionary
var textures: Dictionary = {}
var atlases: Dictionary = {}
var body: Sprite2D
var primary_hand: Node2D
var secondary_hand: Node2D
var current_frame := ""
var direction_index := 0
var hand_cover: Sprite2D
var other_hand_cover: Sprite2D
var cover_offset := Vector2.ZERO
var other_cover_offset := Vector2.ZERO
var tool_behind := false

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	catalog = JSON.parse_string(FileAccess.get_file_as_string(DIRECTORY+"dragon-jugable.json"))
	body = Sprite2D.new()
	body.centered = false
	add_child(body)
	primary_hand = Node2D.new()
	secondary_hand = Node2D.new()
	add_child(primary_hand)
	add_child(secondary_hand)
	hand_cover = Sprite2D.new()
	hand_cover.centered = false
	add_child(hand_cover)
	other_hand_cover = Sprite2D.new()
	other_hand_cover.visible = false
	add_child(other_hand_cover)
	show_pose("reposo",0)

func _texture(frame: Dictionary, key: String, region: Array) -> AtlasTexture:
	if not textures.has(frame.file):
		textures[frame.file] = load(DIRECTORY+frame.file)
	if not atlases.has(key):
		var atlas := AtlasTexture.new()
		atlas.atlas = textures[frame.file]
		atlas.region = Rect2(region[0],region[1],region[2],region[3])
		atlas.filter_clip = true
		atlases[key] = atlas
	return atlases[key]

func show_pose(pose: String, direction: int) -> void:
	direction_index = posmod(direction,8)
	var key := "%s-%s" % [pose,catalog.directions[direction_index]]
	_show_frame(key)

func _show_frame(key: String) -> void:
	if current_frame == key:
		return
	current_frame = key
	body.visible = true
	var frame: Dictionary = catalog.frames[key]
	var anchor := Vector2(frame.anchor[0],frame.anchor[1])
	var factor := float(frame.scale)*presentation_height_px/80.0
	body.texture = _texture(frame,key,frame.region)
	body.scale = Vector2.ONE*factor
	body.position = (Vector2(frame.region[0],frame.region[1])-anchor)*factor
	primary_hand.position = (Vector2(frame.hand[0],frame.hand[1])-anchor)*factor
	secondary_hand.position = (Vector2(frame.other_hand[0],frame.other_hand[1])-anchor)*factor
	body.flip_h = frame.get("mirror_x",false)
	if body.flip_h:
		body.position.x = -(float(frame.region[0])+float(frame.region[2])-anchor.x)*factor
		primary_hand.position.x *= -1
		secondary_hand.position.x *= -1
	tool_behind = frame.tool_behind
	hand_cover.visible = frame.has("hand_cover")
	other_hand_cover.visible = false
	if hand_cover.visible:
		var region: Array = frame.hand_cover
		hand_cover.texture = _texture(frame,key+"-dedos",region)
		hand_cover.scale = Vector2.ONE*factor
		cover_offset = (Vector2(region[0],region[1])-Vector2(frame.hand[0],frame.hand[1]))*factor
		hand_cover.position = primary_hand.position+cover_offset

func animation_frames(action: String, direction: int) -> Array:
	var animations: Dictionary = catalog.get("animations",{})
	var views: Dictionary = animations.get(action,{})
	if action == "andar" and views.is_empty():
		views = animations.get("marcha",{})
	return views.get(catalog.directions[posmod(direction,8)],[])

func show_gait(phase: float, running: bool, direction: int) -> void:
	direction_index = posmod(direction,8)
	var frames := animation_frames("sprint" if running else "andar",direction_index)
	var cycle := fposmod(phase,1.0)
	if frames.is_empty():
		show_pose((RUN_POSES if running else WALK_POSES)[int(cycle*4)],direction_index)
	else:
		_show_frame(String(frames[mini(int(cycle*frames.size()),frames.size()-1)]))

func show_work(action: StringName, clock: float, direction: int) -> void:
	direction_index = posmod(direction,8)
	var frames := animation_frames(String(action),direction_index)
	if frames.is_empty():
		var names := ["medio","cargar","golpe","recuperar"] if action == &"minar" else ["medio-talar","cargar-talar","golpe-talar","recuperar-talar"]
		show_pose(names[0 if clock<0.12 else (1 if clock<0.28 else (2 if clock<0.40 else 3))],direction_index)
		return
	var phase := 0
	var times: Array = catalog.get("work_timing",{}).get(String(action),WORK_TIMES)
	for index in range(mini(times.size(),frames.size())):
		if clock+0.00001 >= float(times[index]):
			phase = index
	_show_frame(String(frames[phase]))

func _draw() -> void:
	draw_set_transform(Vector2(0,-2),0,Vector2(1,0.27))
	draw_circle(Vector2.ZERO,17,Color(0.025,0.04,0.055,0.3))
	draw_set_transform(Vector2.ZERO)

func set_presentation_height(height: float) -> void:
	var requested := clampf(height,64.0,96.0)
	if is_equal_approx(requested,presentation_height_px):
		return
	presentation_height_px = requested
	if not current_frame.is_empty():
		var key := current_frame
		current_frame = ""
		_show_frame(key)

func has_baked_tool() -> bool:
	return catalog.frames[current_frame].baked_tool

func contact_local(action: StringName) -> Vector2:
	return _frame_contact(catalog.frames[current_frame],action)

func impact_contact_local(direction: int, action: StringName) -> Vector2:
	var key := "%s-%s" % ["golpe-talar" if action == &"talar" else "golpe",catalog.directions[posmod(direction,8)]]
	return _frame_contact(catalog.frames[key],action)

func _frame_contact(frame: Dictionary, action: StringName) -> Vector2:
	var contacts: Dictionary = frame.get("contacts",{})
	if not contacts.has(String(action)):
		return Vector2.INF
	var point: Array = contacts[String(action)]
	var factor := float(frame.scale)*presentation_height_px/80.0
	var local_point := (Vector2(point[0],point[1])-Vector2(frame.anchor[0],frame.anchor[1]))*factor
	if frame.get("mirror_x",false):
		local_point.x *= -1
	return local_point

func contact_global(action: StringName) -> Vector2:
	return to_global(contact_local(action))
