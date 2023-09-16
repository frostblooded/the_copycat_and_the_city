extends InteractableArea

signal pile_completed(pile_color)

export var max_paper = 10
export var current_paper = -1
export var time_per_paper = 1.0

var current_pile_color = -1

var timer = Timer.new()

func _ready():
	if current_paper == -1:
		current_paper = max_paper
	timer.connect("timeout",self, "_on_timer_expire")
	add_child(timer)
	take_pile(0, 2)

func _on_interact():
	pass

func take_pile(pile_color, paper_count): 
	if current_paper < paper_count:
		return false

	current_paper -= paper_count
	current_pile_color = pile_color

	timer.wait_time = time_per_paper * paper_count
	timer.one_shot = true
	timer.start()

func _on_timer_expire():
	emit_signal("pile_completed", current_pile_color)


func _on_PrinterInteractableArea_pile_completed(pile_color):
	print("Pile completed")
	print(pile_color)
