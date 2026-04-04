extends Control

@onready var email_list_panel = $"Hbox for EmaiList_Email Body/EmailList Panel"

var all_emails: Array[Email] = [] #array storing all emails from source
var selected_emails: Array[Email] = [] #10 selected emails stored here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Calls email generator to load emails
	EmailGenerator.load_emails(EmailGenerator.email_resource_folder, EmailGenerator.email_number)
	
	#populates left email panel
	email_list_panel.populate_email_list(EmailGenerator.selected_emails)
	
	
#Button to bring back to desktop
func _on_button_pressed() -> void:
	pass 
	get_tree().change_scene_to_file("res://Scenes/UI/desktop/desktopUI.tscn")
	

func _process(delta: float) -> void:
	pass
