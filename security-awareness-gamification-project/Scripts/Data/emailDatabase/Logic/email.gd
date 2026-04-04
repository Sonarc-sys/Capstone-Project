extends Resource
class_name Email

@export var safe_email: bool = true
@export var email_difficulty: int = 1

@export var subject: String = ""
@export var sender: String = ""
@export var fullname: String = ""
@export var full_email_address: String = ""

@export var receiver: String = ""

@export var relevant_info: String = ""
@export var attachments: Array[Attachment]
@export var logo: Texture2D
@export var body_text: String = ""

@export var list_of_email_faults: Array[String] = []

func get_list_of_email_faults() -> Array:
	return list_of_email_faults
