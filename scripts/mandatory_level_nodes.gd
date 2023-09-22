extends Node2D

export var next_level_scene: PackedScene = null
export var score_goal: int = 50
export var timer = 90.0
export(Array, SpriteFrames) var people

var current_people_sprite = 0

func _ready():
	randomize()
	people.shuffle()

func get_random_person_sprites():
	var sprites = people[current_people_sprite]
	current_people_sprite += 1
	if current_people_sprite >= people.size():
		current_people_sprite = 0
	return sprites

