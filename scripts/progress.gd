extends TextureProgress

var total_time = 0
var elapsed_time = 0

func _ready():
	visible = false

func start_progress(time):
	total_time = time
	elapsed_time = 0
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta
	if elapsed_time >= total_time:
		visible = false
		return

	value = (elapsed_time / total_time) * 100
