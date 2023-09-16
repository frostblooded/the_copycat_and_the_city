extends Node2D
class_name PlacementPosition

var is_reserved: bool = false


func add_item(item: Node2D):
	if is_reserved:
		push_error("Adding item to a placement position that already has an item!")
		return

	add_child(item)
	is_reserved = true


func remove_item() -> Node2D:
	var item: Node2D = get_child(0)

	if item == null:
		push_error("Trying to remove item from an empty placement position")
		return null

	remove_child(item)
	is_reserved = false
	return item


func get_item() -> Node2D:
	return get_child(0) as Node2D