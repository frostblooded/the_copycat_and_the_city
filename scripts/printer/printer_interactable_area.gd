extends InteractableArea

signal pile_completed()
signal pile_taken()
signal pile_added(time)

export var max_paper = 100
export var current_paper = -1
export var time_per_paper = 1.0
export var stall_chance_per_frame: float = 0.001
export var unsall_chance_per_interact: float = 0.3

var timer: Timer = Timer.new()
var is_ready = false
var is_stalled: bool = false

onready var inventory = get_node("Inventory")

func is_empty():
	return inventory.get_child_count() == 0


func is_copying() -> bool:
	return not timer.is_stopped()


func _ready():
	if current_paper == -1:
		current_paper = max_paper
	timer.connect("timeout",self, "_on_timer_expire")
	add_child(timer)
	connect("pile_added", self, "_on_pile_added")


func _process(delta):
	if is_copying():
		if randf() < stall_chance_per_frame:
			stall()


func _on_interact():
	if is_stalled:
		if randf() < unsall_chance_per_interact:
			unstall()

	var player_inventory = Utils.get_player(get_tree()).get_inventory()
	if is_empty():
		if not player_inventory.has_items():
			return

		var pile: Pile = player_inventory.pop_item()

		var took_pile = take_pile(pile)

		if not took_pile:
			player_inventory.push_item(pile)
	elif is_ready:
		return_pile(player_inventory)


func stall():
	is_stalled = true
	timer.paused = true
	$StalledUI.visible = true
	$Progress.visible = false


func unstall():
	is_stalled = false
	timer.paused = false
	$StalledUI.visible = false
	$Progress.visible = true


func return_pile(player_inventory):
	var pile: Pile = inventory.get_child(0) as Pile

	if player_inventory.can_push_item():
		$SymbolUI.texture = null
		pile.set_as_copied()
		inventory.remove_child(pile)
		player_inventory.push_item(pile)
		emit_signal("pile_taken")


func take_pile(pile): 
	if pile.is_copied:
		return false

	# TODO: fix this
	var paper_count = 1

	if current_paper < paper_count:
		return false
	
	inventory.add_child(pile)

	current_paper -= paper_count

	timer.wait_time = time_per_paper * paper_count
	timer.one_shot = true
	timer.start()
	is_ready = false
	emit_signal("pile_added", timer.time_left)
	return true

func _on_timer_expire():
	is_ready = true
	$PrinterWorkingAudioPlayer.stop()
	$AnimationPlayer.stop()
	emit_signal("pile_completed")

func _on_pile_added(time):
	var pile: Pile = inventory.get_child(0) as Pile
	$SymbolUI.texture = pile.get_node("SymbolUI").texture
	$PrinterWorkingAudioPlayer.play()
	$AnimationPlayer.play("Shake")
