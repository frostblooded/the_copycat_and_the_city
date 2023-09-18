extends Button

export var next_level_scene: PackedScene = null


func _on_StartLevelButton_pressed():
	if next_level_scene == null:
		return

	get_tree().change_scene_to(next_level_scene)
