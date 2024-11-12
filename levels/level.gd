extends Node2D

const tile_size = GameVariables.tile_size


@export var background_tilemaplayer: TileMapLayer
@export var hud: CanvasLayer
@export var interactables: Interactables
@export var camera: Camera2D
@export var init_data: LevelInitializationData

var lock_input: bool = false

const level_resource_paths: Array[String] = [
	"res://level_resources/level0.tres",
	"res://level_resources/level1.tres",
	"res://level_resources/level2.tres",
	"res://level_resources/level3.tres",
]

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

func load_level():
	var level_data_path = level_resource_paths[GameVariables.get_level()]
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


func check_win():
	interactables.check_win(init_data.square_data)

func reset_level():
	interactables.reset_level(init_data)
	return

func _on_interactables_win_state():
	lock_input = true
	hud.visible = true
	await get_tree().create_timer(2.0).timeout
	lock_input = false

	get_tree().change_scene_to_file("res://menu/level_select.tscn")
