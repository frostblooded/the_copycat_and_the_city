extends InteractableArea

export var pile_scene: PackedScene = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _on_interact():
	var player: Player = Utils.get_player(get_tree())
	var player_inventory: Inventory = player.get_inventory()
	
	if player_inventory.can_push_item():
		var pile = pile_scene.instance()
		player_inventory.push_item(pile)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
