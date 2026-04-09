extends CanvasLayer

@onready var mistake_list = $ScrollContainer/VBoxContainer
@onready var total_label = $TotalLabel
@onready var statuslabel = $StatusLabel

var exit_timer: float = 0.0
var can_exit: bool = false

func _ready():
	print("--- SCOREBOARD INITIALIZED ---")
	display_results()
	
	# Reset the timer and enable it
	exit_timer = 0.0
	can_exit = true
	print("Timer starting in _process loop...")

func _process(delta: float):
	if can_exit:
		exit_timer += delta
		
		# Every 1 second, we'll print a heartbeat so you know it's not frozen
		if int(exit_timer) % 2 == 0 and int(exit_timer) > 0:
			print("Waiting... ", int(exit_timer), "/10")

		if exit_timer >= 10.0:
			can_exit = false # Stop the loop
			return_to_menu()

func return_to_menu():
	print("--- ATTEMPTING EXIT ---")
	# IMPORTANT: Change this path if your folder is lowercase 'mainmenu'
	var menu_path = "res://Scenes/UI/mainMenu/main_menu.tscn"
	
	if ResourceLoader.exists(menu_path):
		print("Nice job, Path confirmed! Loading Menu...")
		get_tree().change_scene_to_file(menu_path)
	else:
		printerr("Sorry, but there is an error here: Main Menu not found at: ", menu_path)

func display_results():
	var total = 0
	for child in mistake_list.get_children():
		child.queue_free()
	
	for entry in Global.receipt_data:
		var item_row = Button.new()
		item_row.text = entry["text"] + " | $" + str(entry["cash"])
		if entry["cash"] < 0:
			item_row.add_theme_color_override("font_color", Color.RED)
		else:
			item_row.add_theme_color_override("font_color", Color.GREEN)
		mistake_list.add_child(item_row)
		total += entry["cash"]
			
	total_label.text = "Final Score: $" + str(total)
	
	if total < 0:
		statuslabel.text = "STATUS: You're Fired"
		statuslabel.add_theme_color_override("font_color", Color.CRIMSON)
	else:
		statuslabel.text = "STATUS: Audit has been Passed!"
		statuslabel.add_theme_color_override("font_color", Color.LAWN_GREEN)

func _on_retry_button_pressed():
	Global.reset_day()
	get_tree().change_scene_to_file("res://Scenes/UI/lunchbreak/lunchbreak.tscn")
