extends Node2D

var score: int = 0

func add_score(value: int):
	score += value
	var score_label: Label = Utils.get_global_node(get_tree(), "HUD").get_node("ScoreLabel")
	score_label.text = "Score: {score}".format({"score": score})
