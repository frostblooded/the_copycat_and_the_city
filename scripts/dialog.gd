extends CanvasLayer

export(String, MULTILINE) var text
export var image: Texture = null
export var speed_per_letter: float = 0.1

onready var label: Label = find_node("Label", true, false)
onready var texture: TextureRect = find_node("TextureRect", true, false)

var passed_time: float = 0.0

func _ready():
	label.text = ""
	texture.texture = image

func _process(delta):
	# get time since spawned
	passed_time += delta
	var partial_text = text.substr(0, int(passed_time / speed_per_letter))
	label.text = partial_text
