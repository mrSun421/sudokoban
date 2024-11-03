extends Node2D

# TODO: Take this level node and turn it into a class 

const tile_size = GameVariables.tile_size


@export var background_tilemaplayer: TileMapLayer
@export var hud: CanvasLayer
@export var interactables: Interactables
@export var camera: Camera2D
@export var init_data: LevelInitializationData

var win_state: bool = false

const level_resource_paths: Array[String] = [
	"res://level_resources/level0.tres",
	"res://level_resources/level1.tres",
	"res://level_resources/level2.tres",
]

var current_level = 0


func _ready() -> void:
	load_level()


func _process(_delta: float) -> void:
	win_state = check_win()
	hud.visible = win_state
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset_level"):
		reset_level()
		return
	if Input.is_action_just_pressed("change_level_up"):
		current_level = (current_level + 1) % level_resource_paths.size()
		load_level()
		return
	if Input.is_action_just_pressed("change_level_down"):
		current_level = (current_level - 1) % level_resource_paths.size()
		load_level()
		return

func load_level():
	var level_data_path = level_resource_paths[current_level]
	var level_init_data = load(level_data_path)
	init_data = level_init_data

	hud.visible = false
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


func check_win() -> bool:
	return interactables.check_win(init_data.square_data)

func reset_level():
	win_state = false
	interactables.reset_level(init_data)
	return
