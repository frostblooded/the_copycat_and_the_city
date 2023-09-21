extends Node2D

var score: int = 0
onready var mandatory_level_nodes: Node2D = Utils.get_global_node(get_tree(), "MandatoryLevelNodes")

func _ready():
	update_score_label()


func add_score(value: int):
	score += value
	update_score_label()


func update_score_label():
	var score_label: Label = Utils.get_global_node(get_tree(), "HUD").get_node("ScoreLabel")
	var goal: int = mandatory_level_nodes.score_goal
	score_label.text = "Score: {score}/{goal}".format({"score": score, "goal": goal})
