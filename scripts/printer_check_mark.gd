extends Sprite

func _on_pile_completed(pile_color):
	visible = true

func _on_pile_taken(pile_color):
	visible = false