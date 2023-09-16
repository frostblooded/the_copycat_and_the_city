extends InteractableArea
class_name TableInteractableArea


func get_placement_positions() -> Array:
	return $PlacementPositions.get_children()


func _on_interact():
	var player: Player = get_tree().root.get_node("Main").get_node("Player")
	var inventory: Inventory = player.get_inventory()

	if not inventory.has_items():
		return

	for placement_position in get_placement_positions():
		if not placement_position.is_reserved:
			var top_item: Node2D = inventory.pop_item()
			placement_position.add_item(top_item)
			break
