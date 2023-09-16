extends InteractableArea

export var pile_scene: PackedScene = null


func _on_interact():
	var player: Player = Utils.get_player(get_tree())
	player.get_inventory().push_item(pile_scene.instance())
