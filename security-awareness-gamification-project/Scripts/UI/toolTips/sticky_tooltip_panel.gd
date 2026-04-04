extends Panel
class_name StickyTooltipPanel

# UI References - Make sure these match EXACTLY what's in your scene
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var tab_container: TabContainer = $MarginContainer/VBoxContainer/TabContainer
@onready var red_flags_list: RichTextLabel = $MarginContainer/VBoxContainer/TabContainer/RedFlagsList
@onready var safe_practices_list: RichTextLabel = $MarginContainer/VBoxContainer/TabContainer/SafePracticesList
@onready var reference_text: RichTextLabel = $MarginContainer/VBoxContainer/TabContainer/ReferenceText
@onready var blacklist_list: RichTextLabel = $MarginContainer/VBoxContainer/TabContainer/BlacklistList
@onready var day_label: Label = $MarginContainer/VBoxContainer/DayLabel
@onready var close_button: Button = $MarginContainer/VBoxContainer/CloseButton

# References
var tooltip_manager: TooltipManager
var current_day: int = 1
var is_visible_state: bool = false
var tween: Tween

func _ready() -> void:
	# Apply styling
	apply_sticky_style()
	
	# Connect close button
	close_button.pressed.connect(_on_close_pressed)
	
	# Hide initially
	hide()
	
	# Wait a frame then find tooltip manager
	await get_tree().process_frame
	
	# Find tooltip manager from autoload
	if has_node("/root/Global"):
		tooltip_manager = get_node("/root/Global").tooltip_manager
		print("✅ Tooltip manager found!")
		update_content()
	else:
		print("❌ Global not found! Make sure global.gd is set as autoload")

func apply_sticky_style() -> void:
	# Panel style
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(1.0, 0.96, 0.8)
	panel_style.set_border_width_all(2)
	panel_style.border_color = Color(0.8, 0.7, 0.4)
	panel_style.set_corner_radius_all(12)
	panel_style.shadow_size = 10
	panel_style.shadow_offset = Vector2(3, 3)
	panel_style.shadow_color = Color(0, 0, 0, 0.3)
	add_theme_stylebox_override("panel", panel_style)
	
	# Close button style
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color(0.95, 0.85, 0.65)
	button_style.border_color = Color(0.7, 0.6, 0.4)
	button_style.set_border_width_all(1)
	button_style.set_corner_radius_all(6)
	close_button.add_theme_stylebox_override("normal", button_style)
	
	var button_hover = StyleBoxFlat.new()
	button_hover.bg_color = Color(0.9, 0.8, 0.55)
	button_hover.border_color = Color(0.7, 0.6, 0.4)
	button_hover.set_border_width_all(1)
	button_hover.set_corner_radius_all(6)
	close_button.add_theme_stylebox_override("hover", button_hover)

func update_content(day: int = 1) -> void:
	current_day = day
	
	if not tooltip_manager:
		print("❌ No tooltip_manager found!")
		return
	
	print("Updating content for day ", day)  # Debug print
	
	var tips = tooltip_manager.get_tooltips()
	
	# Update day label
	day_label.text = "📅 Day " + str(current_day) + " Security Training"
	
	# Update Red Flags tab
	var red_flags = tips.get("red_flags", [])
	var red_text = ""
	for flag in red_flags:
		red_text += "⚠️ " + flag + "\n\n"
	red_flags_list.text = red_text if red_text != "" else "No red flags to display"
	print("Red flags added: ", red_flags.size())  # Debug print
	
	# Update Safe Practices tab
	var safe_practices = tips.get("safe_practices", [])
	var safe_text = ""
	for practice in safe_practices:
		safe_text += "✅ " + practice + "\n\n"
	safe_practices_list.text = safe_text if safe_text != "" else "No safe practices to display"
	print("Safe practices added: ", safe_practices.size())  # Debug print
	
	# Update Reference tab
	var ref_text = "[b]📚 REFERENCE INFORMATION[/b]\n" + tips.get("reference_information", "") + "\n\n"
	ref_text += "[b]🏢 COMPANY POLICY[/b]\n" + tips.get("company_information", "") + "\n\n"
	ref_text += "[b]🔍 SENDER VERIFICATION[/b]\n" + tips.get("sender_information", "") + "\n\n"
	ref_text += "[b]💻 IT DEPARTMENT[/b]\n" + tips.get("it_department_info", "")
	
	var sender_list = tips.get("sender_list", [])
	if sender_list.size() > 0:
		ref_text += "\n\n[b]✓ KNOWN SAFE SENDERS[/b]\n"
		for sender in sender_list:
			ref_text += "• " + sender + "\n"
	
	reference_text.text = ref_text
	
	# Update Blacklist tab
	var blacklist = tips.get("blacklist", [])
	var black_text = ""
	for domain in blacklist:
		black_text += "🚫 " + domain + "\n"
	blacklist_list.text = black_text if black_text != "" else "No blacklisted domains"
	
	print("✅ Content updated successfully!")

func show_sticky_note(day: int = 1) -> void:
	update_content(day)
	
	# Set size
	size = Vector2(380, 500)
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	
	scale = Vector2(0.5, 0.5)
	modulate.a = 0
	show()
	
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3)
	tween.parallel().tween_property(self, "modulate:a", 1, 0.3)
	
	is_visible_state = true

func hide_sticky_note() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.2)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.2)
	tween.tween_callback(hide)
	
	is_visible_state = false

func _on_close_pressed() -> void:
	hide_sticky_note()

func toggle_sticky_note(day: int = 1) -> void:
	if is_visible_state:
		hide_sticky_note()
	else:
		show_sticky_note(day)

func position_in_corner(corner: String = "top_right", margin: int = 20) -> void:
	await get_tree().process_frame
	size = Vector2(380, 500)
	var viewport_size = get_viewport_rect().size
	
	match corner:
		"top_left":
			position = Vector2(margin, margin)
		"top_right":
			position = Vector2(viewport_size.x - size.x - margin, margin)
		"bottom_left":
			position = Vector2(margin, viewport_size.y - size.y - margin)
		"bottom_right":
			position = Vector2(viewport_size.x - size.x - margin, viewport_size.y - size.y - margin)
