extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("go_back"):
		get_tree().change_scene_to_file("res://menu/menu.tscn")

func _on_button_pressed() -> void:
	GameVariables.set_level(1)
	get_tree().change_scene_to_file("res://levels/level.tscn")

func _on_button_2_pressed() -> void:
	GameVariables.set_level(2)
	get_tree().change_scene_to_file("res://levels/level.tscn") # Replace with function body.
