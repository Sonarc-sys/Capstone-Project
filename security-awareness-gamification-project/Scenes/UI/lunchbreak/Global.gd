extends Node

var receipt_data: Array = []

func add_receipt_entry(amount: int, description: String, is_mistake: bool):
	receipt_data.append({
		"cash": amount,
		"text": description,
		"mistake": is_mistake
	})
	print("Added to receipt: ", description, " | ", amount)

func reset_day():
	receipt_data.clear()
	
	
