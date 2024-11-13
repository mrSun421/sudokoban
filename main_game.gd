extends Node

func _ready() -> void:
	for i in range(GameVariables.level_count):
		var data = load("res://level_resources/level%d.tres" % i)
		GameVariables.level_initialization_data.append(data)
