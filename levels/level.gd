extends Node2D

# TODO: Take this level node and turn it into a class 

const tile_size = GameVariables.tile_size
const level_size: Vector2i = Vector2i(12, 10)
const initial_box_positions: Array[Vector2i] = [Vector2i(2, 2), Vector2i(8, 7)]
const final_box_positions: Array[Vector2i] = [Vector2i(10, 7), Vector2i(10, 5)]

const inputs = {"move_right": Vector2i.RIGHT,
			"move_left": Vector2i.LEFT,
			"move_up": Vector2i.UP,
			"move_down": Vector2i.DOWN}


@onready var background_tilemaplayer := $Background as TileMapLayer
@onready var hud = $HUD as CanvasLayer

@onready var player := $Player as Node2D
const initial_player_position: Vector2i = Vector2i(1, 1)
var player_position: Vector2i = initial_player_position

var win_state: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.visible = false
	# Background Tiles
	for i in range(level_size.x):
		for j in range(level_size.y):
			background_tilemaplayer.set_cell(Vector2i(i, j), 0, Vector2i(1, 0))
	
	for box_ending_location in final_box_positions:
		background_tilemaplayer.set_cell(box_ending_location, 0, Vector2i(0, 0))

	
	# Player Initialization
	player.position = (initial_player_position * tile_size).snapped(Vector2i.ONE * tile_size)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if check_win():
		win_state = true
	hud.visible = win_state
		

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset_level"):
		reset_level()
		return
	
	var current_direction = Vector2i.ZERO
	for direction in inputs.keys():
		if Input.is_action_just_pressed(direction):
			current_direction = inputs[direction]

	var future_player_position = player_position + current_direction
	
	player_position = future_player_position
	player.position = (player_position * tile_size).snapped(Vector2i.ONE * tile_size)

func check_win() -> bool:
	return true

func reset_level():
	win_state = false

	# Player Initialization
	player_position = initial_player_position
	player.position = (initial_player_position * tile_size).snapped(Vector2i.ONE * tile_size)

	return
