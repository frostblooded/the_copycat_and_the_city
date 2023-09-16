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

func is_empty():
	return current_pile_color == -1

func _ready():
	if current_paper == -1:
		current_paper = max_paper
	timer.connect("timeout",self, "_on_timer_expire")
	add_child(timer)

func _on_interact():
	if is_empty():
		var player: Player = Utils.get_player(get_tree())
		var item = player.get_inventory().pop_item()
		var pile_color = 0
		var took_pile = take_pile(pile_color, 1)
		if took_pile:
			emit_signal("pile_added", pile_color)
		else:
			player.get_inventory().push_item(item)
			
	else:
		pass # TODO: return pile to player


func take_pile(pile_color, paper_count): 
	if current_paper < paper_count:
		return false

	current_paper -= paper_count
	current_pile_color = pile_color

	timer.wait_time = time_per_paper * paper_count
	timer.one_shot = true
	timer.start()
	return true

func _on_timer_expire():
	emit_signal("pile_completed", current_pile_color)
