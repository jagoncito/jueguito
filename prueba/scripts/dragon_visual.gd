class_name BituDragonVisual
extends Node2D
## Poses completas: ninguna extremidad ni la cola se estira en tiempo de ejecución.

const DIRECTORY := "res://assets/personajes/dragon-avatar/"
var catalog: Dictionary
var textures: Dictionary = {}
var frame_textures: Dictionary = {}
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
var frame_metrics: Dictionary = {}

## The atlases were authored at different source resolutions.  They are still
## complete pixel-art drawings, but using their historical scale values made a
## few walking/work frames render one or two pixels taller or shorter.  Keep a
## single presentation height in the game and let the kneeling poses use their
## own, intentionally lower, silhouette.
const UPRIGHT_HEIGHT_PX := 90.0
const KNEEL_HEIGHT_PX := 66.0
const ISOLATED_PIXEL_COMPONENT_LIMIT := 240

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

func _frame_texture(key: String, frame: Dictionary) -> Texture2D:
	if frame_textures.has(key):
		return frame_textures[key]
	if not textures.has(frame.file):
		textures[frame.file] = load(DIRECTORY+frame.file)
	var source: Image = (textures[frame.file] as Texture2D).get_image()
	var region: Array = frame.region
	var width := int(region[2])
	var height := int(region[3])
	var image := source.get_region(Rect2i(int(region[0]),int(region[1]),width,height))
	# Some source atlas cells contain a handful of disconnected black/red
	# pixels from the neighboring drawing.  Removing only tiny disconnected
	# components keeps the complete silhouette (wings, tail and feet) intact
	# while preventing those pixels from becoming rays during a turn.
	var visited := PackedByteArray()
	visited.resize(width*height)
	var neighbours := [Vector2i(1,0),Vector2i(-1,0),Vector2i(0,1),Vector2i(0,-1)]
	for y in range(height):
		for x in range(width):
			var start := y*width+x
			if visited[start] == 1 or image.get_pixel(x,y).a <= 0.08:
				continue
			var stack: Array[Vector2i] = [Vector2i(x,y)]
			var component: Array[Vector2i] = []
			visited[start] = 1
			while not stack.is_empty():
				var point: Vector2i = stack.pop_back()
				component.append(point)
				for offset: Vector2i in neighbours:
					var next: Vector2i = point+offset
					if next.x < 0 or next.x >= width or next.y < 0 or next.y >= height:
						continue
					var index: int = next.y*width+next.x
					if visited[index] == 1 or image.get_pixel(next.x,next.y).a <= 0.08:
						continue
					visited[index] = 1
					stack.append(next)
			if component.size() <= ISOLATED_PIXEL_COMPONENT_LIMIT:
				for point in component:
					image.set_pixel(point.x,point.y,Color(0,0,0,0))
	var texture := ImageTexture.create_from_image(image)
	frame_textures[key] = texture
	return texture

func _metrics_for_frame(key: String, frame: Dictionary) -> Dictionary:
	if frame_metrics.has(key):
		return frame_metrics[key]
	var image: Image = (_frame_texture(key,frame) as Texture2D).get_image()
	var width := image.get_width()
	var height := image.get_height()
	var min_x := width
	var min_y := height
	var max_x := -1
	var max_y := -1
	# Read only the frame's alpha.  This keeps neighboring atlas drawings out
	# of the measurement and is performed once per frame, not every tick.
	for y in range(height):
		for x in range(width):
			if image.get_pixel(x,y).a > 0.08:
				min_x = mini(min_x,x)
				min_y = mini(min_y,y)
				max_x = maxi(max_x,x)
				max_y = maxi(max_y,y)
	if max_y < 0:
		var fallback := {"alpha_height": float(height), "alpha_width": float(width)}
		frame_metrics[key] = fallback
		return fallback
	var metrics := {
		"alpha_height": float(max_y-min_y+1),
		"alpha_width": float(max_x-min_x+1),
		"alpha_top": min_y,
		"alpha_bottom": max_y+1,
	}
	frame_metrics[key] = metrics
	return metrics

func _presentation_height(pose: String) -> float:
	if pose == "arrodillado":
		return KNEEL_HEIGHT_PX
	if pose == "levantar":
		return 68.0
	return UPRIGHT_HEIGHT_PX

func show_pose(pose: String, direction: int) -> void:
	direction_index = posmod(direction,8)
	var key := "%s-%s" % [pose,catalog.directions[direction_index]]
	if current_frame == key:
		return
	current_frame = key
	var frame: Dictionary = catalog.frames[key]
	var frame_texture := _frame_texture(key,frame)
	if not atlases.has(key):
		var atlas := AtlasTexture.new()
		atlas.atlas = frame_texture
		atlas.region = Rect2(0,0,frame.region[2],frame.region[3])
		atlas.filter_clip = true
		atlases[key] = atlas
	var anchor := Vector2(frame.anchor[0],frame.anchor[1])
	var metrics := _metrics_for_frame(key,frame)
	var pose_name := key.get_slice("-",0)
	# Normalize the visible silhouette, not the transparent source rectangle.
	# This removes the subtle scale pulse between the four walking phases while
	# retaining the shorter, deliberate kneeling posture.
	var factor := _presentation_height(pose_name)/float(metrics["alpha_height"])
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
			cover.atlas = frame_texture
			cover.region = Rect2(region[0]-frame.region[0],region[1]-frame.region[1],region[2],region[3])
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
