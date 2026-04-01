extends Node
class_name TooltipManager

# Day 1 tooltips database
var tooltips_db: Dictionary = {}

# Reference to the tooltip panel (will be set from UI)
var tooltip_panel: Control = null

func _ready() -> void:
	load_tooltips_database()

func load_tooltips_database() -> void:
	# Day 1 tooltips only
	tooltips_db = {
		1: _get_day_1_tooltips()
	}

func _get_day_1_tooltips() -> Dictionary:
	return {
		"advice": "Welcome to Email Security Training! Always verify sender information before forwarding emails.",
		"reference_information": "Legitimate company emails come from official domains like @company.com or @business.org",
		"company_information": "Our company policy: We never ask for passwords, personal info, or financial data via email.",
		"sender_information": "Check for misspelled sender names (e.g., amaz0n.com instead of amazon.com)",
		"sender_list": [
			"admin@cybersafe.com",
			"hr@cybersafe.com", 
			"itsecurity@cybersafe.com"
		],
		"logo_list": [
			"res://assets/logos/company_logo.png",
			"res://assets/logos/it_dept_logo.png"
		],
		"it_department_info": "IT Security will never ask for your password. Report suspicious emails to security@cybersafe.com",
		"blacklist": [
			"@scam-site.net",
			"@fake-paypal.com", 
			"@phishing-attempt.org"
		],
		"executive_list": [
			"sarah.johnson@cybersafe.com (CEO)",
			"mike.chen@cybersafe.com (CTO)"
		],
		"red_flags": [
			"Urgent or threatening language",
			"Requests for personal information",
			"Suspicious attachments",
			"Mismatched URLs",
			"Poor grammar or spelling"
		],
		"safe_practices": [
			"Hover over links before clicking",
			"Verify sender email address",
			"Check for official company branding",
			"When in doubt, ask IT department"
		]
	}

# Main method to get all tooltips for day 1
func get_tooltips() -> Dictionary:
	return tooltips_db[1]

# Individual getter methods
func get_advice() -> String:
	return tooltips_db[1].get("advice", "No advice available")

func get_reference_info() -> String:
	return tooltips_db[1].get("reference_information", "No reference info available")

func get_company_info() -> String:
	return tooltips_db[1].get("company_information", "No company info available")

func get_sender_info() -> String:
	return tooltips_db[1].get("sender_information", "No sender info available")

func get_sender_list() -> Array:
	return tooltips_db[1].get("sender_list", [])

func get_logo_list() -> Array:
	return tooltips_db[1].get("logo_list", [])

func get_it_dept_info() -> String:
	return tooltips_db[1].get("it_department_info", "Contact IT for suspicious emails")

func get_blacklist() -> Array:
	return tooltips_db[1].get("blacklist", [])

func get_executive_list() -> Array:
	return tooltips_db[1].get("executive_list", [])

func get_red_flags() -> Array:
	return tooltips_db[1].get("red_flags", [])

func get_safe_practices() -> Array:
	return tooltips_db[1].get("safe_practices", [])

# Contextual tooltips - shows relevant tips based on email content
func get_contextual_tooltips(email: Dictionary) -> Dictionary:
	var contextual = {}
	
	# Check for urgency indicators
	var subject = email.get("subject", "").to_lower()
	if subject.find("urgent") != -1 or subject.find("immediate") != -1 or subject.find("asap") != -1:
		contextual["urgency_warning"] = "⚠️ URGENT: Urgent requests are often phishing tactics! Take a moment to verify before acting."
	
	# Check for attachment
	if email.get("attachments", "") != "":
		contextual["attachment_warning"] = "⚠️ ATTACHMENT: Only open attachments if you're expecting this file. Malware can hide in attachments!"
	
	# Check for request of personal info
	var body = email.get("body_text", "").to_lower()
	if body.find("password") != -1 or body.find("verify") != -1 or body.find("confirm") != -1 or body.find("login") != -1:
		contextual["personal_info_warning"] = "⚠️ PERSONAL INFO: Never share passwords, login credentials, or personal information via email!"
	
	# Check for financial requests
	if body.find("payment") != -1 or body.find("transfer") != -1 or body.find("invoice") != -1 or body.find("gift card") != -1:
		contextual["financial_warning"] = "⚠️ FINANCIAL: Be extremely cautious with financial requests. Verify through a separate channel first!"
	
	# Check for sender domain against blacklist
	var sender = email.get("sender", "").to_lower()
	for blacklisted in get_blacklist():
		if sender.find(blacklisted) != -1:
			contextual["blacklist_warning"] = "🚨 BLACKLISTED: This sender domain is on our blacklist! This is a phishing attempt. DO NOT interact with this email."
	
	return contextual

# Display tooltip in UI
func show_tooltip(tooltip_text: String, position: Vector2 = Vector2.ZERO) -> void:
	if tooltip_panel:
		tooltip_panel.show_tooltip(tooltip_text, position)

func hide_tooltip() -> void:
	if tooltip_panel:
		tooltip_panel.hide_tooltip()

func set_tooltip_panel(panel: Control) -> void:
	tooltip_panel = panel
