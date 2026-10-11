class_name BituDragonVisual
extends Node2D
## Poses conservadas y articulaciones para la revisión selectiva.
const ARTICULATED = preload("res://scripts/dragon_articulated.gd")
var articulated: BituDragonArticulated
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
	articulated = ARTICULATED.new()
	add_child(articulated)
	articulated.visible = false
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
	articulated.visible = false
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


	var work_poses := ["medio","cargar","golpe","recuperar","medio-talar","cargar-talar","golpe-talar","recuperar-talar"]
	if pose in work_poses:
		show_articulated_work(&"talar" if pose.ends_with("talar") else &"minar",[0.04,0.17,0.33,0.50][work_poses.find(pose)%4])
	var walks := ["andar-a","paso-a","andar-b","paso-b"]
	var runs := ["sprint-a","sprint-paso-a","sprint-b","sprint-paso-b"]
	if pose in walks and direction_index != 4:
		show_articulated_gait(walks.find(pose)/4.0,false)
	elif pose in runs and direction_index in [1,3,5,7]:
		show_articulated_gait(runs.find(pose)/4.0,true)

func _activate_articulated() -> void:
	articulated.visible = true
	articulated.scale = Vector2.ONE*presentation_height_px/80.0
	body.visible = false
	hand_cover.visible = false
	other_hand_cover.visible = false
func show_articulated_gait(phase: float, running: bool) -> void:
	_activate_articulated()
	articulated.show_gait(direction_index,phase,running)
func show_articulated_work(action: StringName, clock: float) -> void:
	_activate_articulated()
	articulated.show_work(direction_index,action,clock)

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
	if articulated.visible: return not articulated.walking
	return catalog.frames[current_frame].baked_tool

func contact_local(action: StringName) -> Vector2:
	if articulated.visible and action in [&"minar",&"talar"]: return articulated.contact_local()*presentation_height_px/80.0
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
