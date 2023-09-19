extends Node2D
class_name Order

var current_pile: Pile = null
var is_running: bool = false
var is_easy_order: bool = false
var easy_order_timer_wait_time: float = 0
export var pile_scene: PackedScene = null
export var order_score_reward: int = 10
onready var game_manager: GameManager = Utils.get_global_node(get_tree(), "GameManager")

signal order_started(time)
signal order_completed()


func start():
	if game_manager.wanted_easier_orders > 0:
		game_manager.wanted_easier_orders -= 1
		is_easy_order = true
		easy_order_timer_wait_time = $Timer.wait_time
		$Timer.wait_time *= 1.5

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
	current_pile.set_as_failed()
	game_manager.wanted_easier_orders += 1
	stop_order()


func stop_order():
	current_pile = null
	is_running = false
	$Timer.stop()

	if is_easy_order:
		$Timer.wait_time = easy_order_timer_wait_time
		is_easy_order = false
		easy_order_timer_wait_time = 0


func complete():
	stop_order()
	get_tree().root.find_node("ScoreManager", true, false).add_score(order_score_reward)
	$OrderCompletedAudioPlayer.play()
	emit_signal("order_completed")


func get_desk() -> Node2D:
	return get_parent() as Node2D
