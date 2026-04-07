extends Panel
class_name TooltipPanelUI

@onready var advice_label: Label = $MarginContainer/VBoxContainer/AdviceLabel
@onready var red_flags_list: RichTextLabel = $MarginContainer/VBoxContainer/RedFlagsContainer/RedFlagsList
@onready var safe_practices_list: RichTextLabel = $MarginContainer/VBoxContainer/SafePracticesContainer/SafePracticesList
@onready var additional_info_button: Button = $MarginContainer/VBoxContainer/AdditionalInfoButton

var tooltip_manager: TooltipManager

func _ready() -> void:
	hide()
	additional_info_button.pressed.connect(_on_additional_info_pressed)
	
	if has_node("/root/Global"):
		tooltip_manager = get_node("/root/Global").tooltip_manager
		if tooltip_manager:
			tooltip_manager.set_tooltip_panel(self)
			update_tooltips()

func update_tooltips() -> void:
	if not tooltip_manager:
		return
		
	var tips = tooltip_manager.get_tooltips()
	
	advice_label.text = tips.advice if tips else "No advice available"
	
	var red_flags = tips.red_flags if tips else []
	var red_flags_text = ""
	for flag in red_flags:
		red_flags_text += "• " + flag + "\n"
	red_flags_list.text = red_flags_text if red_flags_text != "" else "• No red flags to display"
	
	var safe_practices = tips.safe_practices if tips else []
	var safe_practices_text = ""
	for practice in safe_practices:
		safe_practices_text += "• " + practice + "\n"
	safe_practices_list.text = safe_practices_text if safe_practices_text != "" else "• No safe practices to display"

func show_tooltip(tooltip_text: String, position: Vector2 = Vector2.ZERO) -> void:
	advice_label.text = tooltip_text
	if position != Vector2.ZERO:
		position = position + Vector2(10, 10)
		position.x = clamp(position.x, 0, get_viewport_rect().size.x - size.x)
		position.y = clamp(position.y, 0, get_viewport_rect().size.y - size.y)
		global_position = position
	show()

func show_contextual_tooltips(email: Dictionary) -> void:
	if not tooltip_manager:
		return
		
	var contextual = tooltip_manager.get_contextual_tooltips(email)
	if contextual.size() > 0:
		var warning_text = ""
		for key in contextual:
			warning_text += contextual[key] + "\n\n"
		show_tooltip(warning_text.strip_edges())

func hide_tooltip() -> void:
	hide()

func _on_additional_info_pressed() -> void:
	if not tooltip_manager:
		return
		
	var tips = tooltip_manager.get_tooltips()
	if not tips:
		return
		
	var full_text = ""
	
	full_text += "[b]REFERENCE INFORMATION:[/b]\n" + tips.reference_information + "\n\n"
	full_text += "[b]COMPANY POLICY:[/b]\n" + tips.company_information + "\n\n"
	full_text += "[b]SENDER VERIFICATION:[/b]\n" + tips.sender_information + "\n\n"
	
	var sender_list = tips.sender_list
	if sender_list.size() > 0:
		full_text += "[b]KNOWN SAFE SENDERS:[/b]\n"
		for sender in sender_list:
			full_text += "✓ " + sender + "\n"
		full_text += "\n"
	
	var blacklist = tips.blacklist
	if blacklist.size() > 0:
		full_text += "[b]BLACKLISTED DOMAINS:[/b]\n"
		for domain in blacklist:
			full_text += "✗ " + domain + "\n"
		full_text += "\n"
	
	var executives = tips.executive_list
	if executives.size() > 0:
		full_text += "[b]EXECUTIVE CONTACTS:[/b]\n"
		for exec in executives:
			full_text += "• " + exec + "\n"
		full_text += "\n"
	
	full_text += "[b]IT SECURITY CONTACT:[/b]\n" + tips.it_department_info
	
	var dialog = AcceptDialog.new()
	dialog.dialog_text = full_text
	dialog.title = "Security Tips - Day 1"
	dialog.size = Vector2(550, 450)
	add_child(dialog)
	dialog.popup_centered()
	dialog.confirmed.connect(_on_dialog_confirmed.bind(dialog))

func _on_dialog_confirmed(dialog: AcceptDialog) -> void:
	dialog.queue_free()
