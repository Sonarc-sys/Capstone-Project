extends Node

@export var number_of_emails: int = 20
@export var save_path: String = "res://Scripts/Data/emailDatabase/Emails/Day1/"
func _ready():
	generate_test_emails(number_of_emails)

func generate_test_emails(count: int):
	for i in range(count):
		var email = Email.new()
		
		 # Randomized properties
		email.safe_email = randi() % 2 == 0
		email.email_difficulty = 1 
		
		email.subject = "Test Email #" + str(i + 1)
		email.sender = "sender" + str(i + 1) + "@example.com"
		email.fullname = "Sender " + str(i + 1)
		email.full_email_address = "sender" + str(i + 1) + "@example.com"
		email.receiver = "player@example.com"
		email.relevant_info = "This is some relevant info for email #" + str(i + 1)
		email.body_text = "Hello, this is the body of test email #" + str(i + 1)
		#No logo or attachment
		#Saving Resource
		# var file_name = "email_test_" + str(i + 1) + ".tres"
		# ResourceSaver.save(email, save_path + file_name)
