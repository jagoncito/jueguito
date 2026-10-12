class_name BituIslandTerrainChunk
extends Node2D
## Geometría agrupada por textura, preparada una vez y conservada al caminar.
var tiles: Array[Dictionary] = []
var complete := false
var draw_cpu_usec := 0
var meshes: Array[Dictionary] = []
var farm_borders: Array[PackedVector2Array] = []

func finish() -> void:
	var groups := {}
	for tile in tiles:
		if tile.water:
			_texture_quad(groups,"water",tile.texture,tile.origin)
			for edge: Texture2D in tile.edges: _texture_quad(groups,"foam",edge,tile.origin)
		else:
			var backdrop := _group(groups,"ground",null)
			_polygon(backdrop,tile.points,PackedVector2Array([Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]),Color("567946"))
			_polygon(_group(groups,str(tile.texture.get_instance_id()),tile.texture),tile.points,tile.uv,tile.tint)
			if tile.farm: farm_borders.append(tile.points+PackedVector2Array([tile.points[0]]))
	# Fondo, superficies, agua y espuma en capas estables.
	var order: Array = groups.keys()
	order.erase("ground"); order.erase("water"); order.erase("foam")
	if groups.has("ground"): order.push_front("ground")
	for key in ["water","foam"]:
		if groups.has(key): order.append(key)
	for key in order:
		var batch: Dictionary = groups[key]
		var arrays := []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = PackedVector2Array(batch.vertices)
		arrays[Mesh.ARRAY_TEX_UV] = PackedVector2Array(batch.uv)
		arrays[Mesh.ARRAY_COLOR] = PackedColorArray(batch.colors)
		arrays[Mesh.ARRAY_INDEX] = PackedInt32Array(batch.indices)
		var mesh := ArrayMesh.new()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
		meshes.append({"mesh":mesh,"texture":batch.texture})
	tiles.clear()
	complete = true
	queue_redraw()

func _group(groups: Dictionary, key: String, texture: Texture2D) -> Dictionary:
	if not groups.has(key): groups[key] = {"texture":texture,"vertices":[],"uv":[],"colors":[],"indices":[]}
	return groups[key]

func _polygon(batch: Dictionary, points: PackedVector2Array, uv: PackedVector2Array, color: Color) -> void:
	var start: int = batch.vertices.size()
	batch.vertices.append_array(points)
	batch.uv.append_array(uv)
	for point in points: batch.colors.append(color)
	batch.indices.append_array([start,start+1,start+2,start,start+2,start+3])

func _texture_quad(groups: Dictionary, key: String, texture: Texture2D, origin: Vector2) -> void:
	var frame := texture as AtlasTexture
	var size_px := frame.region.size
	var rect := frame.region
	var atlas_size := frame.atlas.get_size()
	var points := PackedVector2Array([origin,origin+Vector2(size_px.x,0),origin+size_px,origin+Vector2(0,size_px.y)])
	var uv := PackedVector2Array([rect.position,rect.position+Vector2(rect.size.x,0),rect.end,rect.position+Vector2(0,rect.size.y)])
	for i in range(uv.size()): uv[i] /= atlas_size
	_polygon(_group(groups,key,frame.atlas),points,uv,Color.WHITE)

func _draw() -> void:
	var started := Time.get_ticks_usec()
	for batch in meshes: draw_mesh(batch.mesh,batch.texture)
	for border in farm_borders: draw_polyline(border,Color("806047"),1)
	draw_cpu_usec = Time.get_ticks_usec()-started
