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

func _draw() -> void:
	draw_set_transform(Vector2(0,-2),0,Vector2(1,0.27))
	draw_circle(Vector2.ZERO,18,Color(0.025,0.04,0.055,0.3))
	draw_set_transform(Vector2.ZERO)
