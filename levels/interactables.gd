extends Node
class_name Interactables

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

	
func _input(event: InputEvent):
	var current_direction = Vector2i.ZERO
	for direction in inputs.keys():
		if Input.is_action_just_pressed(direction):
			current_direction = inputs[direction]

	var future_player_position = player.grid_position_component.grid_position + current_direction
	var wall_index = walls.map(func(e): return e.grid_position_component.grid_position).find(future_player_position)
	if wall_index >= 0:
		return
	var box_index = boxes.map(func(e): return e.grid_position_component.grid_position).find(future_player_position)
	if box_index >= 0:
		handle_collision(player, boxes[box_index], current_direction, future_player_position)
		return

	player.grid_position_component.grid_position = future_player_position

	
func initialize(initial_player_position, wall_positions, initial_box_positions, box_values):
	for wall_position in wall_positions:
		var wall: Wall = wall_scene.instantiate()
		wall.grid_position_component.grid_position = wall_position
		add_child(wall)
		walls.append(wall)

	for index in range(initial_box_positions.size()):
		var box: Box = box_scene.instantiate()
		box.grid_position_component.grid_position = initial_box_positions[index]
		box.value = box_values[index]
		add_child(box)
		boxes.append(box)
	
	player.grid_position_component.grid_position = initial_player_position

func check_win(final_box_positions):
	var current_box_positions = boxes.map(func(e): return e.grid_position_component.grid_position)
	var solution_boxes_x = {}
	var solution_boxes_y = {}

	for final_box_position in final_box_positions:
			var box_index = current_box_positions.find(final_box_position)
			if box_index < 0:
				return false
			if solution_boxes_x.get(final_box_position.x) != null:
				solution_boxes_x[final_box_position.x].append(boxes[box_index])
			else:
				solution_boxes_x[final_box_position.x] = [boxes[box_index]]
			if solution_boxes_y.get(final_box_position.y) != null:
				solution_boxes_y[final_box_position.y].append(boxes[box_index])
			else:
				solution_boxes_y[final_box_position.y] = [boxes[box_index]]

	
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


	return true


func reset_level(initial_player_position, initial_box_positions):
	for i in range(initial_box_positions.size()):
		var box = boxes[i]
		box.grid_position_component.grid_position = initial_box_positions[i]
	player.grid_position_component.grid_position = initial_player_position


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
