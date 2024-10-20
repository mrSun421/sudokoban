extends Node2D
class_name Wall

@export var grid_position_component: GridPositionComponent

func _process(delta: float):
	position = (grid_position_component.grid_position * GameVariables.tile_size).snapped(Vector2.ONE * GameVariables.tile_size)