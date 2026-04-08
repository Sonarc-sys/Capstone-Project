extends Control

@onready var email_list_panel = $"Hbox for EmaiList_Email Body/EmailList Panel"
var focused_email = null
var focused_email_index = -1

# Loads emails and places them in panel on scene load
func _ready() -> void:
	#Calls email generator to load emails
	EmailGenerator.load_emails(EmailGenerator.email_resource_folder, EmailGenerator.email_number)
	
	#populates left email panel
	email_list_panel.populate_email_list(EmailGenerator.selected_emails)
	
	#Listening for signals
	$"Hbox for EmaiList_Email Body/EmailList Panel".current_email.connect(on_email_selected)
		
	
#Button to bring back to desktop
func _on_button_pressed() -> void:
	pass 
	get_tree().change_scene_to_file("res://Scenes/UI/desktop/desktopUI.tscn")

#Used to update email index maybe try using .find and storing the email itself
func on_email_selected(email: Email, index):
	focused_email = email
	focused_email_index = index
	
	print("The current email index is: ", focused_email_index)


	
#Buttons for trash and forwarding emails and scoring.
func _on_trash_pressed() -> void:
	#resetter if you haven't chosen an email so it doesn't delete for no reason
	if focused_email == null or focused_email_index == -1:
		return
	#deletes focused email
	EmailGenerator.selected_emails.remove_at(focused_email_index) 
	
	#loop erases all current buttons
	for child in $"Hbox for EmaiList_Email Body/EmailList Panel/ScrollContainer/Vbox Email List".get_children():
		child.queue_free()
		
	#Repopulates the email list with the new array
	email_list_panel.populate_email_list(EmailGenerator.selected_emails)
	
	#Clear right side screen
	$"Hbox for EmaiList_Email Body/Vbox Right side Email/Email Content Panel".clear_email()
	#Reset Variables
	focused_email = -1
	focused_email_index = -1
	
	 


func _on_forward_pressed() -> void:
	
	#resetter if you haven't chosen an email so it doesn't delete for no reason
	if focused_email == null or focused_email_index == -1:
		return
	
	#deletes focused email
	EmailGenerator.selected_emails.remove_at(focused_email_index) 
	
	#loop erases all current buttons
	for child in $"Hbox for EmaiList_Email Body/EmailList Panel/ScrollContainer/Vbox Email List".get_children():
		child.queue_free()
		
	#Repopulates the email list with the new array
	email_list_panel.populate_email_list(EmailGenerator.selected_emails)
	
	#Clear right side screen
	$"Hbox for EmaiList_Email Body/Vbox Right side Email/Email Content Panel".clear_email()

	#Reset Variables
	focused_email = -1
	focused_email_index = -1
	
	
