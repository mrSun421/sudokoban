extends Node2D
class_name Interactables
## The main script for all interacables in the game.
## This includes the player, boxes, and walls.

signal win_state

const tile_size = GameVariables.tile_size
@export var player: Player
var wall_scene = preload("res://game_assets/wall.tscn")
var box_scene = preload("res://game_assets/box.tscn")

var walls: Array[Wall] = []
var boxes: Array[Box] = []

const inputs = {"move_right": Vector2i.RIGHT,
			"move_left": Vector2i.LEFT,
			"move_up": Vector2i.UP,
			"move_down": Vector2i.DOWN}

var show_background_tiles: bool = false
	
func _process(_delta: float):
	if show_background_tiles:
		modulate.a = 0.3
	else:
		modulate.a = 1.0

func _input(_event: InputEvent):
	if get_parent().lock_input:
		return
	if Input.is_action_just_pressed("show_background_tiles"):
		show_background_tiles = !show_background_tiles

	var current_direction = Vector2i.ZERO
	for direction in inputs.keys():
		if Input.is_action_just_pressed(direction):
			current_direction = inputs[direction]
			break

	var future_player_position = player.grid_position_component.grid_position + current_direction
	var wall_index = walls.map(func(e): return e.grid_position_component.grid_position).find(future_player_position)
	if wall_index >= 0:
		return
	var box_index = boxes.map(func(e): return e.grid_position_component.grid_position).find(future_player_position)
	if box_index >= 0:
		handle_collision(player, boxes[box_index], current_direction, future_player_position)
		return

	player.grid_position_component.grid_position = future_player_position

	
## spawns the interactables. This is called on ready by the level.
func initialize(init_data: LevelInitializationData):
	for wall_position in init_data.wall_positions:
		var wall: Wall = wall_scene.instantiate()
		wall.grid_position_component.grid_position = wall_position
		add_child(wall)
		walls.append(wall)

	for boxdata in init_data.initial_box_data:
		var box: Box = box_scene.instantiate()
		box.grid_position_component.grid_position = boxdata.position
		box.value = boxdata.value
		add_child(box)
		boxes.append(box)
	
	player.grid_position_component.grid_position = init_data.initial_player_position

## This checks all the boxes for proper sudoku rules.
## In order, it checks for the squares, then the rows and columns.
func check_win(square_data: Array[SquareData]):
	var current_box_positions = boxes.map(func(e): return e.grid_position_component.grid_position)
	# unique square check
	for square_dt in square_data:
		var positions = square_dt.positions
		var box_values_on_square: Array[int] = []
		for pos in positions:
			var box_index = current_box_positions.find(pos)
			if box_index < 0:
				return false
			if box_values_on_square.has(boxes[box_index].value):
				return false
			else:
				box_values_on_square.append(boxes[box_index].value)
				

	# row and column check
	var square_positions_arrays = square_data.map(func(e): return e.positions)
	var square_positions = []
	for square_positions_arr in square_positions_arrays:
		square_positions.append_array(square_positions_arr)

	var solution_boxes_x = {}
	var solution_boxes_y = {}

	for square_position in square_positions:
			var box_index = current_box_positions.find(square_position)
			if box_index < 0:
				return false
			if solution_boxes_x.get(square_position.x) != null:
				solution_boxes_x[square_position.x].append(boxes[box_index])
			else:
				solution_boxes_x[square_position.x] = [boxes[box_index]]
			if solution_boxes_y.get(square_position.y) != null:
				solution_boxes_y[square_position.y].append(boxes[box_index])
			else:
				solution_boxes_y[square_position.y] = [boxes[box_index]]

	
	for x_index in solution_boxes_x:
		var column_values = solution_boxes_x[x_index].map(func(e): return e.value)
		var tracker = []
		for val in column_values:
			if tracker.has(val):
				return false
			tracker.append(val)

	for y_index in solution_boxes_y:
		var row_values = solution_boxes_y[y_index].map(func(e): return e.value)
		var tracker = []
		for val in row_values:
			if tracker.has(val):
				return false
			tracker.append(val)

	win_state.emit()


## This gets rid of all boxes and walls in the level, and then places all interactables back into the starting positions.
func reset_level(init_data: LevelInitializationData):
	for i in range(init_data.initial_box_data.size()):
		var boxdt = init_data.initial_box_data[i]
		if i + 1 > boxes.size():
			var box: Box = box_scene.instantiate()
			box.grid_position_component.grid_position = boxdt.position
			box.value = boxdt.value
			add_child(box)
			boxes.append(box)
		else:
			boxes[i].value = boxdt.value
			boxes[i].grid_position_component.grid_position = boxdt.position
	player.grid_position_component.grid_position = init_data.initial_player_position


## frees all interactables in the level.
func clear_level():
	for box in boxes:
		remove_child(box)
		box.queue_free()
	boxes = []
	for wall in walls:
		remove_child(wall)
		wall.queue_free()
	walls = []


## The logic for pushing/bumping into interactables.
func handle_collision(pusher, pushee, current_direction, future_pusher_position):
	var future_pushee_position = pushee.grid_position_component.grid_position + current_direction

	var wall_index = walls.map(func(e): return e.grid_position_component.grid_position).find(future_pushee_position)
	if wall_index >= 0:
		return
	var box_index = boxes.map(func(e): return e.grid_position_component.grid_position).find(future_pushee_position)
	if box_index >= 0:
		return

	pushee.grid_position_component.grid_position = future_pushee_position
	pusher.grid_position_component.grid_position = future_pusher_position
