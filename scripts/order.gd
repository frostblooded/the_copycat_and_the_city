extends Node2D
class_name Order

var is_running: bool = false
export var pile_scene: PackedScene = null


func start():
	is_running = true
	$Timer.start()
	$PlacementPosition.add_item(pile_scene.instance())


func _on_Timer_timeout():
	get_tree().quit()
