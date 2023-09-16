extends InteractableArea

signal pile_completed(pile_color)
signal pile_taken(pile_color)
signal pile_added(pile_color)

export var max_paper = 10
export var current_paper = -1
export var time_per_paper = 1.0

var current_pile_color = -1

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
		var item = player_inventory.pop_item()
		var pile_color = 0
		var took_pile = take_pile(item)
		if took_pile:
			emit_signal("pile_added", pile_color)
		else:
			player_inventory.push_item(item)
	else:
		if is_ready:
			var item = inventory.get_child(0)
			inventory.remove_child(item)
			if player_inventory.push_item(item):
				var pile_color = 0
				emit_signal("pile_taken", pile_color)
			else:
				inventory.add_child(item)


func take_pile(item): 
	# TODO: fix this
	var pile_color = 0
	var paper_count = 1

	if current_paper < paper_count:
		return false

	
	inventory.add_child(item)

	current_paper -= paper_count
	current_pile_color = pile_color

	timer.wait_time = time_per_paper * paper_count
	timer.one_shot = true
	timer.start()
	is_ready = false
	return true

func _on_timer_expire():
	is_ready = true
	emit_signal("pile_completed", current_pile_color)
