class_name BituDragonVisual
extends Node2D
## Rig bípedo. La cara usa los píxeles originales, nunca una cara regenerada.

const ORIGINAL := preload("res://assets/personajes/dragon-avatar/dragon-idle.png")
const PARTS := preload("res://assets/personajes/dragon-avatar/dragon-cuerpo.png")
const BACK := preload("res://assets/personajes/dragon-avatar/dragon-espalda.png")
const REGIONS := {
	"torso": Rect2(49,160,328,468), "upper_arm": Rect2(417,238,185,277),
	"forearm": Rect2(707,244,154,356), "hand": Rect2(951,323,258,275),
	"thigh": Rect2(60,711,195,365), "shin": Rect2(331,724,218,405),
	"tail": Rect2(566,729,397,352), "wing": Rect2(980,746,240,310)
}
# Contorno del cráneo, aletas y mandíbula. Las UV apuntan al PNG original.
# Solo excluye cuello, cuerpo, alas y patas; ojos, hocico y sonrisa no se retocan.
const HEAD_OUTLINE := [
	Vector2(195,211),Vector2(290,207),Vector2(386,252),Vector2(441,301),
	Vector2(462,264),Vector2(478,271),Vector2(480,127),Vector2(505,96),
	Vector2(540,96),Vector2(540,138),Vector2(596,177),Vector2(629,180),
	Vector2(646,192),Vector2(677,245),Vector2(689,274),Vector2(712,304),
	Vector2(747,309),Vector2(761,336),Vector2(805,304),Vector2(837,300),
	Vector2(850,340),Vector2(845,381),Vector2(884,384),Vector2(902,426),
	Vector2(953,428),Vector2(978,440),Vector2(1002,464),Vector2(1086,485),
	Vector2(1129,473),Vector2(1137,509),Vector2(1093,541),Vector2(1010,551),
	Vector2(913,543),Vector2(923,598),Vector2(955,613),Vector2(960,653),
	Vector2(931,678),Vector2(903,727),Vector2(894,771),Vector2(863,799),
	Vector2(792,808),Vector2(708,814),Vector2(621,804),Vector2(537,780),
	Vector2(438,744),Vector2(390,713),Vector2(357,672),Vector2(317,629),
	Vector2(286,599),Vector2(246,591),Vector2(215,570),Vector2(251,526),
	Vector2(239,492),Vector2(198,482),Vector2(194,466),Vector2(238,420),
	Vector2(253,391),Vector2(214,373),Vector2(182,367),Vector2(194,333),
	Vector2(246,281),Vector2(214,249),Vector2(194,246)
]
const HEAD_SCALE := 0.055
var head: Polygon2D
var back_head: Sprite2D
var torso: Sprite2D
var primary_hand: Sprite2D
var secondary_hand: Sprite2D
var arms: Array[Sprite2D] = []
var forearms: Array[Sprite2D] = []
var thighs: Array[Sprite2D] = []
var shins: Array[Sprite2D] = []
var wings: Array[Sprite2D] = []
var tail: Sprite2D
var front_torso: AtlasTexture
var rear_torso: AtlasTexture
var age := 0.0

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tail = _piece("tail", -4)
	for index in range(2):
		wings.append(_piece("wing", -2))
		thighs.append(_piece("thigh", -1))
		shins.append(_piece("shin", 0))
		arms.append(_piece("upper_arm", 5))
		forearms.append(_piece("forearm", 5))
	torso = _piece("torso", 1)
	front_torso = torso.texture
	rear_torso = _atlas(BACK,Rect2(1159,178,488,628))
	back_head = Sprite2D.new()
	back_head.texture = _atlas(BACK,Rect2(96,81,878,678))
	back_head.set_meta("layer",4)
	add_child(back_head)
	head = Polygon2D.new()
	head.texture = ORIGINAL
	head.set_meta("layer",4)
	var points := PackedVector2Array()
	var uvs := PackedVector2Array()
	for point: Vector2 in HEAD_OUTLINE:
		points.append((point-Vector2(650,815))*HEAD_SCALE)
		uvs.append(point)
	head.polygon = points
	head.uv = uvs
	add_child(head)
	primary_hand = _piece("hand", 7)
	secondary_hand = _piece("hand", 7)
	primary_hand.scale = Vector2(7.0/258,7.0/275)
	secondary_hand.scale = primary_hand.scale
	# Orden interno por hermanos, todo con z=0: respetar el y-sort del mundo.
	var layers := get_children()
	layers.sort_custom(func(a: Node,b: Node): return int(a.get_meta("layer",0)) < int(b.get_meta("layer",0)))
	for index in range(layers.size()):
		move_child(layers[index],index)

func _atlas(source: Texture2D, region: Rect2) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = region
	atlas.filter_clip = true
	return atlas

func _piece(kind: String, depth: int) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = _atlas(PARTS,REGIONS[kind])
	sprite.set_meta("layer",depth)
	add_child(sprite)
	return sprite

func pose(delta: float, facing: int, backwards: bool, walk: float, kneel: float, equipped: bool, working: bool, gathering: bool) -> void:
	age += delta
	var stride := sin(walk)
	var bob := roundf(absf(stride)*1.5) if walk != 0 else roundf(sin(age*2)*0.6)
	var body_offset := Vector2(roundf(facing*6*kneel),roundf(13*kneel)-bob)
	torso.texture = rear_torso if backwards else front_torso
	torso.scale = Vector2(30,32)/torso.texture.get_size()
	torso.position = Vector2(0,-35)+body_offset
	torso.flip_h = facing < 0
	head.visible = not backwards
	back_head.visible = backwards
	head.position = Vector2(0,-44)+body_offset
	head.scale = Vector2(facing,1)
	back_head.scale = Vector2(52,40)/back_head.texture.get_size()
	back_head.position = Vector2(0,-64)+body_offset
	back_head.flip_h = facing < 0
	tail.scale = Vector2(28,25)/tail.texture.get_size()
	tail.flip_h = facing > 0
	tail.position = Vector2(-facing*17,-18)+body_offset*0.4
	tail.rotation = deg_to_rad(facing*(sin(age*2)*3+stride*5))
	for index in range(2):
		var side := -1 if index == 0 else 1
		var step := stride*side
		var foot := Vector2(side*8+roundf(step*1.5),-roundf(maxf(step,0)*3))
		foot = foot.lerp(Vector2(side*15,-1),kneel).round()
		var hip := Vector2(side*8,-23)+body_offset
		var knee := Vector2(side*9,-12).lerp(Vector2(side*15,-7),kneel).round()
		_segment(thighs[index],hip,knee,8)
		_segment(shins[index],knee,foot,10)
		wings[index].scale = Vector2(13,16)/wings[index].texture.get_size()
		wings[index].flip_h = side < 0
		wings[index].position = Vector2(side*17,-40)+body_offset
		wings[index].rotation = deg_to_rad(side*(5+sin(age*2)*3+absf(stride)*5))
	if not equipped:
		primary_hand.position = Vector2(facing*19,-28+roundf(stride*2))+body_offset
	if not working and not gathering:
		secondary_hand.position = Vector2(-facing*18,-29-roundf(stride*2))+body_offset
	secondary_hand.visible = true
	primary_hand.visible = true
	primary_hand.flip_h = facing < 0
	secondary_hand.flip_h = facing > 0
	for index in range(2):
		var side := facing if index == 0 else -facing
		var shoulder := Vector2(side*12,-44)+body_offset
		var hand := primary_hand.position if index == 0 else secondary_hand.position
		var elbow := (shoulder.lerp(hand,0.5)+Vector2(side*4,2)).round()
		_segment(arms[index],shoulder,elbow,8)
		_segment(forearms[index],elbow,hand,6)
		arms[index].flip_h = side < 0
		forearms[index].flip_h = side < 0
	queue_redraw()

func _segment(sprite: Sprite2D, start: Vector2, end: Vector2, width: float) -> void:
	var offset := end-start
	sprite.position = ((start+end)*0.5).round()
	sprite.rotation = offset.angle()-PI/2
	sprite.scale = Vector2(width,maxf(offset.length()+2,3))/sprite.texture.get_size()

func _draw() -> void:
	draw_ellipse_shadow()

func draw_ellipse_shadow() -> void:
	draw_set_transform(Vector2(0,-2),0,Vector2(1,0.27))
	draw_circle(Vector2.ZERO,18,Color(0.025,0.04,0.055,0.3))
	draw_set_transform(Vector2.ZERO)
