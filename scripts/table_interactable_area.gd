extends InteractableArea
class_name TableInteractableArea


func _on_interact():
	if $PlacementPosition.is_reserved:
		remove_item()
	else:
		add_item()


func remove_item():
	assert($PlacementPosition.is_reserved)

	var item: Node2D = $PlacementPosition.remove_item()

	var player: Player = get_tree().root.get_node("Main").get_node("Player")
	var inventory: Inventory = player.get_inventory()
	var succeeded_adding_item_to_player: bool = inventory.push_item(item)

	if not succeeded_adding_item_to_player:
		$PlacementPosition.add_item(item)


func add_item():
	assert(!$PlacementPosition.is_reserved)

	var player: Player = get_tree().root.get_node("Main").get_node("Player")
	var inventory: Inventory = player.get_inventory()

	if not inventory.has_items():
		return

	var top_item: Node2D = inventory.pop_item()
	$PlacementPosition.add_item(top_item)
