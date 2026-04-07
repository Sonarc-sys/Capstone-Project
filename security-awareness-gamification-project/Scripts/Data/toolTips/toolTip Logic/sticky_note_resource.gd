extends Resource
class_name StickyNoteResource

# Day info
@export var day_number: int = 1
@export var title: String = "Security Tips"

# Main content
@export_multiline var advice: String = ""
@export_multiline var reference_information: String = ""
@export_multiline var company_information: String = ""
@export_multiline var sender_information: String = ""
@export_multiline var it_department_info: String = ""

# Lists
@export var sender_list: Array[String] = []
@export var blacklist: Array[String] = []
@export var executive_list: Array[String] = []
@export var red_flags: Array[String] = []
@export var safe_practices: Array[String] = []

# Optional logo paths
@export var logo_list: Array[String] = []
