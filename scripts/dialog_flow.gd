extends CanvasLayer

var dialogs = []
var index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogs = get_children()

	for dialog in dialogs:
		dialog.hide()

	if dialogs.size() > 0:
		get_tree().paused = true
		show_dialog()

func show_dialog():
	index += 1
	if index >= dialogs.size():
		get_tree().paused = false
		queue_free()
	else:
		dialogs[index].show()
		dialogs[index].connect("finished", self, "show_dialog")
