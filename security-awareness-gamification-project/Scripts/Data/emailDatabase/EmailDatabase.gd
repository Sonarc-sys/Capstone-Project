extends Node
class_name EmailDatabase

# This array will hold all of the EmailData resources created in the Editor [cite: 11]
@export var all_emailpool: Array[EmailData] = []

# Creates a list of 10 emails based on the day's difficulty [cite: 8, 52]
func create_email_list(day: int) -> Array[EmailData]:
	var daily_list: Array[EmailData] = []
	var email_poolfortheday: Array[EmailData] = []
	
	# Filter the pool based on the difficulty level [cite: 8, 52]
	for email in all_emailpool: 
		if email.email_difficulty <= day:
			email_poolfortheday.append(email)
			
	# Ensure the pool is shuffled for randomness [cite: 52]
	email_poolfortheday.shuffle()
	
	# Select up to 10 emails for the level [cite: 27, 52]
	for i in range(min(10, email_poolfortheday.size())):
		daily_list.append(email_poolfortheday[i])
		
	return daily_list

# Returns a specific email from the database [cite: 60]
func get_email(index: int, current_list: Array[EmailData]) -> EmailData:
	if index >= 0 and index < current_list.size():
		return current_list[index]
	return null

# Allows for adding a new email to the database pool [cite: 61]
func _put_email(new_email: EmailData):
	all_emailpool.append(new_email)
