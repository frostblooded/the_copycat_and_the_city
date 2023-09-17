extends Node2D
class_name Pile

var is_copied: bool = false
var desk: Node2D = null

func set_as_copied():
    is_copied = true
    $CopiedUI.visible = true
