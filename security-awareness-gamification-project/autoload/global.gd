extends Node

var tooltip_manager: TooltipManager

func _ready() -> void:
	tooltip_manager = TooltipManager.new()
	add_child(tooltip_manager)
	print("✅ Global autoload initialized with TooltipManager")
