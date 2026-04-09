extends Control

var sticky_tooltip = null
var current_day = 1

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/emailInbox/emailInbox.tscn")

func _on_tips_button_pressed() -> void:
	if not sticky_tooltip:
		sticky_tooltip = StickyTooltipPanel.new()
		add_child(sticky_tooltip)
		sticky_tooltip.position_in_corner("top_right")
	
	sticky_tooltip.toggle_sticky_note(current_day)
