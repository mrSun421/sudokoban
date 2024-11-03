@tool
extends Resource
class_name BoxData

@export var position: Vector2i
@export var value: int

func equals(other: BoxData) -> bool:
    var pos_check: bool = position == other.position
    var val_check: bool = value == other.value
    return pos_check && val_check