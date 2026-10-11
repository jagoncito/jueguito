class_name BituInventory
extends RefCounted

const SLOT_COUNT := 24
const STACK_LIMIT := 1000
signal changed
var slots: Array[Dictionary] = []

func add_item(item_id: String, amount: int = 1) -> int:
	var remaining := amount
	for slot in slots:
		if slot.get("id","") == item_id:
			var accepted := mini(remaining, STACK_LIMIT - int(slot.amount))
			slot.amount += accepted
			remaining -= accepted
			if remaining == 0:
				changed.emit()
				return 0
	for index in range(slots.size()):
		if slots[index].is_empty() and remaining > 0:
			var accepted := mini(remaining,STACK_LIMIT)
			slots[index] = {"id":item_id,"amount":accepted}
			remaining -= accepted
	while remaining > 0 and slots.size() < SLOT_COUNT:
		var accepted := mini(remaining, STACK_LIMIT)
		slots.append({"id": item_id, "amount": accepted})
		remaining -= accepted
	changed.emit()
	return remaining

func count(item_id: String) -> int:
	var total := 0
	for slot in slots:
		if slot.get("id","") == item_id:
			total += int(slot.amount)
	return total

func item_at(index: int) -> Dictionary:
	return slots[index] if index >= 0 and index < slots.size() else {}

func used_slots() -> int:
	var count := 0
	for slot in slots:
		if not slot.is_empty(): count += 1
	return count

func move_stack(source: int, destination: int, split := false) -> bool:
	if source == destination or destination < 0 or destination >= SLOT_COUNT:
		return false
	var origin := item_at(source)
	if origin.is_empty(): return false
	var target := item_at(destination)
	if split and not target.is_empty() and target.id != origin.id: return false
	while slots.size() <= destination: slots.append({})
	var amount := ceili(float(origin.amount)/2.0) if split else int(origin.amount)
	if target.is_empty():
		slots[destination] = {"id":origin.id,"amount":amount}
		origin.amount -= amount
	elif target.id == origin.id:
		var accepted := mini(amount,STACK_LIMIT-int(target.amount))
		if accepted == 0: return false
		target.amount += accepted
		origin.amount -= accepted
	else:
		slots[destination] = origin
		slots[source] = target
		changed.emit()
		return true
	if origin.amount == 0: slots[source] = {}
	changed.emit()
	return true

func sort_items() -> void:
	var totals := {}
	for slot in slots:
		if not slot.is_empty(): totals[slot.id] = int(totals.get(slot.id,0))+int(slot.amount)
	slots.clear()
	var ids: Array = totals.keys()
	ids.sort()
	for id in ids:
		var amount: int = totals[id]
		while amount > 0:
			var accepted := mini(amount,STACK_LIMIT)
			slots.append({"id":id,"amount":accepted})
			amount -= accepted
	changed.emit()
