extends Node2D

var total_time = 0
var elapsed_time = 0
var paused = false
export var inverse = false
export var tint_from = Color(1, 1, 1, 1)
export var tint_to = Color(1, 1, 1, 1)
export var shake_amount = 0
export var start_shake_after = 0.7

onready var tp = $TextureProgress

func _ready():
	visible = false

func start_progress(time):
	paused = false
	total_time = time
	elapsed_time = 0
	visible = true
	tp.value = 100 if inverse else 0

func pause():
	paused = true

func resume():
	paused = false

func complete():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible or paused:
		return

	elapsed_time += delta
	if elapsed_time >= total_time:
		visible = false
		return

	var lerp_value = 0
	if inverse:
		tp.value = 100 - ((elapsed_time / total_time) * 100)
		lerp_value = 1 - (tp.value / 100)
	else:
		tp.value = (elapsed_time / total_time) * 100
		lerp_value = tp.value / 100

	tp.tint_progress = tint_from.linear_interpolate(tint_to, lerp_value)
	if shake_amount > 0 and lerp_value > start_shake_after:
		# move based on global time sin
		var shake_lerp = (lerp_value - start_shake_after) / (1 - start_shake_after)
		var shakeX = randf() * shake_amount * shake_lerp
		var shakeY = randf() * shake_amount * shake_lerp
		tp.rect_position.x = shakeX
		tp.rect_position.y = shakeY
