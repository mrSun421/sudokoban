extends Node2D
class_name GridPositionComponent

signal grid_position_changed()
@export var grid_position: Vector2i:
    get:
        return grid_position
    set(val):
        grid_position = val
        grid_position_changed.emit()
