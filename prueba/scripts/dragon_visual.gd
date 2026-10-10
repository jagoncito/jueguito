class_name BituDragonVisual
extends Node2D
## Atlas nuevos completos: escalado uniforme, sin limpieza ni deformación.
const DIRECTORY := "res://assets/personajes/dragon/"
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
	if current_frame == key:
		return
	current_frame = key
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
		var pose := current_frame.substr(0,current_frame.rfind("-"))
		current_frame = ""
		show_pose(pose,direction_index)

func has_baked_tool() -> bool:
	return catalog.frames[current_frame].baked_tool

func contact_local(action: StringName) -> Vector2:
	var frame: Dictionary = catalog.frames[current_frame]
	var contacts: Dictionary = frame.get("contacts",{})
	if not contacts.has(String(action)):
		return Vector2.INF
	var point: Array = contacts[String(action)]
	var local_point := (Vector2(point[0],point[1])-Vector2(frame.anchor[0],frame.anchor[1]))*body.scale.x
	if frame.get("mirror_x",false):
		local_point.x *= -1
	return local_point

func contact_global(action: StringName) -> Vector2:
	return to_global(contact_local(action))
