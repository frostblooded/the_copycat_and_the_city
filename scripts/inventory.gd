extends Node2D
class_name Inventory


func add(item_scene: PackedScene):
	var item: Node2D = item_scene.instance()
	add_child(item)


func remove(item: Node2D):
	remove_child(item)
	item.queue_free()
