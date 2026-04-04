extends PanelContainer

@onready var email_buttons_container = $"ScrollContainer/Vbox Email List"
var emails: Array[Email] = []
var selected_email: Email

func populate_email_list(email_array: Array[Email]):
	emails = email_array
	#email_buttons_container.clear_children()
	
	for i in range(emails.size()):
		var btn = TextureButton.new()
		btn.custom_minimum_size = Vector2(200, 50)
		
		
		#button textures
		#btn.texture_normal = preload("")
		#btn.texture_hover = preload("")
		#btn.texture_pressed = preload("")
		
		# Display the subject as text overlay
		var lbl = Label.new()
		lbl.text = emails[i].subject
		btn.add_child(lbl)
		
		btn.name = str(i)
		btn.connect("pressed", Callable(self, "_on_email_button_pressed").bind(i))
		
		email_buttons_container.add_child(btn)

func _on_email_button_pressed(index):
	selected_email = emails[index]
	get_node("/root/EmailUI/EmailViewer").display_email(selected_email)
