extends InteractableArea
class_name TableInteractableArea


func _on_interact():
	if $PlacementPosition.is_reserved:
		return

	var player: Player = get_tree().root.get_node("Main").get_node("Player")
	var inventory: Inventory = player.get_inventory()

	if not inventory.has_items():
		return

	var top_item: Node2D = inventory.pop_item()
	$PlacementPosition.add_item(top_item)
