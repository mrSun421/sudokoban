extends Node2D
class_name Box

@export var grid_position_component: GridPositionComponent
@export var value: int = 0
@export var box_tile_map: TileMapLayer

func _process(delta: float):
	position = (grid_position_component.grid_position * GameVariables.tile_size).snapped(Vector2.ONE * GameVariables.tile_size)
	if value != null:
		box_tile_map.set_cell(Vector2i(0, 0), 0, Vector2i(value - 1, 0))