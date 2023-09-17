extends Node2D
class_name Order

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
	$PlacementPosition.add_item(pile)
	$OrderStartedAudioPlayer.play()
	emit_signal("order_started", $Timer.time_left)


func _on_Timer_timeout():
	cancel_order()


func cancel_order():
	is_running = false
	$Timer.stop()


func complete():
	cancel_order()
	get_tree().root.find_node("ScoreManager", true, false).add_score(order_score_reward)
	emit_signal("order_completed")


func get_desk() -> Node2D:
	return get_parent() as Node2D
