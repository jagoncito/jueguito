class_name BituNPC
extends StaticBody2D
## Habitante: ocho vistas, giro breve y colisión solo en los pies.
const DIRECTORY := "res://assets/personajes/escala-juego/"
const DIRECTIONS := ["S","SW","W","NW","N","NE","E","SE"]
const NAMES := {"flavia":"Flavia","unamahloni":"Unamahloni","elfa-museo":"Elfa del museo","comerciante":"Comerciante","cocinero":"Maestro de pesca/cocina","enano":"Maestro minero/herrero"}
static var catalog: Dictionary = {}
var character_id := "flavia"
var body: AnimatedSprite2D
var observer: Node2D
var direction_index := 0
var show_name := false
var height_px := 80.0
var motion_clock := 0.0
var review_paused := false

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if catalog.is_empty():
		catalog = JSON.parse_string(FileAccess.get_file_as_string(DIRECTORY+"sprites.json"))
	var character: Dictionary = catalog.characters[character_id]
	height_px = float(character.height_px)
	var drawing := load(DIRECTORY+character_id+"/personaje.tscn").instantiate() as Node2D
	add_child(drawing)
	body = drawing.get_node("Cuerpo") as AnimatedSprite2D
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 8.0
	collision.shape = shape
	collision.position = Vector2(0,-3)
	add_child(collision)
	set_direction(0)

func set_direction(index: int) -> void:
	direction_index = posmod(index,8)
	if body != null:
		body.animation = StringName("reposo-"+DIRECTIONS[direction_index])

func face_towards(point: Vector2) -> void:
	var offset := to_local(point)
	if not offset.is_zero_approx():
		set_direction(roundi((offset.angle()-PI/2)/(PI/4)))

func _process(delta: float) -> void:
	if review_paused:
		return
	motion_clock = fmod(motion_clock + delta, 6.0)
	if observer != null and global_position.distance_to(observer.global_position)<170:
		face_towards(observer.global_position)
	else:
		# Giro de comparación con las ocho vistas vigentes; sin trasladar pies.
		var direction := mini(int(maxf(0,motion_clock-1.6)/0.55),7)
		set_direction(direction)

func display_name() -> String:
	return NAMES[character_id]

func _draw() -> void:
	draw_set_transform(Vector2(0,-2),0,Vector2(1,0.27))
	draw_circle(Vector2.ZERO,14,Color(0.025,0.04,0.055,0.28))
	draw_set_transform(Vector2.ZERO)
	if show_name:
		var font := ThemeDB.fallback_font
		var value := "Elfa" if character_id == "elfa-museo" else "Cocinero" if character_id == "cocinero" else "Enano" if character_id == "enano" else display_name()
		var width := font.get_string_size(value,HORIZONTAL_ALIGNMENT_LEFT,-1,12).x
		draw_string_outline(font,Vector2(-width/2,23),value,HORIZONTAL_ALIGNMENT_LEFT,-1,12,3,Color("15232a"))
		draw_string(font,Vector2(-width/2,23),value,HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color("eddcb7"))
