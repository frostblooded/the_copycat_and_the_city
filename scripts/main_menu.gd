extends Node2D
class_name MainMenu

export var game_scene: PackedScene = null


func _on_QuitGameButton_pressed():
	get_tree().quit()

func _on_StartGameButton_pressed():
	get_tree().change_scene_to(game_scene)
