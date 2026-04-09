extends Control

@onready var email_list_panel = $"Hbox for EmaiList_Email Body/EmailList Panel"
var focused_email = null
var focused_email_index = -1

# Loads emails and places them in panel on scene load
func _ready() -> void:
	#Calls email generator to load emails
	EmailManager.load_emails(EmailManager.email_resource_folder, EmailManager.email_number)
	
	#populates left email panel
	email_list_panel.populate_email_list(EmailManager.selected_emails)
	
	#Listening for signals
	$"Hbox for EmaiList_Email Body/EmailList Panel".current_email.connect(on_email_selected)
		
	
#Button to bring back to desktop
func _on_button_pressed() -> void:
	pass 
	get_tree().change_scene_to_file("res://Scenes/UI/desktop/desktopUI.tscn")

#Used to update email index and store the email object -----------------------------------------------------------------------------------------
func on_email_selected(email: Email, index):
	focused_email = email
	focused_email_index = index
	
	print("The current email index is: ", focused_email_index)


	
#Buttons for trash and forwarding emails and scoring. ------------------------------------------------------------------------------------------
#Trash button if email is bad
func _on_trash_pressed() -> void:
	#resetter if you haven't chosen an email so it doesn't delete for no reason
	if focused_email == null or focused_email_index == -1:
		return
		
	#Scoring Logic
	if focused_email.safe_email == false:
		ScoreManager.add_score(ScoreManager.currentScoreIncrement)
	else:
		ScoreManager.minus_score(ScoreManager.currentScoreIncrement)
	
	
	#deletes focused email
	EmailManager.selected_emails.remove_at(focused_email_index) 
	
	#loop erases all current buttons
	for child in $"Hbox for EmaiList_Email Body/EmailList Panel/ScrollContainer/Vbox Email List".get_children():
		child.queue_free()
		
	#Repopulates the email list with the new array
	email_list_panel.populate_email_list(EmailManager.selected_emails)
	
	#Clear right side screen
	$"Hbox for EmaiList_Email Body/Vbox Right side Email/Email Content Panel".clear_email()
	#Reset Variables
	focused_email = -1
	focused_email_index = -1
	
	#Check to Scene Change to Lunchbreak
	EmailManager.update_counter()
	if EmailManager.counter == 5:
		get_tree().change_scene_to_file("res://Scenes/UI/mainMenu/main_menu.tscn")
	print("The current email array size is: ", EmailManager.counter)
	
		
	
	 

#Forward Button if email is good
func _on_forward_pressed() -> void:
	
	#resetter if you haven't chosen an email so it doesn't delete for no reason
	if focused_email == null or focused_email_index == -1:
		return
	
	#Scoring Logic
		#Scoring Logic
	if focused_email.safe_email == true:
		ScoreManager.add_score(ScoreManager.currentScoreIncrement)
	else:
		ScoreManager.minus_score(ScoreManager.currentScoreIncrement)
		
	#deletes focused email
	EmailManager.selected_emails.remove_at(focused_email_index) 
	
	#loop erases all current buttons
	for child in $"Hbox for EmaiList_Email Body/EmailList Panel/ScrollContainer/Vbox Email List".get_children():
		child.queue_free()
		
	#Repopulates the email list with the new array
	email_list_panel.populate_email_list(EmailManager.selected_emails)
	
	#Clear right side screen
	$"Hbox for EmaiList_Email Body/Vbox Right side Email/Email Content Panel".clear_email()

	#Reset Variables
	focused_email = -1
	focused_email_index = -1
	
	#Check to Scene Change to Lunchbreak
	EmailManager.update_counter()
	if EmailManager.counter == 5:
		get_tree().change_scene_to_file("res://Scenes/UI/mainMenu/main_menu.tscn")
	print("The current email array size is: ", EmailManager.counter)
	
	
