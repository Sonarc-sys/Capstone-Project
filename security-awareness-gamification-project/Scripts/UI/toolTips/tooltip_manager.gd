extends Node
class_name TooltipManager

# Dictionary to hold all day resources
var tooltips_db: Dictionary = {}

# Reference to the tooltip panel
var tooltip_panel: Control = null

func _ready() -> void:
	load_all_tooltips()

func load_all_tooltips() -> void:
	# Use YOUR actual file path
	var path = "res://Scripts/Data/toolTips/toolTip/day_1_toolTips.tres"
	
	if ResourceLoader.exists(path):
		print("✅ File exists at: ", path)
		var day1 = load(path)
		if day1:
			tooltips_db[1] = day1
			print("✅ Loaded Day 1 tooltips successfully!")
			print("   - Red flags count: ", day1.red_flags.size())
			print("   - Safe practices count: ", day1.safe_practices.size())
		else:
			print("❌ Failed to load resource from: ", path)
	else:
		print("❌ File does NOT exist at: ", path)
		print("   Make sure day_1_toolTips.tres exists in Scripts/Data/toolTips/toolTip/")

func get_tooltips(day: int = 1) -> StickyNoteResource:
	return tooltips_db.get(day)

func get_advice(day: int = 1) -> String:
	var tips = tooltips_db.get(day)
	return tips.advice if tips else "No advice available"

func get_red_flags(day: int = 1) -> Array:
	var tips = tooltips_db.get(day)
	return tips.red_flags if tips else []

func get_safe_practices(day: int = 1) -> Array:
	var tips = tooltips_db.get(day)
	return tips.safe_practices if tips else []

func get_blacklist(day: int = 1) -> Array:
	var tips = tooltips_db.get(day)
	return tips.blacklist if tips else []

func get_sender_list(day: int = 1) -> Array:
	var tips = tooltips_db.get(day)
	return tips.sender_list if tips else []

func get_reference_info(day: int = 1) -> String:
	var tips = tooltips_db.get(day)
	return tips.reference_information if tips else ""

func get_company_info(day: int = 1) -> String:
	var tips = tooltips_db.get(day)
	return tips.company_information if tips else ""

func get_sender_info(day: int = 1) -> String:
	var tips = tooltips_db.get(day)
	return tips.sender_information if tips else ""

func get_it_dept_info(day: int = 1) -> String:
	var tips = tooltips_db.get(day)
	return tips.it_department_info if tips else ""

func get_executive_list(day: int = 1) -> Array:
	var tips = tooltips_db.get(day)
	return tips.executive_list if tips else []

# Contextual tooltips
func get_contextual_tooltips(email: Dictionary) -> Dictionary:
	var contextual = {}
	
	var subject = email.get("subject", "").to_lower()
	if subject.find("urgent") != -1 or subject.find("immediate") != -1:
		contextual["urgency_warning"] = "⚠️ URGENT: Urgent requests are often phishing tactics! Take a moment to verify before acting."
	
	if email.get("attachments", "") != "":
		contextual["attachment_warning"] = "⚠️ ATTACHMENT: Only open attachments if you're expecting this file. Malware can hide in attachments!"
	
	var body = email.get("body_text", "").to_lower()
	if body.find("password") != -1 or body.find("verify") != -1 or body.find("confirm") != -1:
		contextual["personal_info_warning"] = "⚠️ PERSONAL INFO: Never share passwords, login credentials, or personal information via email!"
	
	var sender = email.get("sender", "").to_lower()
	for blacklisted in get_blacklist():
		if sender.find(blacklisted) != -1:
			contextual["blacklist_warning"] = "🚨 BLACKLISTED: This sender domain is on our blacklist! This is a phishing attempt."
	
	return contextual

func set_tooltip_panel(panel: Control) -> void:
	tooltip_panel = panel

func show_tooltip(tooltip_text: String, position: Vector2 = Vector2.ZERO) -> void:
	if tooltip_panel and tooltip_panel.has_method("show_tooltip"):
		tooltip_panel.show_tooltip(tooltip_text, position)

func hide_tooltip() -> void:
	if tooltip_panel and tooltip_panel.has_method("hide_tooltip"):
		tooltip_panel.hide_tooltip()
