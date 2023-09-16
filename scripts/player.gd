extends KinematicBody2D

export (int) var speed: int = 200

var velocity: Vector2 = Vector2()


func get_input():
	velocity = Vector2()

	if Input.is_action_pressed("walk_right"):
		velocity.x += 1
	if Input.is_action_pressed("walk_left"):
		velocity.x -= 1
	if Input.is_action_pressed("walk_down"):
		velocity.y += 1
	if Input.is_action_pressed("walk_up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed


func _input(event):
	if event.is_action_pressed("interact"):
		var overlapping_areas: Array = $Area2D.get_overlapping_areas()

		for area in overlapping_areas:
			if area is InteractableArea:
				area._on_interact()


func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
