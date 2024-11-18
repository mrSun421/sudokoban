@tool
extends Resource
class_name LevelInitializationData
## Resource to hold all of the data for level initialization.

enum LevelDifficulty {
    EASY,
    MEDIUM,
    HARD
    }

@export var level_size: Vector2i:
	get:
		return level_size
	set(size):
		level_size = size.clamp(Vector2i(1, 1), Vector2i(100, 100))
		changed.emit()

@export var initial_box_data: Array[BoxData]
@export var square_data: Array[SquareData]
@export var wall_positions: Array[Vector2i]
@export var initial_player_position: Vector2i


@export var level_difficulty: LevelDifficulty
