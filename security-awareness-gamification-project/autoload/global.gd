extends Node

# --- 1. Tooltip Logic ---
# This fixes the "Invalid access to property 'tooltip_manager'" error
var tooltip_manager: TooltipManager 

# --- 2. Receipt/Scoring Logic ---
# This fixes the "Nonexistent function 'add_receipt_entry'" error
var receipt_data: Array = []

func _ready() -> void:
	print("🌍 Global Master Autoload initializing...")
	
	# Initialize Tooltips
	tooltip_manager = TooltipManager.new()
	add_child(tooltip_manager)
	
	print("✅ Systems Online: Tooltips and Scoring ready.")

# The function used by Lunchbreak and EmailManager
func add_receipt_entry(cash: int, text: String, is_mistake: bool):
	var entry = {
		"cash": cash,
		"text": text,
		"mistake": is_mistake
	}
	receipt_data.append(entry)
	
	# Communicate with your scoreManager Autoload
	if has_node("/root/scoreManager"):
		var sm = get_node("/root/scoreManager")
		if cash > 0:
			sm.add_score(cash)
		else:
			sm.minus_score(abs(cash))
	else:
		print("Warning: scoreManager not found in Autoloads!")

func reset_day():
	receipt_data.clear()
	if has_node("/root/scoreManager"):
		get_node("/root/scoreManager").reset_score()
