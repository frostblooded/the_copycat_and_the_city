extends Sprite

func _on_pile_completed():
	visible = true

func _on_pile_taken():
	visible = false