extends Control

@export var email_number = 10 #email amount can be changed accordingly
@export var email_resource_folder = "res://Scripts/Data/emailDatabase/Emails/Day1/" #must make dynamic after demo

@onready var email_list_panel = $"Hbox for EmaiList_Email Body/EmailList Panel"

var all_emails: Array[Email] = [] #array storing all emails from source
var selected_emails: Array[Email] = [] #10 selected emails stored here

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_all_emails() #loads all emails from the resource folder
	pick_random_emails() #will then pick 10 random ones
	email_list_panel.populate_email_list(selected_emails)

#Email functions to load and then pick random emails
func load_all_emails():
	all_emails.clear()
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

func pick_random_emails():
	selected_emails.clear()
	if all_emails.size() <= email_number:
		selected_emails = all_emails.duplicate()
		return
	var available_indices = all_emails.size()
	var indices = []
	for i in range(all_emails.size()):
		indices.append(i)
	indices.shuffle()  # Randomize indices
	for i in range(email_number):
			selected_emails.append(all_emails[indices[i]])
	
	


	
#Button to bring back to desktop
func _on_button_pressed() -> void:
	pass 
	get_tree().change_scene_to_file("res://Scenes/UI/desktop/desktopUI.tscn")
	

func _process(delta: float) -> void:
	pass
