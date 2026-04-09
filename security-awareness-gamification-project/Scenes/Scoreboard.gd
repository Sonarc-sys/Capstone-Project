extends CanvasLayer

@onready var mistake_list = $ScrollContainer/VBoxContainer
@onready var total_label = $TotalLabel
@onready var statuslabel = $StatusLabel

func _ready():
	# Force the script to wait until the scene is fully stable
	await get_tree().process_frame 
	
	print("--- SCOREBOARD INITIALIZED ---")
	display_results()
	
	# Explicitly create the timer and wait for it
	print("Starting 10-second exit timer...")
	await get_tree().create_timer(10.0).timeout
	
	print("Timer finished! Returning to Desktop...")
	return_to_desktop()

func display_results():
	var total = 0
	
	# Clear the VBox so we don't double-up entries
	for child in mistake_list.get_children():
		child.queue_free()
	
	# Create rows for every entry in the Global array (Emails + Lunch)
	for entry in Global.receipt_data:
		var item_row = Button.new()
		item_row.text = entry["text"] + " | $" + str(entry["cash"])
		
		# Red for losses, Green for gains
		if entry["cash"] < 0:
			item_row.add_theme_color_override("font_color", Color.RED)
		else:
			item_row.add_theme_color_override("font_color", Color.GREEN)
			
		mistake_list.add_child(item_row)
		total += entry["cash"]
			
	total_label.text = "Final Score: $" + str(total)
	
	# Status check
	if total < 0:
		statuslabel.text = "STATUS: You're Fired"
		statuslabel.add_theme_color_override("font_color", Color.CRIMSON)
	else:
		statuslabel.text = "STATUS: Audit has been Passed!"
		statuslabel.add_theme_color_override("font_color", Color.LAWN_GREEN)

# This is the function the error was complaining about!
func return_to_desktop():
	print("Attempting to change scene to Desktop...")
	var path = "res://Scenes/UI/desktop/desktopUI.tscn"
	get_tree().change_scene_to_file(path)

		
func _on_retry_button_pressed():
	Global.reset_day() # Clear the mistakes from Global
	get_tree().change_scene_to_file("res://Scenes/UI/lunchbreak/lunchbreak.tscn")

func _on_row_clicked(explanation: String):
	# This prints the specific mistake text to the console when you click a red row
	print("Here is your mistake detail: " + explanation)
