extends Node2D

# TODO: Take this level node and turn it into a class 

const tile_size = GameVariables.tile_size
const level_size: Vector2i = Vector2i(12, 10)
const initial_box_positions: Array[Vector2i] = [Vector2i(2, 2), Vector2i(8, 7)]
const final_box_positions: Array[Vector2i] = [Vector2i(10, 7), Vector2i(10, 5)]
var wall_positions: Array[Vector2i] = []

const inputs = {"move_right": Vector2i.RIGHT,
			"move_left": Vector2i.LEFT,
			"move_up": Vector2i.UP,
			"move_down": Vector2i.DOWN}


@onready var background_tilemaplayer := $Background as TileMapLayer
@onready var hud = $HUD as CanvasLayer

@onready var player := $Player as Node2D
const initial_player_position: Vector2i = Vector2i(1, 1)

var win_state: bool = false
var wall_scene = preload("res://game_assets/wall.tscn")
var box_scene = preload("res://game_assets/box.tscn")
var walls: Array[Node2D] = []
var boxes: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.visible = false
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

	for wall_position in wall_positions:
		var wall: Node2D = wall_scene.instantiate()
		wall.position = (wall_position * tile_size).snapped(Vector2i.ONE * tile_size)
		add_child(wall)
		walls.append(wall)

	# Boxes
	for box_position in initial_box_positions:
		var box: Node2D = box_scene.instantiate()
		box.position = (box_position * tile_size).snapped(Vector2i.ONE * tile_size)
		add_child(box)
		boxes.append(box)


	# Player
	player.position = (initial_player_position * tile_size).snapped(Vector2i.ONE * tile_size)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	win_state = check_win()
	hud.visible = win_state
		

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset_level"):
		reset_level()
		return
	
	var current_direction = Vector2i.ZERO
	for direction in inputs.keys():
		if Input.is_action_just_pressed(direction):
			current_direction = inputs[direction]

	var future_player_position_snapped = (player.position + Vector2(current_direction * tile_size)).snapped(Vector2i.ONE * tile_size)
	var wall_index = walls.map(func(e): return e.position.snapped(Vector2i.ONE * tile_size)).find(future_player_position_snapped)
	if wall_index >= 0:
		handle_wall_collision(current_direction)
		return
	var box_index = boxes.map(func(e): return e.position).find(future_player_position_snapped)
	if box_index >= 0:
		handle_box_collision(player, boxes[box_index], current_direction, future_player_position_snapped)
		return
	player.position = future_player_position_snapped

func check_win() -> bool:
	var current_box_positions = boxes.map(func(e): return Vector2i(e.position.snapped(Vector2i.ONE * tile_size)))
	var final_box_positions_snapped = final_box_positions.map(func(e): return (e * tile_size).snapped(Vector2i.ONE * tile_size))
	for final_box_position_snapped in final_box_positions_snapped:
			if !current_box_positions.has(final_box_position_snapped):
				return false
	return true

func reset_level():
	win_state = false
	for i in range(initial_box_positions.size()):
		var box = boxes[i]
		box.position = (initial_box_positions[i] * tile_size).snapped(Vector2i.ONE * tile_size)

	
	# Player Initialization
	player.position = (initial_player_position * tile_size).snapped(Vector2i.ONE * tile_size)
	return

func handle_wall_collision(current_direction):
	# TODO: Bump Animation?
	return

func handle_box_collision(pusher, box, current_direction, future_pusher_position_snapped):
	var future_box_position_snapped = (box.position + Vector2(current_direction * tile_size)).snapped(Vector2i.ONE * tile_size)
	var wall_index = walls.map(func(e): return e.position).find(future_box_position_snapped)
	if wall_index >= 0:
		handle_wall_collision(current_direction)
		return

	# TODO: Multipush?
	var box_index = boxes.map(func(e): return e.position).find(future_box_position_snapped)
	if box_index >= 0:
		# handle_box_collision(boxes[box_index], current_direction, future_box_position)
		return

	box.position = future_box_position_snapped
	pusher.position = future_pusher_position_snapped
	return