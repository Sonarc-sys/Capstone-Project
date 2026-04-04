extends Control

# Tooltip additions (new variables)
var sticky_tooltip = null
var current_day = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Original code
	pass # Replace with function body.
	
	# Tooltip addition: Create sticky note
	var sticky_scene = load("res://Scenes/UI/desktop/sticky_tooltip_panel.tscn")
	if sticky_scene:
		sticky_tooltip = sticky_scene.instantiate()
		add_child(sticky_tooltip)
		sticky_tooltip.position_in_corner("top_right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Original button function (preserved)
func _on_button_pressed() -> void:
	pass 
	get_tree().change_scene_to_file("res://Scenes/UI/emailInbox/emailInbox.tscn")

# Tooltip addition: New function for tips button
func _on_tips_button_pressed() -> void:
	if sticky_tooltip:
		sticky_tooltip.toggle_sticky_note(current_day)
