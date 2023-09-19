extends InteractableArea
class_name DeskInteractableArea

export var pile_scene: PackedScene = null


func _on_interact():
	if $Order/PlacementPosition.is_reserved:
		remove_item()
	else:
		add_item()


func remove_item():
	assert($Order/PlacementPosition.is_reserved)
	var player: Player = Utils.get_player(get_tree())
	player.get_inventory().push_item($Order/PlacementPosition.remove_item())


func add_item():
	assert(!$Order/PlacementPosition.is_reserved)
	var player: Player = Utils.get_player(get_tree())
	var inventory = player.get_inventory()
	var pile: Pile = inventory.get_top_item() as Pile

	if pile == null:
		return

	if !pile.is_copied:
		return
	
	if pile.is_failed:
		return
	
	if pile.desk != self:
		return

	inventory.pop_item()
	$Order.complete()


func _on_complete():
	pass # Replace with function body.
