extends Node2D
class_name GameManager

var wanted_easier_orders: int = 0
var successfully_completed_orders_in_a_row: int = 0
var wanted_harder_orders: int = 0
onready var mandatory_level_nodes: Node2D = Utils.get_global_node(get_tree(), "MandatoryLevelNodes")
onready var end_game_screen: Control = Utils.get_global_node(get_tree(), "EndGameScreen")
onready var score_manager: Node2D = Utils.get_global_node(get_tree(), "ScoreManager")

func _ready():
	$EndGameTimer.start(mandatory_level_nodes.timer)

func _process(_delta):
	var time_left_label: Label = get_tree().root.find_node("TimeLeftLabel", true, false) as Label
	time_left_label.text = "Time left: {time}".format({"time": $EndGameTimer.time_left as int})


func end_game():
	end_game_screen.visible = true
	end_game_screen.get_node("ScoreLabel").text = "Score: {score}".format({"score": score_manager.score})
	end_game_screen.get_node("ScoreGoalLabel").text = "Goal: {goal}".format({"goal": mandatory_level_nodes.score_goal})
	Utils.get_player(get_tree()).queue_free()

	if score_manager.score >= mandatory_level_nodes.score_goal:
		$CompleteLevelGameAudioPlayer.play()
		end_game_screen.get_node("NextLevelButton").visible = true
		end_game_screen.get_node("NextLevelButton").next_level_scene = mandatory_level_nodes.next_level_scene
		end_game_screen.get_node("CongratulatingLabel").add_color_override("font_color", Color.green)
		end_game_screen.get_node("CongratulatingLabel").text = "Good job!"
	else:
		$FailLevelStreamPlayer.play()
		end_game_screen.get_node("NextLevelButton").visible = false
		end_game_screen.get_node("NextLevelButton").next_level_scene = null
		end_game_screen.get_node("CongratulatingLabel").add_color_override("font_color", Color.black)
		end_game_screen.get_node("CongratulatingLabel").text = "Better luck next time..."


func _on_EndGameTimer_timeout():
	end_game()
