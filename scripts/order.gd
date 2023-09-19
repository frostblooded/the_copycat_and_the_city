extends Node2D
class_name Order

var current_pile: Pile = null
var is_running: bool = false
var is_modified_order: bool = false
var unmodified_timer_wait_time: float = 0
export var pile_scene: PackedScene = null
export var order_score_reward: int = 10
onready var game_manager: GameManager = Utils.get_global_node(get_tree(), "GameManager")

signal order_started(time)
signal order_completed()


func start():
	if game_manager.wanted_easier_orders > 0:
		# Make order easier
		game_manager.wanted_easier_orders -= 1
		is_modified_order = true
		unmodified_timer_wait_time = $Timer.wait_time
		$Timer.wait_time *= 1.5

	if game_manager.wanted_harder_orders > 0:
		# Make order harder
		game_manager.wanted_harder_orders -= 1
		is_modified_order = true
		unmodified_timer_wait_time = $Timer.wait_time
		$Timer.wait_time *= 0.7

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
	game_manager.successfully_completed_orders_in_a_row = 0
	stop_order()


func stop_order():
	current_pile.set_as_failed()
	is_running = false
	$Timer.stop()
	if $PlacementPosition.is_reserved:
		$PlacementPosition.remove_item()

	if is_modified_order:
		$Timer.wait_time = unmodified_timer_wait_time
		is_modified_order = false
		unmodified_timer_wait_time = 0


func complete():
	stop_order()
	get_tree().root.find_node("ScoreManager", true, false).add_score(order_score_reward)
	$OrderCompletedAudioPlayer.play()
	game_manager.successfully_completed_orders_in_a_row += 1
	emit_signal("order_completed")

	if game_manager.successfully_completed_orders_in_a_row >= 3:
		game_manager.wanted_harder_orders += 1


func get_desk() -> Node2D:
	return get_parent() as Node2D
