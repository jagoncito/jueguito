extends SceneTree
## Comprueba el dibujo mostrado; las antiguas articulaciones ya no intervienen.
var failures := 0
var originals: Dictionary = {}

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		failures += 1

func frame_image(visual: BituDragonVisual, key: String) -> Image:
	var frame: Dictionary = visual.catalog.frames[key]
	# El importador extiende RGB bajo píxeles transparentes para evitar halos.
	# La comparación del arte usa el PNG original, no esos RGB invisibles.
	if not originals.has(frame.file):
		var source:=Image.new()
		check(source.load_png_from_buffer(FileAccess.get_file_as_bytes(visual.DIRECTORY+frame.file))==OK,"PNG fuente legible: "+frame.file)
		originals[frame.file]=source
	var area: Array=frame.region
	var result: Image=originals[frame.file].get_region(Rect2i(area[0],area[1],area[2],area[3]))
	result.convert(Image.FORMAT_RGBA8)
	return result

func pixels_sha256(image: Image) -> String:
	var context := HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(image.get_data())
	return context.finish().hex_encode()

func check_preserved(visual: BituDragonVisual) -> void:
	var baseline: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://tests/dragon-preserved-baseline.json"))
	check(baseline.size()==80,"Referencia de NORTE, pesca, flores y zarpazo completa")
	for key: String in baseline:
		var old: Dictionary = baseline[key]
		var frame: Dictionary = visual.catalog.frames.get(key,{})
		check(not frame.is_empty(),"Pose conservada disponible: "+key)
		if frame.is_empty(): continue
		check(pixels_sha256(frame_image(visual,key))==old.pixel_sha256,"Píxeles conservados: "+key)
		check(is_equal_approx(float(frame.scale),float(old.scale)),"Escala conservada: "+key)
		check(frame.get("mirror_x",false)==old.mirror_x,"Perspectiva conservada: "+key)
		for axis in range(2):
			check(frame.region[axis]-frame.anchor[axis]==old.offset[axis],"Anclaje conservado: "+key)
			check(frame.hand[axis]-frame.anchor[axis]==old.hand_offset[axis],"Palma conservada: "+key)
			check(frame.other_hand[axis]-frame.anchor[axis]==old.other_hand_offset[axis],"Segunda palma conservada: "+key)
		for contact: String in old.contacts:
			check(frame.get("contacts",{}).has(contact),"Contacto conservado: "+key)
			if not frame.get("contacts",{}).has(contact): continue
			for axis in range(2):
				check(frame.contacts[contact][axis]-frame.anchor[axis]==old.contacts[contact][axis],"Extremo conservado: "+key)

func check_gait(actor: BituPlayer, direction: int, running: bool) -> void:
	var visual := actor.dragon
	var keys := visual.animation_frames("sprint" if running else "andar",direction)
	var north_preserved := direction==4
	check(keys.size()==4 if north_preserved else keys.size()>=6,"Ciclo completo en dirección %s" % direction)
	if keys.is_empty(): return
	actor.direction_index = direction
	actor.sprinting = running
	actor.walk_time = 0
	actor.animate_pose(0)
	var idle_image := visual.body.texture.get_image()
	var idle_top := visual.body.position.y+idle_image.get_used_rect().position.y*visual.body.scale.y
	var size := Vector2i.ZERO
	var scale := Vector2.ZERO
	var anchor := Vector2.ZERO
	var images := {}
	var feet := []
	for phase in range(keys.size()):
		actor.walk_time = (phase+0.01)*4.6/keys.size()
		actor.animate_pose(0)
		check(visual.current_frame==keys[phase],"Se muestra la fase registrada, sin rig oculto")
		check(visual.body.visible,"El fotograma completo se dibuja en cada fase")
		check(visual.body.rotation==0 and visual.body.skew==0,"Sin girar ni deformar el sprite del cuerpo")
		check(not visual.has_baked_tool(),"Marcha y carrera con manos libres")
		var image := frame_image(visual,keys[phase])
		var frame: Dictionary = visual.catalog.frames[keys[phase]]
		var canvas: Array=frame.get("canvas_px",[image.get_width(),image.get_height()])
		var canvas_size:=Vector2i(canvas[0],canvas[1])
		var origin: Array=frame.get("canvas_anchor_px",[frame.anchor[0]-frame.region[0],frame.anchor[1]-frame.region[1]])
		var cell_anchor:=Vector2(origin[0],origin[1])
		if phase==0:
			size=canvas_size;scale=visual.body.scale;anchor=cell_anchor
		check(visual.body.scale==scale and scale.x==scale.y,"Una escala uniforme para todo el ciclo")
		if not north_preserved:
			check(canvas_size==size and cell_anchor==anchor,"Lienzo lógico y apoyo comunes en las seis fases")
		var top := visual.body.position.y+image.get_used_rect().position.y*scale.y
		check(absf(idle_top-top)<2.01,"Reposo/marcha/carrera sin crecer: dirección %s fase %s" % [direction,phase])
		if visual.body.flip_h: image.flip_x()
		images[pixels_sha256(image)]=true
		var lower := image.get_region(Rect2i(0,int(image.get_height()*0.7),image.get_width(),image.get_height()-int(image.get_height()*0.7)))
		feet.append(pixels_sha256(lower))
	check(images.size()==keys.size(),"Cada fase tiene su dibujo completo propio")
	check(feet[0]!=feet[keys.size()/2],"Los pies cambian en las dos medias zancadas")
	actor.walk_time=0
	actor.animate_pose(0)
	check(visual.current_frame=="reposo-"+visual.catalog.directions[direction],"Al parar se vuelve al reposo de esa dirección")

func run() -> void:
	var actor := BituPlayer.new()
	actor.equipment_enabled=true
	root.add_child(actor)
	actor.set_physics_process(false)
	actor.set_process(false)
	var visual := actor.dragon
	check(visual.get_child_count()==3 and visual.hand_cover.get_parent()==actor and visual.other_hand_cover.get_parent()==actor,"Sprite completo y dos anclas; cubiertas de dedos en la capa del jugador, sin piezas articuladas")
	check_preserved(visual)
	for direction in range(8):
		for running in [false,true]:
			check_gait(actor,direction,running)
		for action in [&"minar",&"talar"]:
			var frames := visual.animation_frames(String(action),direction)
			check(frames.size()>=6,"Preparación, carga, anticipación, golpe, seguimiento y recuperación")
			if frames.size()<6: continue
			var contact := visual.impact_contact_local(direction,action)
			check(contact.is_finite(),"Contacto del extremo activo registrado")
			for phase in range(6):
				visual.show_work(action,visual.WORK_TIMES[phase],direction)
				check(visual.current_frame==frames[phase],"El reloj selecciona la fase completa de trabajo")
				check(visual.body.visible and visual.has_baked_tool(),"Herramienta y agarre están dibujados en el mismo fotograma")
			visual.show_work(action,0.33,direction)
			check(visual.contact_local(action).distance_to(contact)<0.001,"El contacto de impacto usa el mismo dibujo que se muestra")
			var frame: Dictionary=visual.catalog.frames[visual.current_frame]
			check(frame.get("working_end","")==("axe_edge" if action==&"talar" else "pick_tip"),"Pico para mena y filo para tala")
			var point: Array=frame.contacts[String(action)]
			var image: Image=visual.textures[frame.file].get_image()
			check(image.get_pixel(int(point[0]),int(point[1])).a>0.5,"El contacto está sobre un píxel visible de la herramienta")
	if failures==0:
		print("BITU_DRAGON_GAIT_SMOKE_OK: fotogramas completos, seis fases, continuidad y 80 poses conservadas")
	actor.queue_free()
	await process_frame
	quit(0 if failures==0 else 1)
