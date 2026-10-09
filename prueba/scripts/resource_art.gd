class_name BituResourceArt
extends RefCounted
## Un catálogo, dos atlas originales y recortes distintos para terreno y botín.

const ROOT := "res://assets/entorno/recursos/"
static var _catalog: Dictionary = {}
static var _textures: Dictionary = {}
static var _images: Dictionary = {}

static func catalog() -> Dictionary:
	if _catalog.is_empty():
		_catalog = JSON.parse_string(FileAccess.get_file_as_string(ROOT+"recursos.json"))
	return _catalog

static func entry(id: String) -> Dictionary:
	return catalog()["frames"][id]

static func texture(id: String) -> AtlasTexture:
	if not _textures.has(id):
		var frame := entry(id)
		var region: Array = frame["region_px"]
		var atlas := AtlasTexture.new()
		atlas.atlas = load(ROOT+catalog()["sources"][frame["source"]]["file"])
		atlas.region = Rect2(region[0],region[1],region[2],region[3])
		atlas.filter_clip = true
		_textures[id] = atlas
	return _textures[id]

static func loot_texture(item_id: String) -> AtlasTexture:
	return texture(catalog()["items"][item_id])

static func configure(sprite: Sprite2D, id: String) -> void:
	var frame := entry(id)
	var anchor: Array = frame["anchor_px"]
	var factor: float = frame["scale"]
	sprite.texture = texture(id)
	sprite.centered = false
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2.ONE*factor
	sprite.position = -Vector2(anchor[0],anchor[1])*factor

static func bounds(id: String) -> Rect2:
	var frame := entry(id)
	var anchor: Array = frame["anchor_px"]
	var region: Array = frame["region_px"]
	var factor: float = frame["scale"]
	return Rect2(-Vector2(anchor[0],anchor[1])*factor,Vector2(region[2],region[3])*factor)

static func contains(id: String, point: Vector2) -> bool:
	if not bounds(id).has_point(point):
		return false
	var frame := entry(id)
	var source: String = frame["source"]
	if not _images.has(source):
		_images[source] = texture(id).atlas.get_image()
	var source_image: Image = _images[source]
	var region: Array = frame["region_px"]
	var anchor: Array = frame["anchor_px"]
	var pixel := point/float(frame["scale"])+Vector2(anchor[0]+region[0],anchor[1]+region[1])
	return source_image.get_pixel(int(pixel.x),int(pixel.y)).a > 0.15
