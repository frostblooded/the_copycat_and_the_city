extends Node2D
class_name Main

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
