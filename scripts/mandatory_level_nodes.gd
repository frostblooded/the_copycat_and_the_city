extends Node2D

export var next_level_scene: PackedScene = null
export var score_goal: int = 50


func _ready():
    randomize()
