extends CanvasLayer
@onready var mistake_list = $ScrollContainer/VBoxContainer
@onready var total_label = $TotalLabel
@onready var statuslabel = $StatusLabel

func _ready():
	display_results()
	
func display_results():
	print("--- DISPLAY RESULTS STARTED ---")
	var total = 0
	
	# 1. Check if the array is actually reaching the Scoreboard
	print("Items in Global.receipt_data: ", Global.receipt_data.size())
	
	# 2. First, clear the list entirely
	for child in mistake_list.get_children():
		child.queue_free()
		
	# 3. Check if it's empty
	if Global.receipt_data.size() == 0:
		print("ALERT: No data found in Global.receipt_data!")
		var empty_mssg = Label.new()
		empty_mssg.text = "Sorry, no new data has been recorded for today."
		mistake_list.add_child(empty_mssg)
		return
		
	# 4. Loop through the data
	for entry in Global.receipt_data:
		print("Drawing entry: ", entry["text"]) # Check if this prints
		var item_row = Button.new()
		item_row.text = entry["text"] + " | $" + str(entry["cash"])
		# ... (rest of your button logic)
		mistake_list.add_child(item_row)
		total += entry["cash"]
			
	# 5. Final update
	total_label.text = "Final Score: $" + str(total)
	print("Final Label Set to: ", total_label.text)
	
	
	
	# 1. First, clear the list entirely
	for child in mistake_list.get_children():
		child.queue_free()
		
	# 2. Check if it's empty AFTER clearing, and move OUT of the first loop
	if Global.receipt_data.size() == 0:
		var empty_mssg = Label.new()
		empty_mssg.text = "Sorry, no new data has been recorded for today."
		mistake_list.add_child(empty_mssg)
		return
		
	# 3. Now loop through the data to add the buttons
	for entry in Global.receipt_data:
		var item_row = Button.new()
		item_row.text = entry["text"] + " | $" + str(entry["cash"])
		item_row.alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
		
		if entry["cash"] < 0:
			item_row.add_theme_color_override("font_color", Color.RED)
		else:
			item_row.add_theme_color_override("font_color", Color.GREEN)
			
		if entry["mistake"]:
			item_row.pressed.connect(_on_row_clicked.bind(entry["text"]))
			
		mistake_list.add_child(item_row)
		total += entry["cash"]
			
	# 4. Update the labels at the very end
	total_label.text = "Final Score: $" + str(total)
	
	if total < 0:
		statuslabel.text = "STATUS: You're Fired"
		statuslabel.add_theme_color_override("font_color", Color.CRIMSON)
	else:
		statuslabel.text = "STATUS: Audit has been Passed!"
		statuslabel.add_theme_color_override("font_color", Color.LAWN_GREEN)
		
func _on_retry_button_pressed():
	Global.reset_day() # Clear the mistakes from Global
	get_tree().change_scene_to_file("res://Scenes/UI/lunchbre/lunchbreak.tscn")

func _on_row_clicked(explanation: String):
	# This prints the specific mistake text to the console when you click a red row
	print("Here is your mistake detail: " + explanation)
