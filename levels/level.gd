extends Node2D
## Script to handle loading and unloading of levels.

const tile_size = GameVariables.tile_size


@export var background_tilemaplayer: TileMapLayer
@export var win_sprite: Sprite2D
@export var interactables: Interactables
@export var camera: Camera2D
@export var init_data: LevelInitializationData

var lock_input: bool = false

func _ready() -> void:
	load_level()


func _process(_delta: float) -> void:
	check_win()

	
func _input(_event: InputEvent) -> void:
	if lock_input:
		return
	if Input.is_action_just_pressed("reset_level"):
		reset_level()
		return
	if Input.is_action_just_pressed("go_back"):
		get_tree().change_scene_to_file("res://menu/level_select.tscn")
		return

## This function is immediately called on ready.
func load_level():
	init_data = GameVariables.level_initialization_data[GameVariables.current_level]

	win_sprite.visible = false
	#win_sprite.offset = -(get_viewport().get_visible_rect().size - Vector2(init_data.level_size * tile_size).snapped(Vector2.ONE * tile_size)) / 2
	camera.offset = -(get_viewport().get_visible_rect().size - Vector2(init_data.level_size * tile_size).snapped(Vector2.ONE * tile_size)) / 2

	background_tilemaplayer.clear()
	for i in range(init_data.level_size.x):
		for j in range(init_data.level_size.y):
			background_tilemaplayer.set_cell(Vector2i(i, j), 0, Vector2i(1, 0))
	
	for square in init_data.square_data:
		for pos in square.positions:
			background_tilemaplayer.set_cell(pos, 1, Vector2i(square.id - 1, 0))
	interactables.clear_level()
	interactables.initialize(init_data)


func check_win():
	interactables.check_win(init_data.square_data)

## This resets the position of interactables in the level.
func reset_level():
	interactables.reset_level(init_data)
	return

## We lock the input, show a win screen, and then kick the player out back to level select.
func _on_interactables_win_state():
	lock_input = true
	win_sprite.visible = true
	await get_tree().create_timer(2.0).timeout
	lock_input = false

	get_tree().change_scene_to_file("res://menu/level_select.tscn")
