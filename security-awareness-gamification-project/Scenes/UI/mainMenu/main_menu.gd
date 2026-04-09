extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hello")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# New Game Button
# New Game Button
func _new_game_pressed() -> void:
	print("Start Pressed")
	
	# --- RESET GLOBAL COUNTERS ---
	Global.total_emails_done = 0
	Global.receipt_data.clear()
	EmailManager.counter = 10 
	EmailManager.session = false
	# -----------------------------

	scoreManager.reset_score()
	scoreManager.reset_increment()
	
	print("Score is: ", scoreManager.score)
	print("Increment is: ", scoreManager.currentScoreIncrement)
	
	EmailManager.reset_incorrect_email_Array()
	
	# Link to load the desktop
	get_tree().change_scene_to_file("res://Scenes/UI/desktop/desktopUI.tscn")#new game

# Continue Game Button
func _on_continue_pressed() -> void:
	print("Continue Pressed")
	#link to load saved file and new scene

# Options Button 
func _on_options_pressed() -> void:
	print("options Pressed") #implement options scene

# Exit Button
func _on_exit_pressed() -> void:
	print("Exit Pressed")
	get_tree().quit() #terminate game
	
