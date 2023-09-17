extends KinematicBody2D
class_name Player

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
	
	if velocity.x > 0:
		$AnimatedSprite.play("right")
	elif velocity.x < 0:
		$AnimatedSprite.play("left")
	elif velocity.y > 0:
		$AnimatedSprite.play("down")
	elif velocity.y < 0:
		$AnimatedSprite.play("up")
	else:
		$AnimatedSprite.play("idle")

	velocity = velocity.normalized() * speed


func _process(_delta):
	var overlapping_areas: Array = $Area2D.get_overlapping_areas()
	var is_overlapping_interactable_area: bool = false

	for area in overlapping_areas:
		if area is InteractableArea:
			is_overlapping_interactable_area = true
			break
	
	$InteractUI.set_visible(is_overlapping_interactable_area)


func _input(event):
	if event.is_action_pressed("interact"):
		var overlapping_areas: Array = $Area2D.get_overlapping_areas()

		for area in overlapping_areas:
			if area is InteractableArea:
				area._on_interact()
				break


func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)


func get_inventory() -> Inventory:
	return $Inventory as Inventory
