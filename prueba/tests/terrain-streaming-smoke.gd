extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var terrain := BituIslandTerrain.new()
	root.add_child(terrain)
	var viewport := Vector2(1280,720)
	var prepared := 0
	var peak := 0
	for zoom in [1.5,0.75]:
		var start := Vector2(3520,1880)
		terrain.prime_view(start,viewport,zoom)
		for frame in range(240):
			var at := start-Vector2(frame*3,frame*1.5)
			terrain.update_view(at,viewport,zoom)
			await process_frame
			await process_frame
			assert(terrain.view_ready(at,viewport,zoom),"Precarga completa antes de alcanzar la vista")
			peak = maxi(peak,terrain.last_prepare_usec)
		var before := terrain.prepared_tiles
		for frame in range(5):
			terrain.update_view(start-Vector2(239*3,239*1.5),viewport,zoom)
			await process_frame
		# Al quedar quieto, termina la precarga y deja de construir.
		while not terrain.pending.is_empty(): await process_frame
		before = terrain.prepared_tiles
		for frame in range(10): await process_frame
		assert(terrain.prepared_tiles==before,"El terreno preparado se conserva sin reconstrucción")
		prepared = terrain.prepared_tiles
	# Volver a un punto en caché tampoco reconstruye sus casillas.
	var before := terrain.prepared_tiles
	terrain.update_view(Vector2(3520,1880),viewport,.75)
	assert(terrain.view_ready(Vector2(3520,1880),viewport,.75))
	await process_frame
	assert(terrain.prepared_tiles==before,"Revisitar reutiliza bloques")
	print("BITU_TERRAIN_STREAMING_OK:",JSON.stringify({"prepare_peak_ms":peak/1000.0,"tiles":prepared,"cached_chunks":terrain.chunks.size()}))
	quit()
