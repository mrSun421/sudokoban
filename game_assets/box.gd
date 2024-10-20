extends Node2D
class_name Box

@export var grid_position_component: GridPositionComponent
@export var value_text: Label
@export var value: int = 0

func _process(delta: float):
	position = (grid_position_component.grid_position * GameVariables.tile_size).snapped(Vector2.ONE * GameVariables.tile_size)
	if value != null:
		value_text.text = str(value)