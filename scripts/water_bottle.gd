extends InteractableArea

func _on_interact():
	$AudioStreamPlayer.play()