extends Resource #Node usually lives in a scene, but a Resource is in charge of just holding pure data.
class_name EmailData

@export var safe_email: bool = true #[cite: 63, 66] #@export means to tell Godot to make this variable visible in Inspector panel on the right-side of the editor.
#We use it because this will help us instead of writing out the emails in code, we can just click on Resource file, and fill in the text boxes inside the Godot Editor.
@export var email_difficulty = 1 #[cite: 66] #The cite: 66 notation means that this is a reference system thatis used to show exactly what part f the uploaded diagram and report we used in creating the answer.
@export var subject: String = "" #[cite:66]
@export var sender_fullname: String = "" #[cite: 66]
@export var sender_email_address: String = "" #[cite:66]
@export var body_text: String = "" #[cite:70]

#List of attributes that are incorrect or are suspicious: [cite: 63, 125]
@export var email_faults: Array[String] = []
