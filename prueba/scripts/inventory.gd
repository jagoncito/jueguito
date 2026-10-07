class_name BituInventory
extends RefCounted

const SLOT_COUNT := 12 # Parámetro provisional de la prueba.
const STACK_LIMIT := 50
var slots: Array[Dictionary] = []

func add_item(item_id: String, amount: int = 1) -> int:
	var remaining := amount
	for slot in slots:
		if slot.id == item_id:
			var accepted := mini(remaining, STACK_LIMIT - int(slot.amount))
			slot.amount += accepted
			remaining -= accepted
			if remaining == 0:
				return 0
	while remaining > 0 and slots.size() < SLOT_COUNT:
		var accepted := mini(remaining, STACK_LIMIT)
		slots.append({"id": item_id, "amount": accepted})
		remaining -= accepted
	return remaining

func count(item_id: String) -> int:
	var total := 0
	for slot in slots:
		if slot.id == item_id:
			total += int(slot.amount)
	return total
