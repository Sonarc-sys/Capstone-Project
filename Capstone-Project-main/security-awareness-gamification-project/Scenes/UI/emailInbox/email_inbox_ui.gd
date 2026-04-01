extends Control
class_name EmailInboxUI

# Add these variables
@export var tooltip_panel_scene: PackedScene
var tooltip_manager: TooltipManager
var current_tooltip_panel: TooltipPanelUI  # Changed to match class_name

# UI References
@export var subject_label: Label
@export var sender_label: Label
@export var body_text: RichTextLabel
@export var forward_button: Button
@export var trash_button: Button
@export var email_counter: Label

# Game variables
var current_email: Email = null
var game_manager = null
var email_count: int = 0
var total_emails: int = 10

func _ready() -> void:
	# Find game manager
	if has_node("/root/GameManager"):
		game_manager = get_node("/root/GameManager")
	
	# Setup tooltips
	setup_tooltips()
	
	# Connect buttons if they exist
	if forward_button:
		forward_button.pressed.connect(_on_forward_pressed)
	if trash_button:
		trash_button.pressed.connect(_on_trash_pressed)

func setup_tooltips() -> void:
	# Get tooltip manager from autoload
	if has_node("/root/Global"):
		tooltip_manager = get_node("/root/Global").tooltip_manager
	
	# Instantiate tooltip panel if provided
	if tooltip_panel_scene and not current_tooltip_panel:
		current_tooltip_panel = tooltip_panel_scene.instantiate()
		add_child(current_tooltip_panel)
		
		# Connect hover signals for email elements
		if subject_label:
			subject_label.mouse_entered.connect(_on_subject_hover)
			subject_label.mouse_exited.connect(_on_tooltip_exit)
		if sender_label:
			sender_label.mouse_entered.connect(_on_sender_hover)
			sender_label.mouse_exited.connect(_on_tooltip_exit)
		if body_text:
			body_text.mouse_entered.connect(_on_body_hover)
			body_text.mouse_exited.connect(_on_tooltip_exit)

func load_next_email() -> void:
	if email_count >= total_emails:
		if game_manager:
			game_manager.end_day()
		return
	
	if game_manager and email_count < game_manager.current_emails.size():
		current_email = game_manager.current_emails[email_count]
		display_email(current_email)
		update_counter()

func display_email(email: Email) -> void:
	if not email:
		return
		
	if subject_label:
		subject_label.text = "Subject: " + email.subject
	if sender_label:
		sender_label.text = "From: " + email.sender
	if body_text:
		body_text.text = email.body_text
	
	# Show contextual warnings for this email
	if current_tooltip_panel and email:
		var email_dict = email.get_email()
		current_tooltip_panel.show_contextual_tooltips(email_dict)

func update_counter() -> void:
	if email_counter:
		email_counter.text = "Email %d of %d" % [email_count + 1, total_emails]

func _on_forward_pressed() -> void:
	if game_manager and current_email:
		var correct = game_manager.process_email_decision(current_email, true)
		show_feedback(correct)
		email_count += 1
		load_next_email()

func _on_trash_pressed() -> void:
	if game_manager and current_email:
		var correct = game_manager.process_email_decision(current_email, false)
		show_feedback(correct)
		email_count += 1
		load_next_email()

func show_feedback(correct: bool) -> void:
	var feedback = Label.new()
	feedback.text = "Correct!" if correct else "Incorrect!"
	feedback.add_theme_color_override("font_color", Color.GREEN if correct else Color.RED)
	add_child(feedback)
	await get_tree().create_timer(1.0).timeout
	feedback.queue_free()

func _on_subject_hover() -> void:
	if current_tooltip_panel and current_email and tooltip_manager:
		var tips = ""
		tips += "📧 SUBJECT: " + current_email.subject + "\n\n"
		tips += "💡 TIP: " + tooltip_manager.get_advice()
		current_tooltip_panel.show_tooltip(tips)

func _on_sender_hover() -> void:
	if current_tooltip_panel and current_email and tooltip_manager:
		var tips = ""
		tips += "👤 FROM: " + current_email.sender + "\n\n"
		tips += "🔍 VERIFICATION TIP:\n" + tooltip_manager.get_sender_info()
		
		# Check if sender is blacklisted
		var sender_lower = current_email.sender.to_lower()
		for blacklisted in tooltip_manager.get_blacklist():
			if sender_lower.find(blacklisted) != -1:
				tips += "\n\n⚠️ WARNING: This sender is on our blacklist!"
		
		current_tooltip_panel.show_tooltip(tips)

func _on_body_hover() -> void:
	if current_tooltip_panel and current_email and tooltip_manager:
		var tips = ""
		tips += "📄 EMAIL CONTENT\n\n"
		tips += "🔎 WHAT TO CHECK:\n"
		tips += "• Look for urgent language demanding immediate action\n"
		tips += "• Check for requests for personal information\n"
		tips += "• Verify any links by hovering over them\n"
		tips += "• Watch for poor grammar or spelling\n\n"
		tips += tooltip_manager.get_reference_info()
		current_tooltip_panel.show_tooltip(tips)

func _on_tooltip_exit() -> void:
	if current_tooltip_panel:
		current_tooltip_panel.hide_tooltip()
