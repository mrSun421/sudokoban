extends Control


@export var tutorialLayer: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# print(get_tree())
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tutorialLayer.visible and Input.is_anything_pressed():
		tutorialLayer.visible = false
		
	
func _on_NewGame_pressed():
	pass
func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/level_select.tscn")
func _on_quit_pressed() -> void:
	get_tree().quit()
func _on_how_to_play_pressed() -> void:
	tutorialLayer.visible = !tutorialLayer.visible