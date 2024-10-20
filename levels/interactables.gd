extends Node

const tile_size = GameVariables.tile_size
@onready var player := $Player as Node2D
var wall_scene = preload("res://game_assets/wall.tscn")
var box_scene = preload("res://game_assets/box.tscn")

var walls: Array[Node2D] = []
var boxes: Array[Node2D] = []

const inputs = {"move_right": Vector2i.RIGHT,
			"move_left": Vector2i.LEFT,
			"move_up": Vector2i.UP,
			"move_down": Vector2i.DOWN}

	
func _input(event: InputEvent):
	var current_direction = Vector2i.ZERO
	for direction in inputs.keys():
		if Input.is_action_just_pressed(direction):
			current_direction = inputs[direction]

	var future_player_position_snapped = (player.position + Vector2(current_direction * tile_size)).snapped(Vector2i.ONE * tile_size)
	var wall_index = walls.map(func(e): return e.position.snapped(Vector2i.ONE * tile_size)).find(future_player_position_snapped)
	if wall_index >= 0:
		return
	var box_index = boxes.map(func(e): return e.position).find(future_player_position_snapped)
	if box_index >= 0:
		handle_collision(player, boxes[box_index], current_direction, future_player_position_snapped)
		return
	player.position = future_player_position_snapped

	
func initialize(initial_player_position, wall_positions, initial_box_positions):
	for wall_position in wall_positions:
		var wall: Node2D = wall_scene.instantiate()
		wall.position = (wall_position * tile_size).snapped(Vector2i.ONE * tile_size)
		add_child(wall)
		walls.append(wall)

	for box_position in initial_box_positions:
		var box: Node2D = box_scene.instantiate()
		box.position = (box_position * tile_size).snapped(Vector2i.ONE * tile_size)
		add_child(box)
		boxes.append(box)
	
	player.position = (initial_player_position * tile_size).snapped(Vector2i.ONE * tile_size)

func check_win(final_box_positions):
	var current_box_positions = boxes.map(func(e): return Vector2i(e.position.snapped(Vector2i.ONE * tile_size)))
	var final_box_positions_snapped = final_box_positions.map(func(e): return (e * tile_size).snapped(Vector2i.ONE * tile_size))
	for final_box_position_snapped in final_box_positions_snapped:
			if !current_box_positions.has(final_box_position_snapped):
				return false
	return true


func reset_level(initial_player_position, initial_box_positions):
	for i in range(initial_box_positions.size()):
		var box = boxes[i]
		box.position = (initial_box_positions[i] * tile_size).snapped(Vector2i.ONE * tile_size)
	
	player.position = (initial_player_position * tile_size).snapped(Vector2i.ONE * tile_size)


func handle_collision(pusher, pushee, current_direction, future_pusher_position_snapped):
	var future_pushee_position_snapped = (pushee.position + Vector2(current_direction * tile_size)).snapped(Vector2i.ONE * tile_size)

	var wall_index = walls.map(func(e): return e.position.snapped(Vector2i.ONE * tile_size)).find(future_pushee_position_snapped)
	if wall_index >= 0:
		return
	var box_index = boxes.map(func(e): return e.position).find(future_pushee_position_snapped)
	if box_index >= 0:
		return
	pushee.position = future_pushee_position_snapped
	pusher.position = future_pusher_position_snapped
