extends PanelContainer

@onready var senderInfo = $"Vbox Email Container/From_sender_logo/Vbox SenderInfo/Sender Info"
@onready var subject = $"Vbox Email Container/Subject Label"
@onready var body = $"Vbox Email Container/Body"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func display_email(email: Email) -> void:
		senderInfo.text = email.fullname + " <" + email.full_email_address + ">"
		subject.text = email.subject
		body.text = email.body_text
		
		
