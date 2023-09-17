extends InteractableArea

signal pile_completed()
signal pile_taken()
signal pile_added()

export var max_paper = 10
export var current_paper = -1
export var time_per_paper = 1.0

var timer = Timer.new()
var is_ready = false

onready var inventory = get_node("Inventory")

func is_empty():
	return inventory.get_child_count() == 0

func _ready():
	if current_paper == -1:
		current_paper = max_paper
	timer.connect("timeout",self, "_on_timer_expire")
	add_child(timer)

func _on_interact():
	var player_inventory = Utils.get_player(get_tree()).get_inventory()
	if is_empty():
		if not player_inventory.has_items():
			return

		var pile: Pile = player_inventory.pop_item()

		var took_pile = take_pile(pile)

		if took_pile:
			$SymbolUI.texture = pile.get_node("SymbolUI").texture
			emit_signal("pile_added")
			$PrinterWorkingAudioPlayer.play()
		else:
			player_inventory.push_item(pile)
	else:
		if is_ready:
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
	return true

func _on_timer_expire():
	is_ready = true
	$PrinterWorkingAudioPlayer.stop()
	emit_signal("pile_completed")
