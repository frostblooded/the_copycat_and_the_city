extends Control

func _on_MainMenuButton_pressed():
	get_tree().change_scene("scenes/MainMenu.tscn")


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()
