extends InteractableArea

export var pile_scene: PackedScene = null


func _on_interact():
	if not $Order/PlacementPosition.is_reserved:
		return
	
	var player: Player = get_tree().root.get_node("Main").get_node("Player")
	player.get_inventory().push_item($Order/PlacementPosition.remove_item())

