extends Node2D

const tile_size = GameVariables.tile_size
const inputs = {"game_right": Vector2.RIGHT,
            "game_left": Vector2.LEFT,
            "game_up": Vector2.UP,
            "game_down": Vector2.DOWN}
var is_moving: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if is_moving:
		return

	for direction in inputs.keys():
		if Input.is_action_just_pressed(direction):
			position += inputs[direction] * tile_size