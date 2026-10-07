extends SceneTree

var failures: Array[String] = []

func check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _initialize() -> void:
	var bag := BituInventory.new()
	check(bag.add_item("tomate",51) == 0, "Dividir pilas")
	check(bag.slots.size() == 2 and bag.count("tomate") == 51, "Cantidad conservada")
	check(bag.add_item("tomate-pristino",1) == 0, "Calidad separada")
	check(bag.add_item("tomate-siru",1) == 0, "Variante separada")
	for index in range(8):
		bag.add_item("other_%d" % index,50)
	check(bag.slots.size() == 12, "Capacidad de mochila")
	check(bag.add_item("tomate",60) == 11, "Recogida parcial con mochila llena")
	check(bag.count("tomate") == 100, "No perder ni duplicar botín")
	check(bag.add_item("flor",1) == 1, "Dejar fuera lo que no cabe")
	var crop := BituCrop.new()
	crop.plant()
	crop.advance(5)
	check(crop.growth == 0, "Sin agua no crece")
	crop.irrigate()
	crop.advance(10)
	check(crop.growth == 8 and crop.water == 0, "No crecer más allá del agua disponible")
	crop.advance(10)
	check(crop.growth == 8 and crop.planted, "La sequía conserva progreso y cultivo")
	crop.irrigate()
	crop.advance(5)
	check(crop.is_ripe(), "Puede continuar y madurar")
	crop.free()
	var resource := BituResource.new()
	resource.zone = [Vector2i(19,17),Vector2i(20,18)]
	resource.cell = resource.zone[0]
	resource.harvest()
	resource.advance(13)
	check(not resource.active, "Respetar plazo de reaparición")
	resource.advance(2)
	check(resource.active and resource.cell == resource.zone[1], "Reaparecer en otro punto de la misma zona")
	resource.free()
	for cell in [Vector2i(0,0),Vector2i(13,18),Vector2i(31,31)]:
		check(BituTerrain.world_to_cell(BituTerrain.cell_to_world(cell)) == cell, "Conversión isométrica")
	if failures.is_empty():
		print("BITU_SMOKE_OK")
		quit(0)
	else:
		for message in failures:
			push_error(message)
		quit(1)
