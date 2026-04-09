extends Node

# This array will store every choice made in both Emails and Social Scenarios
var receipt_data: Array = []

# This helper function is what Lunchbreak.gd is looking for
func add_receipt_entry(cash: int, text: String, is_mistake: bool):
	var entry = {
		"cash": cash,
		"text": text,
		"mistake": is_mistake
	}
	receipt_data.append(entry)
	
	# Send the money update to your Scoremanager
	if has_node("/root/Scoremanager"):
		var score_man = get_node("/root/Scoremanager")
		if cash > 0:
			score_man.add_score(cash)
		else:
			score_man.minus_score(abs(cash))
	else:
		print("Warning: Scoremanager not found in Autoloads!")

# Use this when starting a new game
func reset_day():
	receipt_data.clear()
	if has_node("/root/Scoremanager"):
		get_node("/root/Scoremanager").reset_score()
