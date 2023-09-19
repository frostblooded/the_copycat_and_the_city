extends Node2D
class_name GameManager

var wanted_easier_orders: int = 0

func _process(_delta):
	var time_left_label: Label = get_tree().root.find_node("TimeLeftLabel", true, false) as Label
	time_left_label.text = "Time left: {time}".format({"time": $EndGameTimer.time_left as int})


func end_game():
	var end_game_screen: Control = get_tree().root.find_node("EndGameScreen", true, false)
	end_game_screen.visible = true
	end_game_screen.get_node("NextLevelButton").next_level_scene = get_tree().root.find_node("MandatoryLevelNodes", true, false).next_level_scene
	var score: int = get_tree().root.find_node("ScoreManager", true, false).score
	end_game_screen.get_node("ScoreLabel").text = "Score: {score}".format({"score": score})
	$EndGameAudioPlayer.play()
	Utils.get_player(get_tree()).queue_free()


func _on_EndGameTimer_timeout():
	end_game()
