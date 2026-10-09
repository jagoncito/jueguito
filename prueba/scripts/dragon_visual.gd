class_name BituDragonVisual
extends Node2D
## Poses completas: ninguna extremidad ni la cola se estira en tiempo de ejecución.

const DIRECTORY := "res://assets/personajes/dragon-avatar/"
var catalog: Dictionary
var textures: Dictionary = {}
var atlases: Dictionary = {}
var body: Sprite2D
var primary_hand: Node2D
var secondary_hand: Node2D
var current_frame := ""
var direction_index := 0
var hand_cover: Sprite2D
var cover_offset := Vector2.ZERO
var tool_behind := false
var covers: Dictionary = {}

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
	show_pose("reposo",0)

func show_pose(pose: String, direction: int) -> void:
	direction_index = posmod(direction,8)
	var key := "%s-%s" % [pose,catalog.directions[direction_index]]
	if current_frame == key:
		return
	current_frame = key
	var frame: Dictionary = catalog.frames[key]
	if not atlases.has(key):
		if not textures.has(frame.file):
			textures[frame.file] = load(DIRECTORY+frame.file)
		var atlas := AtlasTexture.new()
		atlas.atlas = textures[frame.file]
		atlas.region = Rect2(frame.region[0],frame.region[1],frame.region[2],frame.region[3])
		atlas.filter_clip = true
		atlases[key] = atlas
	var anchor := Vector2(frame.anchor[0],frame.anchor[1])
	var factor := float(frame.scale)
	body.texture = atlases[key]
	body.scale = Vector2.ONE*factor
	body.position = (Vector2(frame.region[0],frame.region[1])-anchor)*factor
	primary_hand.position = (Vector2(frame.hand[0],frame.hand[1])-anchor)*factor
	secondary_hand.position = (Vector2(frame.other_hand[0],frame.other_hand[1])-anchor)*factor
	tool_behind = frame.get("tool_behind",direction_index in [3,4,5])
	var region: Array = frame.get("hand_cover",[])
	hand_cover.visible = not region.is_empty()
	if not region.is_empty():
		if not covers.has(key):
			var cover := AtlasTexture.new()
			cover.atlas = textures[frame.file]
			cover.region = Rect2(region[0],region[1],region[2],region[3])
			cover.filter_clip = true
			covers[key] = cover
		hand_cover.texture = covers[key]
		hand_cover.scale = Vector2.ONE*factor
		cover_offset = (Vector2(region[0],region[1])-Vector2(frame.hand[0],frame.hand[1]))*factor
		hand_cover.position = primary_hand.position+cover_offset

func _draw() -> void:
	draw_set_transform(Vector2(0,-2),0,Vector2(1,0.27))
	draw_circle(Vector2.ZERO,18,Color(0.025,0.04,0.055,0.3))
	draw_set_transform(Vector2.ZERO)
