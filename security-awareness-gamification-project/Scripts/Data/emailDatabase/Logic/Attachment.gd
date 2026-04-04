extends Resource
class_name Attachment

@export var file_name: String = ""
@export var file_type: String = ""   # shows after "." is extension

@export var is_malicious: bool = false

@export var description: String = "" # what shows on hover

@export var preview_text: String = "" # what shows when opened
