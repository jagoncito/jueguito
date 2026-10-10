class_name BituNpcPreview
extends Node2D

const DIRECTIONS := ["S", "SW", "W", "NW", "N", "NE", "E", "SE"]
const CYCLE_SECONDS := 6.0
const WALK_DISTANCE := 24.0
var definition: Dictionary
var body: Sprite2D
var name_label: Label
var home_position := Vector2.ZERO
var motion_clock := 0.0
var review_paused := false
var current_frame := ""
var atlas_frames: Dictionary = {}

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	home_position = position
	for key in definition.frames:
		var frame: Dictionary = definition.frames[key]
		var atlas := AtlasTexture.new()
		atlas.atlas = load("res://assets/personajes/comparacion/" + String(frame.file))
		atlas.region = Rect2(frame.region[0], frame.region[1], frame.region[2], frame.region[3])
		atlas_frames[key] = atlas
	body = Sprite2D.new()
	body.centered = false
	add_child(body)
	name_label = Label.new()
	name_label.text = definition.label
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.position = Vector2(-65, -float(definition.height_px)-21)
	name_label.size = Vector2(130, 18)
	name_label.add_theme_font_size_override("font_size", 10)
	name_label.add_theme_color_override("font_color", Color("fff1cb"))
	name_label.add_theme_color_override("font_outline_color", Color("20362b"))
	name_label.add_theme_constant_override("outline_size", 3)
	add_child(name_label)
	update_pose()

func _process(delta: float) -> void:
	if review_paused:
		return
	motion_clock = fmod(motion_clock + delta, CYCLE_SECONDS)
	update_pose()

func update_pose() -> void:
	var direction := "S"
	var phase := 0
	var offset := 0.0
	if definition.motion == "walk":
		# Dos pasos de 24 px y pausas: solo se usan los cuatro dibujos reales.
		if motion_clock >= 1.0 and motion_clock < 1.8:
			direction = "E"
			offset = (motion_clock - 1.0) * 30.0
			phase = int(offset / 6.0) % 4
		elif motion_clock >= 1.8 and motion_clock < 2.5:
			direction = "E"
			offset = WALK_DISTANCE
		elif motion_clock >= 2.5 and motion_clock < 3.3:
			direction = "W"
			var travelled := (motion_clock - 2.5) * 30.0
			offset = WALK_DISTANCE - travelled
			phase = int(travelled / 6.0) % 4
	else:
		# Estos personajes solo tienen vistas: giran sin deslizar sus pies.
		if motion_clock >= 1.6:
			direction = DIRECTIONS[mini(int((motion_clock - 1.6) / 0.55), 7)]
	position = home_position + Vector2(offset, 0)
	# Los nombres mantienen su separación mientras se dan los pasos breves.
	name_label.position.x = -65 - offset
	current_frame = "%s-%d" % [direction, phase]
	var frame: Dictionary = definition.frames[current_frame]
	body.texture = atlas_frames[current_frame]
	body.scale = Vector2.ONE * float(frame.scale)
	body.position = -Vector2(frame.anchor[0], frame.anchor[1]) * float(frame.scale)

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0, Vector2(1, 0.4))
	draw_circle(Vector2.ZERO, 15, Color(0.03, 0.09, 0.06, 0.22))
	draw_set_transform(Vector2.ZERO)
