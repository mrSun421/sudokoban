extends Node

const tile_size = 32
var current_level = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_level(level: int):
	current_level = level
	
func get_level() -> int:
	return current_level
