extends Node2D
class_name Inventory


func add(item: Node2D):
	add_child(item)


func remove(item: Node2D):
	remove_child(item)


func get_items() -> Array:
	return get_children()


func has_items() -> bool:
	return get_items().size() > 0


func pop_item() -> Node2D:
	var items: Array = get_children()
	var last_item: Node2D = items[items.size() - 1]
	remove(last_item)
	return last_item
