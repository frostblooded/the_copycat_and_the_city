class_name Utils

enum PileColor {Red, Green, Blue}

static func get_player(tree) -> Player:
	return tree.root.find_node("Player", true, false)