extends Node2D
class_name OrderManager


func _on_OrderSpawnCooldown_timeout():
	var order: Order = get_first_available_order()

	if order == null:
		return
	
	order.start()


func get_first_available_order() -> Order:
	var desks: Array = get_tree().get_nodes_in_group("desks")

	for desk in desks:
		var order: Order = desk.get_node("Order")

		if not order.is_running:
			return order

	return null
	
