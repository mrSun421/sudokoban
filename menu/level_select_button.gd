extends Button


@export var button_tilemap: TileMapLayer


func set_difficulty_sprite(difficulty: LevelInitializationData.LevelDifficulty) -> void:
	self.button_tilemap.set_cell(Vector2i(0, 0), 0, Vector2i(difficulty, 0))
	return