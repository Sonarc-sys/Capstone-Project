extends Resource
class_name Email

@export var safe_email: bool = true
@export var email_difficulty: int = 1
@export var subject: String = ""
@export var fullname: String = ""
@export var full_email_address: String = ""
@export var receiver: String = ""
@export var sender: String = ""
@export var relevant_info: String = ""
@export var attachments: String = ""
@export var logo: String = ""
@export var body_text: String = ""
@export var list_of_email_faults: Array[String] = []

func get_email() -> Dictionary:
	return {
		"safe": safe_email,
		"difficulty": email_difficulty,
		"subject": subject,
		"sender": sender,
		"body_text": body_text,
		"faults": list_of_email_faults,
		"attachments": attachments
	}

func put_email(email_data: Dictionary) -> void:
	safe_email = email_data.get("safe", true)
	email_difficulty = email_data.get("difficulty", 1)
	subject = email_data.get("subject", "")
	sender = email_data.get("sender", "")
	body_text = email_data.get("body_text", "")
	list_of_email_faults = email_data.get("faults", [])

func get_list_of_email_faults() -> Array:
	return list_of_email_faults
