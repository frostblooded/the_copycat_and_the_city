extends Node2D

enum State { IDLE, WALK }
enum Idle { IDLE, PHONE }
enum Direction { LEFT, RIGHT, UP, DOWN, NONE }

export var phone_chance = 0.01
export var walk_chance = 0.01
export var walk_cooldown = 1.0
export var speed = 10
export var path_follow_scene: PackedScene
export(NodePath) var path_node

var path_follow: PathFollow2D = null

var state = State.IDLE

var current_idle = Idle.IDLE

var can_walk = true
var last_position = null
var direction = Direction.NONE
export var move_direction = -1
onready var mandatory_level_nodes: Node2D = Utils.get_global_node(get_tree(), "MandatoryLevelNodes")

func _ready():
	var path = get_node(path_node)
	if path != null:
		can_walk = true
		path_follow = path_follow_scene.instance()
		path.add_child(path_follow)
		path_follow.get_node("RemoteTransform2D").remote_path = get_path()
		if move_direction == 1:
			path_follow.set_unit_offset(1)
	else:
		can_walk = false

	$AnimatedSprite.play("Idle")
	$AnimatedSprite.frames = mandatory_level_nodes.get_random_person_sprites()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == State.IDLE and current_idle == Idle.IDLE:
		if randf() < phone_chance:
			_play_phone_idle()
		
		if can_walk and randf() < walk_chance:
			_start_walking()
		
	
	if state == State.WALK:
		path_follow.set_offset(path_follow.get_offset() + speed * delta * move_direction)
		if _reached_destination():
			_stop_walking()
		else:
			_update_direction()
			last_position = global_position

func _get_destination_offset():
	var destination = 0
	if move_direction == 1:
		destination = path_follow.get_parent().get_curve().get_baked_length()
	return destination


func _reached_destination():
	return abs(path_follow.get_offset() - _get_destination_offset()) < 3

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
			$AnimatedSprite.speed_scale = 2
		elif direction == Direction.LEFT:
			$AnimatedSprite.play("Left")
			$AnimatedSprite.speed_scale = 2
		elif direction == Direction.UP:
			$AnimatedSprite.play("Back")
			$AnimatedSprite.speed_scale = 2
		elif direction == Direction.DOWN:
			$AnimatedSprite.play("Front")
			$AnimatedSprite.speed_scale = 2
	

func _start_walking():
	state = State.WALK
	last_position = global_position
	direction = Direction.NONE
	move_direction *= -1

func _stop_walking():
	path_follow.set_offset(_get_destination_offset())
	state = State.IDLE
	$AnimatedSprite.speed_scale = 1
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
