extends Node2D
class_name Order

var is_running: bool = false
export var pile_scene: PackedScene = null


func start():
	is_running = true
	$Timer.start()
	var pile: Pile = pile_scene.instance()
	var desk = get_desk()
	pile.desk = desk
	pile.get_node("SymbolUI").texture = desk.get_node("SymbolUI").texture
	$PlacementPosition.add_item(pile)


func _on_Timer_timeout():
	get_tree().quit()


func complete():
	is_running = false
	$Timer.stop()
	print("Completed order!")


func get_desk() -> Node2D:
	return get_parent() as Node2D
