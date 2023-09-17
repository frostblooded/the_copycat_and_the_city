extends InteractableArea

func _on_interact():
	var player_inventory = Utils.get_player(get_tree()).get_inventory()
	var pile: Pile = player_inventory.get_top_item()
	if pile and pile.is_failed:
		$ShredderAudioPlayer.play()
		$AnimationPlayer.play("Shake")
		player_inventory.pop_item()
		pile.queue_free()
