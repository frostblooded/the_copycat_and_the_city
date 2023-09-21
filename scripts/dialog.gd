extends CanvasLayer

signal finished()

export(String, MULTILINE) var text
export var image: Texture = null
export var speed_per_letter: float = 0.1

onready var label: Label = find_node("Label", true, false)
onready var texture: TextureRect = find_node("TextureRect", true, false)

var finished = false

var passed_time: float = 0.0

func _ready():
	texture.texture = image

func show():
	visible = true
	finished = false
	passed_time = 0.0
	label.text = ""

func hide():
	visible = false

func _process(delta):
	if not visible:
		return
	# get time since spawned
	if not finished:
		passed_time += delta
		var partial_text = text.substr(0, int(passed_time / speed_per_letter))
		label.text = partial_text
		if partial_text == text:
			finished = true
			passed_time = 0.0


func _input(event):
	if not visible:
		return
	if event.is_action_pressed("interact"):
		if finished:
			emit_signal("finished")
			hide()
		else:
			finished = true
			label.text = text
