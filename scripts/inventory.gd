extends Node2D
class_name Inventory


func push_item(item: Node2D):
	for placement_position in get_children():
		if placement_position.is_reserved:
			continue
		
		placement_position.add_item(item)
		return


func get_items() -> Array:
	return get_children()


func has_items() -> bool:
	return get_items().size() > 0


func pop_item() -> Node2D:
	var placement_positions: Array = get_children()

	for i in range(placement_positions.size() - 1, -1, -1):
		var placement_position: PlacementPosition = placement_positions[i]

		if placement_position.is_reserved:
			return placement_position.remove_item()
	
	return null
