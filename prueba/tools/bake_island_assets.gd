extends SceneTree
## Empaquetado técnico de piezas completas existentes: recorte y nearest uniforme.
func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var document: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(args[0]))
	for job: Dictionary in document.jobs:
		var source := Image.new()
		assert(source.load(job.source)==OK)
		source.convert(Image.FORMAT_RGBA8)
		var r: Array = job.region
		var image := source.get_region(Rect2i(r[0],r[1],r[2],r[3]))
		image.resize(maxi(1,roundi(r[2]*job.scale)),maxi(1,roundi(r[3]*job.scale)),Image.INTERPOLATE_NEAREST)
		# Las fuentes conservan halos semitransparentes de fondo. La importación
		# excluye solo ese alfa débil; los originales no se reescriben.
		for y in range(image.get_height()):
			for x in range(image.get_width()):
				var color := image.get_pixel(x,y)
				if color.a < 0.94: image.set_pixel(x,y,Color.TRANSPARENT)
		assert(image.save_png(job.output)==OK)
	print("BITU_ISLAND_ASSETS_BAKED:",document.jobs.size())
	quit()
