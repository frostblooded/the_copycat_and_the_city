extends Node2D
class_name PlacementPosition

var is_reserved: bool = false


func add_item(item: Node2D):
	add_child(item)
	is_reserved = true


func remove_item() -> Node2D:
	var item: Node2D = get_child(0)
	remove_child(item)
	is_reserved = false
	return item