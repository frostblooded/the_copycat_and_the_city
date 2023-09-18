extends Node2D
class_name Order

var current_pile: Pile = null
var is_running: bool = false
export var pile_scene: PackedScene = null
export var order_score_reward: int = 10

signal order_started(time)
signal order_completed()


func start():
	is_running = true
	$Timer.start()
	var pile: Pile = pile_scene.instance()
	var desk = get_desk()
	pile.desk = desk
	pile.get_node("SymbolUI").texture = desk.get_node("SymbolUI").texture
	current_pile = pile
	$PlacementPosition.add_item(pile)
	$OrderStartedAudioPlayer.play()
	emit_signal("order_started", $Timer.time_left)


func _on_Timer_timeout():
	stop_order()


func stop_order():
	current_pile.set_as_failed()
	current_pile = null
	is_running = false
	$Timer.stop()
	if $PlacementPosition.get_child_count() > 0:
		$PlacementPosition.remove_item()


func complete():
	stop_order()
	get_tree().root.find_node("ScoreManager", true, false).add_score(order_score_reward)
	$OrderCompletedAudioPlayer.play()
	emit_signal("order_completed")


func get_desk() -> Node2D:
	return get_parent() as Node2D
