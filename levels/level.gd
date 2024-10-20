extends Node2D

# TODO: Take this level node and turn it into a class 

const tile_size = GameVariables.tile_size
const level_size: Vector2i = Vector2i(12, 10)
const initial_box_positions: Array[Vector2i] = [Vector2i(2, 2), Vector2i(8, 7)]
const final_box_positions: Array[Vector2i] = [Vector2i(10, 7), Vector2i(10, 5)]
var wall_positions: Array[Vector2i] = []


@onready var background_tilemaplayer := $Background as TileMapLayer
@onready var hud = $HUD as CanvasLayer
@onready var interactables = $Interactables as Interactables
@onready var camera = $Camera2D as Camera2D

const initial_player_position: Vector2i = Vector2i(1, 1)

var win_state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.visible = false
	camera.offset = -(get_viewport().get_visible_rect().size - Vector2(level_size * tile_size).snapped(Vector2.ONE * tile_size)) / 2

	# Background Tiles
	for i in range(level_size.x):
		for j in range(level_size.y):
			background_tilemaplayer.set_cell(Vector2i(i, j), 0, Vector2i(1, 0))
	
	for box_ending_location in final_box_positions:
		background_tilemaplayer.set_cell(box_ending_location, 0, Vector2i(0, 0))

	# Walls
	for i in range(level_size.x):
		wall_positions.append(Vector2i(i, 0))
		wall_positions.append(Vector2i(i, level_size.y - 1))
	for i in range(level_size.y):
		wall_positions.append(Vector2i(0, i))
		wall_positions.append(Vector2i(level_size.x - 1, i))

	interactables.initialize(initial_player_position, wall_positions, initial_box_positions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	win_state = check_win()
	hud.visible = win_state
		

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset_level"):
		reset_level()
		return
	
func check_win() -> bool:
	return interactables.check_win(final_box_positions)

func reset_level():
	win_state = false
	interactables.reset_level(initial_player_position, initial_box_positions)
	return
