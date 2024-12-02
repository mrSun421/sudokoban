extends Node

const tile_size = 32
const level_count = 11
var level_initialization_data: Array[LevelInitializationData]
var current_level = -1

func _ready() -> void:
	for i in range(GameVariables.level_count):
		var data = load("res://level_resources/level%d.tres" % i)
		GameVariables.level_initialization_data.append(data)
	
func set_level(level: int):
	current_level = level
	
func get_level() -> int:
	return current_level
