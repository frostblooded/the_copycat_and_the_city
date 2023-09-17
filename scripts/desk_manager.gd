extends Node2D
class_name DeskManager

export(Array, Texture) var symbols_for_assigning: Array = []


func _on_OrderSpawnCooldown_timeout():
	var order: Order = get_first_available_order()

	if order == null:
		return
	
	order.start()


func _ready():
	assign_desk_symbols()


func assign_desk_symbols():
	var desks: Array = get_desks()
	assert(desks.size() == symbols_for_assigning.size())

	for i in range(0, desks.size()):
		var desk = desks[i]
		var symbol = symbols_for_assigning[i]
		desk.get_node("SymbolUI").texture = symbol


func get_first_available_order() -> Order:
	for desk in get_desks():
		var order: Order = desk.get_node("Order")

		if not order.is_running:
			return order

	return null
	

func get_desks():
	return get_tree().get_nodes_in_group("desks")

