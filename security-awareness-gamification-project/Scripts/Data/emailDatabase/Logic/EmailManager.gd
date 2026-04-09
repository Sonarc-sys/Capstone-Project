extends Node

@export var email_number = 10 #email amount can be changed accordingly
@export var email_resource_folder = "res://Scripts/Data/emailDatabase/Emails/Day1/" #must make dynamic after demo

var all_emails: Array[Email] = [] #array storing all emails from source
var selected_emails: Array[Email] = [] 
var counter = 0 #size of emails array
var incorrect_emails: Array[Email] = [] #stores incorrect emails

#Email Loader
func load_emails(email_resource_folder, email_number):
	if all_emails.size() > 0:
		# Already loaded, skip
		return
	#Loads all emails first
	#all_emails.clear()
	var dir = DirAccess.open(email_resource_folder)
	if not dir:
		push_error("Folder not found")
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var path = email_resource_folder + file_name
			var email_res = load(path)
			if email_res is Email:
				all_emails.append(email_res)
		file_name = dir.get_next()
	dir.list_dir_end()
	print("loaded all emails")
#Selects emails
	selected_emails.clear()
	if all_emails.size() <= email_number:
		selected_emails = all_emails.duplicate()
		return
	var _available_indices = all_emails.size()
	var indices = []
	for i in range(all_emails.size()):
		indices.append(i)
	indices.shuffle()  # Randomize indices
	for i in range(email_number):
			selected_emails.append(all_emails[indices[i]])
	print("Picked emails")
	update_counter()

#Functions for counter
func update_counter():
	counter = selected_emails.size()
	
func reset_counter():
	counter = 0


func process_email_choice(is_phish_button_pressed: bool, current_email: Email):
	var user_was_correct = (is_phish_button_pressed == current_email.is_phishing)

	if user_was_correct:
		# This line talks to the Scoreboard!
		Global.add_receipt_entry(50, "Email Correctly Identified", false)
		print("✅ Correct email choice recorded in Global.")
	else:
		# This line talks to the Scoreboard!
		Global.add_receipt_entry(-100, "Phishing Link Clicked: " + current_email.sender_name, true)
		print("❌ Incorrect email choice recorded in Global.")
		add_incorrect_email(current_email)
	
	finish_email_round()
	
#Functions for incorrect email Array

func reset_incorrect_email_Array():
	incorrect_emails.clear()

func add_incorrect_email(Email):
	incorrect_emails.append(Email)
	print(incorrect_emails)


func finish_email_round():
	counter -= 1
	Global.total_emails_done += 1
	
	print("Emails left in batch: ", counter)
	print("Total emails done today: ", Global.total_emails_done)
	
	if Global.total_emails_done >= 20:
		# Day is over
		get_tree().change_scene_to_file("res://Scenes/Scoreboard.tscn")
	elif counter <= 0:
		# Batch of 5 is over, go to lunch
		counter = 5 # Reset for when we come back
		get_tree().change_scene_to_file("res://Scenes/UI/lunchbreak/lunchbreak.tscn")
	else:
		# Do nothing and stay in the scene for the next email
		pass
