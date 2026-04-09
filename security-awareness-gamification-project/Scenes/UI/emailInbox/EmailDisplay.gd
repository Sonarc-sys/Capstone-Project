extends PanelContainer

@onready var senderInfo = $"Vbox Email Container/From_sender_logo/Vbox SenderInfo/Sender Info"
@onready var subject = $"Vbox Email Container/Subject Label"
@onready var body = $"Vbox Email Container/Body"

func _ready() -> void:
	pass # Replace with function body.
<<<<<<< HEAD


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
=======
>>>>>>> e974fe08b720ed113bef927ae2002d7e7f5fc022
	
func display_email(email: Email) -> void:
		senderInfo.text = email.fullname + " <" + email.full_email_address + ">"
		subject.text = email.subject
		body.text = email.body_text
		
func clear_email() -> void:
	senderInfo.text = ""
	subject.text = ""
	body.text = ""		
