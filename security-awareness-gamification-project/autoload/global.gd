extends Node

# --- 1. Tooltip Logic ---
# This fixes the "Invalid access to property 'tooltip_manager'" error
var tooltip_manager: TooltipManager 

# --- 2. Receipt/Scoring Logic ---
# This fixes the "Nonexistent function 'add_receipt_entry'" error
var receipt_data: Array = []


var total_emails_done: int = 0


func _ready() -> void:
	print("🌍 Global Master Autoload initializing...")
	
	# Initialize Tooltips
	tooltip_manager = TooltipManager.new()
	add_child(tooltip_manager)
	
	print("✅ Systems Online: Tooltips and Scoring ready.")

# The function used by Lunchbreak and EmailManager
func add_receipt_entry(cash: int, text: String, is_mistake: bool):
	var entry = {
		"text": text,
		"cash": cash,
		"mistake": is_mistake
	}
	receipt_data.append(entry)


func reset_day():
	receipt_data.clear()
	total_emails_done = 0 # Reset this so a new game starts at 0 emails
