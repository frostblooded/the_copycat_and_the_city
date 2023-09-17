class_name Utils

enum PileColor {Red, Green, Blue}

static func get_player(tree) -> Player:
	return get_global_node(tree, "Player") as Player

static func get_global_node(tree: SceneTree, name: String) -> Node:
	return tree.root.find_node(name, true, false)
