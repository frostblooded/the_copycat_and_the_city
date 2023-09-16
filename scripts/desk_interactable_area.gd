extends InteractableArea

export var pile_scene: PackedScene = null


func _on_interact():
	var player: Player = get_tree().root.get_node("Main").get_node("Player")
	player.get_node("Inventory").add(pile_scene.instance())
