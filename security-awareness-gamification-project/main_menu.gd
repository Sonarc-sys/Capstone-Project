extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Main Menu button menus
func _new_game_pressed() -> void:
	print("Start Pressed")
	# get_tree().change_scene_to_file() #link to load a cutscene for new game


func _on_continue_pressed() -> void:
	print("Continue Pressed") 
	#link to load saved file and new scene


func _on_options_pressed() -> void:
	print("options Pressed") #implement options scene


func _on_exit_pressed() -> void:
	print("Exit Pressed")
	get_tree().quit() #terminate game
	
