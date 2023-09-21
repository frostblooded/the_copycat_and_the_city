extends Node2D
class_name Pile

var is_copied: bool = false
var is_failed: bool = false
var desk: Node2D = null

func set_as_copied():
	is_copied = true

	if is_failed:
		return

	$CopiedUI.visible = true


func set_as_failed():
	is_failed = true
	$CopiedUI.visible = false
	$FailedUI.visible = true
