extends TextureProgress

var total_time = 0
var elapsed_time = 0
export var inverse = false
export var tint_from = Color(1, 1, 1, 1)
export var tint_to = Color(1, 1, 1, 1)

func _ready():
	visible = false

func start_progress(time):
	total_time = time
	elapsed_time = 0
	visible = true
	value = 100 if inverse else 0

func complete():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return

	elapsed_time += delta
	if elapsed_time >= total_time:
		visible = false
		return

	if inverse:
		value = 100 - ((elapsed_time / total_time) * 100)
		tint_progress = tint_from.linear_interpolate(tint_to, 1- (value / 100))
	else:
		value = (elapsed_time / total_time) * 100
		tint_progress = tint_from.linear_interpolate(tint_to, value / 100)
