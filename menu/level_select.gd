extends Control

const level_scene = preload("res://levels/level.tscn")
@onready var viewport_size = get_viewport().get_visible_rect().size

func _ready() -> void:
	for i in range(GameVariables.level_count):
		var diff: LevelInitializationData.LevelDifficulty = GameVariables.level_initialization_data[i].level_difficulty
		var button = Button.new()
		button.size = Vector2i(64, 64)
		button.position = Vector2i(int(64 * i) % int(viewport_size.x), floor(64 * i / (viewport_size.x)) * 64)
		button.pressed.connect(self._on_button_pressed.bind(i))
		add_child(button)

	
func _on_button_pressed(level_val: int):
	GameVariables.set_level(level_val)
	get_tree().change_scene_to_packed(level_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("go_back"):
		get_tree().change_scene_to_file("res://menu/menu.tscn")
