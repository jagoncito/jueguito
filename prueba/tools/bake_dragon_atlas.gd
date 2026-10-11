extends SceneTree
## Importador nativo de fotogramas COMPLETOS. No articula ni retoca el dibujo.
## Un único factor uniforme y una traslación por fotograma; nearest, sin giro.

const CELL := Vector2i(192,192)
const ANCHOR := Vector2(96,168)

func _initialize() -> void:
	var arguments := OS.get_cmdline_user_args()
	if arguments.size() != 1:
		fail("Uso: --script bake_dragon_atlas.gd -- trabajos.json")
		return
	var document: Variant = JSON.parse_string(FileAccess.get_file_as_string(arguments[0]))
	if not document is Dictionary or not document.has("jobs"):
		fail("Registro de empaquetado inválido")
		return
	var images := {}
	var masks := {}
	for job: Dictionary in document.jobs:
		var frames: Array = job.frames
		var atlas := Image.create(CELL.x*frames.size(),CELL.y,false,Image.FORMAT_RGBA8)
		atlas.fill(Color.TRANSPARENT)
		for index in range(frames.size()):
			var frame: Dictionary = frames[index]
			var filename: String = frame.file
			if not images.has(filename):
				var source := Image.new()
				var status := source.load(filename)
				if status != OK:
					fail("No se puede cargar %s: %s" % [filename,status])
					return
				source.convert(Image.FORMAT_RGBA8)
				images[filename] = source
			var image: Image = images[filename]
			var region := Rect2i(frame.region[0],frame.region[1],frame.region[2],frame.region[3])
			var source_anchor := Vector2(frame.anchor[0],frame.anchor[1])
			var factor: float = frame.import_scale
			var mirror: bool = frame.get("mirror_x",false)
			var isolation := PackedByteArray()
			if frame.has("whole_figure_seed"):
				var seed: Array = frame.whole_figure_seed
				var mask_key := "%s:%s:%s" % [filename,seed[0],seed[1]]
				if not masks.has(mask_key):
					masks[mask_key] = whole_figure_mask(image,Vector2i(seed[0],seed[1]))
				isolation = masks[mask_key]
			# Se muestrea siempre el personaje completo desde la misma transformación.
			# No hay factores separados para cabeza, torso, brazos ni piernas.
			for y in range(CELL.y):
				for x in range(CELL.x):
					var logical := Vector2(x+0.5,y+0.5)-ANCHOR
					if mirror:
						logical.x *= -1.0
					var sample := source_anchor+logical/factor
					var pixel := Vector2i(floori(sample.x),floori(sample.y))
					if region.has_point(pixel) and (isolation.is_empty() or isolation[pixel.y*image.get_width()+pixel.x]>0):
						atlas.set_pixel(index*CELL.x+x,y,image.get_pixelv(pixel))
		var save_status := atlas.save_png(job.output)
		if save_status != OK:
			fail("No se puede guardar %s: %s" % [job.output,save_status])
			return
	print("BITU_FULL_SPRITE_BAKE_OK: ",document.jobs.size()," atlas completos, nearest uniforme")
	quit(0)

func whole_figure_mask(source: Image, seed: Vector2i) -> PackedByteArray:
	# Aísla una figura ENTERA ya dibujada cuando las cajas de una hoja se solapan.
	# No separa miembros ni altera colores/proporciones: conserva cuerpo+instrumento.
	var width := source.get_width()
	var height := source.get_height()
	var mask := PackedByteArray()
	mask.resize(width*height)
	var pending: Array[Vector2i] = [seed]
	mask[seed.y*width+seed.x] = 1
	var read := 0
	while read < pending.size():
		var point: Vector2i = pending[read]
		read += 1
		for dy in [-1,0,1]:
			for dx in [-1,0,1]:
				var near := point+Vector2i(dx,dy)
				if near.x<0 or near.y<0 or near.x>=width or near.y>=height:
					continue
				var index := near.y*width+near.x
				if mask[index]>0 or source.get_pixelv(near).a<=25.0/255.0:
					continue
				mask[index]=1
				pending.append(near)
	return mask

func fail(message: String) -> void:
	push_error(message)
	quit(1)
