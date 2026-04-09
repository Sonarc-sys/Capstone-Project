extends Panel
class_name StickyTooltipPanel

var tooltip_manager: TooltipManager
var current_day: int = 1
var current_section: int = 0  # 0=Red Flags, 1=Safe Practices, 2=Reference, 3=Blacklist
var is_visible_state: bool = false

# Section names
var section_names = ["⚠️ Red Flags", "✅ Safe Practices", "📋 Reference", "🚫 Blacklist"]

# UI elements
var title_label: Label
var section_title: Label
var scroll: ScrollContainer
var content_label: RichTextLabel
var close_button: Button
var prev_button: Button
var next_button: Button
var section_indicator: Label

func _ready() -> void:
	setup_ui()
	hide()
	
	await get_tree().process_frame
	if has_node("/root/Global"):
		tooltip_manager = get_node("/root/Global").tooltip_manager
		if tooltip_manager:
			print("✅ Tooltip manager found!")
			update_content()

func setup_ui() -> void:
	# Panel size
	size = Vector2(400, 550)
	
	# Yellow sticky note style
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(1.0, 0.96, 0.8)
	panel_style.set_border_width_all(2)
	panel_style.border_color = Color(0.85, 0.75, 0.5)
	panel_style.set_corner_radius_all(15)
	panel_style.shadow_size = 15
	panel_style.shadow_offset = Vector2(4, 4)
	panel_style.shadow_color = Color(0, 0, 0, 0.25)
	add_theme_stylebox_override("panel", panel_style)
	
	# Title
	title_label = Label.new()
	title_label.position = Vector2(25, 20)
	title_label.size = Vector2(350, 40)
	title_label.add_theme_font_size_override("font_size", 22)
	title_label.add_theme_color_override("font_color", Color(0.5, 0.35, 0.1))
	title_label.text = "📌 Security Tips"
	add_child(title_label)
	
	# Section navigation bar
	var nav_bar = HBoxContainer.new()
	nav_bar.position = Vector2(25, 65)
	nav_bar.size = Vector2(350, 35)
	add_child(nav_bar)
	
	# Previous button
	prev_button = Button.new()
	prev_button.text = "◀"
	prev_button.size = Vector2(40, 35)
	prev_button.pressed.connect(_on_prev_pressed)
	
	var nav_style = StyleBoxFlat.new()
	nav_style.bg_color = Color(0.95, 0.85, 0.65)
	nav_style.set_corner_radius_all(8)
	nav_style.set_border_width_all(1)
	nav_style.border_color = Color(0.75, 0.65, 0.4)
	prev_button.add_theme_stylebox_override("normal", nav_style)
	
	# Section indicator
	section_indicator = Label.new()
	section_indicator.size = Vector2(180, 35)
	section_indicator.add_theme_font_size_override("font_size", 13)
	section_indicator.add_theme_color_override("font_color", Color(0.5, 0.35, 0.1))
	section_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Next button
	next_button = Button.new()
	next_button.text = "▶"
	next_button.size = Vector2(40, 35)
	next_button.pressed.connect(_on_next_pressed)
	next_button.add_theme_stylebox_override("normal", nav_style)
	
	nav_bar.add_child(prev_button)
	nav_bar.add_child(section_indicator)
	nav_bar.add_child(next_button)
	
	# Section title (current section name)
	section_title = Label.new()
	section_title.position = Vector2(25, 105)
	section_title.size = Vector2(350, 30)
	section_title.add_theme_font_size_override("font_size", 18)
	section_title.add_theme_color_override("font_color", Color(0.4, 0.3, 0.15))
	section_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(section_title)
	
	# Decorative line
	var line = ColorRect.new()
	line.position = Vector2(25, 140)
	line.size = Vector2(350, 2)
	line.color = Color(0.85, 0.75, 0.5)
	add_child(line)
	
	# Scroll container for content
	scroll = ScrollContainer.new()
	scroll.position = Vector2(15, 150)
	scroll.size = Vector2(370, 340)
	scroll.add_theme_stylebox_override("bg", StyleBoxEmpty.new())
	add_child(scroll)
	
	# Content label
	content_label = RichTextLabel.new()
	content_label.size = Vector2(350, 600)
	content_label.fit_content = true
	content_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	content_label.add_theme_font_size_override("normal_font_size", 14)
	content_label.add_theme_color_override("default_color", Color(0.3, 0.25, 0.15))
	scroll.add_child(content_label)
	
	# Close button
	close_button = Button.new()
	close_button.text = "Got it! ✨"
	close_button.position = Vector2(140, 500)
	close_button.size = Vector2(120, 35)
	
	var button_normal = StyleBoxFlat.new()
	button_normal.bg_color = Color(0.95, 0.85, 0.65)
	button_normal.set_corner_radius_all(20)
	button_normal.set_border_width_all(1)
	button_normal.border_color = Color(0.75, 0.65, 0.4)
	
	var button_hover = StyleBoxFlat.new()
	button_hover.bg_color = Color(0.98, 0.9, 0.75)
	button_hover.set_corner_radius_all(20)
	button_hover.set_border_width_all(1)
	button_hover.border_color = Color(0.75, 0.65, 0.4)
	
	close_button.add_theme_stylebox_override("normal", button_normal)
	close_button.add_theme_stylebox_override("hover", button_hover)
	close_button.add_theme_color_override("font_color", Color(0.4, 0.3, 0.1))
	close_button.add_theme_font_size_override("font_size", 14)
	
	close_button.pressed.connect(_on_close_pressed)
	add_child(close_button)
	
	update_nav_buttons()

func update_nav_buttons() -> void:
	if prev_button:
		prev_button.disabled = (current_section <= 0)
	if next_button:
		next_button.disabled = (current_section >= section_names.size() - 1)
	if section_indicator:
		section_indicator.text = str(current_section + 1) + " of " + str(section_names.size())
	if section_title:
		section_title.text = section_names[current_section]

func _on_prev_pressed() -> void:
	if current_section > 0:
		current_section -= 1
		update_content()
		update_nav_buttons()
		scroll.scroll_vertical = 0

func _on_next_pressed() -> void:
	if current_section < section_names.size() - 1:
		current_section += 1
		update_content()
		update_nav_buttons()
		scroll.scroll_vertical = 0

func update_content() -> void:
	if not tooltip_manager:
		return
	
	var tips = tooltip_manager.get_tooltips(current_day)
	if not tips:
		content_label.text = "[center]No tips found![/center]"
		return
	
	# Build content based on current section
	var content_text = ""
	
	match current_section:
		0:  # Red Flags
			content_text = "[center][b][color=#C62828]⚠️ WATCH FOR THESE RED FLAGS ⚠️[/color][/b][/center]\n\n"
			for flag in tips.red_flags:
				content_text += "• [color=#C62828]⚠️[/color] " + flag + "\n\n"
			if tips.red_flags.size() == 0:
				content_text += "[center]No red flags for this day.[/center]"
		
		1:  # Safe Practices
			content_text = "[center][b][color=#2E7D32]✅ SAFE PRACTICES TO FOLLOW ✅[/color][/b][/center]\n\n"
			for practice in tips.safe_practices:
				content_text += "• [color=#2E7D32]✅[/color] " + practice + "\n\n"
			if tips.safe_practices.size() == 0:
				content_text += "[center]No safe practices for this day.[/center]"
		
		2:  # Reference
			content_text = "[center][b][color=#1565C0]📚 REFERENCE INFORMATION 📚[/color][/b][/center]\n\n"
			content_text += "[b]🏢 Company Policy:[/b]\n" + tips.company_information + "\n\n"
			content_text += "[b]🔍 Sender Verification:[/b]\n" + tips.sender_information + "\n\n"
			content_text += "[b]💻 IT Department:[/b]\n" + tips.it_department_info + "\n\n"
			if tips.reference_information != "":
				content_text += "[b]📖 Additional Info:[/b]\n" + tips.reference_information + "\n\n"
			
			# Add safe senders
			if tips.sender_list.size() > 0:
				content_text += "[b]✓ Known Safe Senders:[/b]\n"
				for sender in tips.sender_list:
					content_text += "  • " + sender + "\n"
		
		3:  # Blacklist
			content_text = "[center][b][color=#6A1B9A]🚫 BLACKLISTED DOMAINS 🚫[/color][/b][/center]\n\n"
			if tips.blacklist.size() > 0:
				for domain in tips.blacklist:
					content_text += "• [color=#6A1B9A]🚫[/color] " + domain + "\n\n"
			else:
				content_text += "[center]No blacklisted domains for this day.[/center]"
	
	# Add footer
	content_text += "\n[center][color=#888888]━━━━━━━━━━━━━━━━━━━━━━━━━━━━[/color]\n"
	content_text += "[i]Stay vigilant! When in doubt, ask IT.[/i][/center]"
	
	content_label.text = content_text

func show_sticky_note(day: int = 1) -> void:
	current_day = day
	current_section = 0
	update_content()
	update_nav_buttons()
	show()
	is_visible_state = true
	scroll.scroll_vertical = 0

func hide_sticky_note() -> void:
	hide()
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
	var viewport_size = get_viewport_rect().size
	position = Vector2(viewport_size.x - size.x - margin, margin)
