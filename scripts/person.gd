extends PathFollow2D

enum State { IDLE, WALK }
enum Idle { IDLE, PHONE }
enum Direction { LEFT, RIGHT, UP, DOWN, NONE }

export var phone_chance = 0.01
export var walk_chance = 0.01
export var walk_cooldown = 1
export var speed = 10
export(Array, SpriteFrames) var people

var state = State.IDLE

var current_idle = Idle.IDLE

var can_walk = true
var last_position = null
var direction = Direction.NONE
export var move_direction = -1

func _ready():
	#TODO: move this to the main script
	randomize()

	if not get_parent() is Path2D:
		can_walk = false

	$AnimatedSprite.play("Idle")
	$AnimatedSprite.frames = people[randi() % people.size()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == State.IDLE and current_idle == Idle.IDLE:
		if randf() < phone_chance:
			_play_phone_idle()
		
		if can_walk and randf() < walk_chance:
			_start_walking()
		
	
	if state == State.WALK:
		self.set_offset(self.get_offset() + speed * delta * move_direction)
		if _reached_destination():
			_stop_walking()
		else:
			_update_direction()
			last_position = global_position

func _get_destination_offset():
	var destination = 0
	if move_direction == 1:
		destination = self.get_parent().get_curve().get_baked_length()
	return destination


func _reached_destination():
	return abs(self.get_offset() - _get_destination_offset()) < 3

func _update_direction():
	var diff = global_position - last_position
	var new_direction = direction
	if abs(diff.x) > abs(diff.y):
		diff.y = 0
	elif abs(diff.x) < abs(diff.y):
		diff.x = 0

	if diff.x > 0:
		new_direction = Direction.RIGHT
	elif diff.x < 0:
		new_direction = Direction.LEFT
	elif diff.y > 0:
		new_direction = Direction.DOWN
	elif diff.y < 0:
			new_direction = Direction.UP
		
	if new_direction != direction:
		direction = new_direction
		if direction == Direction.RIGHT:
			$AnimatedSprite.play("Right")
		elif direction == Direction.LEFT:
			$AnimatedSprite.play("Left")
		elif direction == Direction.UP:
			$AnimatedSprite.play("Back")
		elif direction == Direction.DOWN:
			$AnimatedSprite.play("Front")
	

func _start_walking():
	state = State.WALK
	last_position = global_position
	direction = Direction.NONE
	move_direction *= -1

func _stop_walking():
	self.set_offset(_get_destination_offset())
	state = State.IDLE
	$AnimatedSprite.play("Idle")
	current_idle = Idle.IDLE
	can_walk = false
	# cooldown timer
	yield(get_tree().create_timer(walk_cooldown), "timeout")
	can_walk = true


func _play_phone_idle():
	current_idle = Idle.PHONE
	$AnimatedSprite.play("Phone")
	yield($AnimatedSprite, "animation_finished")
	if $AnimatedSprite.animation == "Phone":
		$AnimatedSprite.play("Phone", true)
		yield($AnimatedSprite, "animation_finished")
		if $AnimatedSprite.animation == "Phone":
			$AnimatedSprite.play("Idle")
			current_idle = Idle.IDLE
