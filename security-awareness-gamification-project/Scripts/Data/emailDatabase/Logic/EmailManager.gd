extends Node

@export var email_number = 10 #email amount can be changed accordingly
var email_database: EmailDatabase
var session = false
var all_emails: Array[Email] = [] #array storing all emails from source
var selected_emails: Array[Email] = [] 
var counter = 0 #size of emails array
var incorrect_emails: Array[Email] = [] #stores incorrect emails

#Email Loader
func load_emails(day: int, email_number: int):
	if session:
		return
	session = true
	#Loads all emails first
	var path = "res://Scripts/Data/emailDatabase/Emails/A_Email_Database/day" + str(day) + "_database.tres" 
	email_database = load(path)

	if email_database == null:
		push_error("Email database not found: " + path)
		return

	all_emails = email_database.emailList

#Selects emails
	selected_emails.clear()
	var indices = []
	for i in range(all_emails.size()):
		indices.append(i)

	indices.shuffle()

	var amount = min(email_number, all_emails.size())

	for i in range(amount):
		selected_emails.append(all_emails[indices[i]])

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
