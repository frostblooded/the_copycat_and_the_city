extends Node2D


export var max_paper = 10
export var current_paper = -1
export var time_per_paper = 1.0

var current_pile_color = -1

func _ready():
	if current_paper == -1:
		current_paper = max_paper


func take_pile(pile_color, paper_count): 
	if current_paper < paper_count:
		return false

	current_paper -= paper_count
	current_pile_color = pile_color
