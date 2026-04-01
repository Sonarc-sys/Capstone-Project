extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# New Game Button
func _new_game_pressed() -> void:
	print("Start Pressed")
	get_tree().change_scene_to_file("res://Scenes/UI/desktop/desktopUI.tscn") #link to load a cutscene for new game

# Continue Game Button
func _on_continue_pressed() -> void:
	print("Continue Pressed")
	get_tree().change_scene_to_file("res://Scenes/UI/lunchbreak/lunchbreak.tscn") 
	#link to load saved file and new scene

# Options Button 
func _on_options_pressed() -> void:
	print("options Pressed") #implement options scene

# Exit Button
func _on_exit_pressed() -> void:
	print("Exit Pressed")
	get_tree().quit() #terminate game
	
