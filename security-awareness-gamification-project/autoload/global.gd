extends Node

var tooltip_manager: TooltipManager

func _ready() -> void:
	print("🌍 Global autoload initializing...")
	tooltip_manager = TooltipManager.new()
	add_child(tooltip_manager)
	print("✅ TooltipManager created")
