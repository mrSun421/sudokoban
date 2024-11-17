extends Control

const level_scene = preload("res://levels/level.tscn")
@onready var viewport_size = get_viewport().get_visible_rect().size
const level_select_button_scene = preload("res://menu/level_select_button.tscn")
const horizontal_padding: int = 32
const vertical_padding: int = 32

func _ready() -> void:
	for i in range(GameVariables.level_count):
		var diff: LevelInitializationData.LevelDifficulty = GameVariables.level_initialization_data[i].level_difficulty
		var button = level_select_button_scene.instantiate()
		button.set_difficulty_sprite(diff)
		button.position = Vector2(horizontal_padding, vertical_padding) + Vector2(96 * i % int(viewport_size.x - horizontal_padding * 2), floor(96 * i / (viewport_size.x - horizontal_padding * 2)) * 96)
		button.pressed.connect(self._on_button_pressed.bind(i))
		add_child(button)

	
func _on_button_pressed(level_val: int):
	GameVariables.set_level(level_val)
	get_tree().change_scene_to_packed(level_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("go_back"):
		get_tree().change_scene_to_file("res://menu/menu.tscn")
