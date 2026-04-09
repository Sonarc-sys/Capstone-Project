extends Panel
class_name StickyTooltipPanel

var tooltip_manager: TooltipManager
var current_day: int = 1
var current_section: int = 0
var is_visible_state: bool = false

var section_names = ["RED FLAGS", "SAFE PRACTICES", "REFERENCE", "BLACKLIST"]

# UI elements
var title_label: Label
var section_title: Label
var scroll: ScrollContainer
var content_label: Label
var close_button: Button
var prev_button: Button
var next_button: Button
var section_indicator: Label

func _ready() -> void:
	setup_ui()
	hide()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	if has_node("/root/Global"):
		tooltip_manager = get_node("/root/Global").tooltip_manager
		if tooltip_manager:
			update_content()

func setup_ui() -> void:
	size = Vector2(500, 600)
	
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
	title_label.size = Vector2(450, 40)
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", Color.BLACK)
	title_label.text = "📌 SECURITY TIPS"
	add_child(title_label)
	
	# Navigation bar
	var nav_bar = HBoxContainer.new()
	nav_bar.position = Vector2(25, 65)
	nav_bar.size = Vector2(450, 35)
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
	section_indicator.size = Vector2(250, 35)
	section_indicator.add_theme_font_size_override("font_size", 14)
	section_indicator.add_theme_color_override("font_color", Color.BLACK)
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
	
	# Section title
	section_title = Label.new()
	section_title.position = Vector2(25, 108)
	section_title.size = Vector2(450, 30)
	section_title.add_theme_font_size_override("font_size", 18)
	section_title.add_theme_color_override("font_color", Color.BLACK)
	section_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(section_title)
	
	# Decorative line
	var line = ColorRect.new()
	line.position = Vector2(25, 143)
	line.size = Vector2(450, 2)
	line.color = Color(0.85, 0.75, 0.5)
	add_child(line)
	
	# Scroll container
	scroll = ScrollContainer.new()
	scroll.position = Vector2(15, 153)
	scroll.size = Vector2(470, 380)
	scroll.add_theme_stylebox_override("bg", StyleBoxEmpty.new())
	add_child(scroll)
	
	# Content label - simple setup
	content_label = Label.new()
	content_label.position = Vector2(10, 10)
	content_label.size = Vector2(440, 400)
	content_label.add_theme_font_size_override("font_size", 14)
	content_label.add_theme_color_override("font_color", Color.BLACK)
	content_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	content_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	scroll.add_child(content_label)
	
	# Close button
	close_button = Button.new()
	close_button.text = "Got it! ✨"
	close_button.position = Vector2(190, 545)
	close_button.size = Vector2(120, 38)
	
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
	close_button.add_theme_color_override("font_color", Color.BLACK)
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
		content_label.text = "No tips found"
		return
	
	var text = ""
	
	match current_section:
		0:  # Red Flags
			text = "RED FLAGS:\n\n"
			for i in range(tips.red_flags.size()):
				text += "• " + tips.red_flags[i] + "\n"
		
		1:  # Safe Practices
			text = "SAFE PRACTICES:\n\n"
			for i in range(tips.safe_practices.size()):
				text += "• " + tips.safe_practices[i] + "\n"
		
		2:  # Reference
			text = "REFERENCE:\n\n"
			text += "Company Policy: " + tips.company_information + "\n\n"
			text += "Sender Verification: " + tips.sender_information + "\n\n"
			text += "IT Department: " + tips.it_department_info + "\n\n"
			
			if tips.sender_list.size() > 0:
				text += "Known Safe Senders:\n"
				for i in range(tips.sender_list.size()):
					text += "• " + tips.sender_list[i] + "\n"
		
		3:  # Blacklist
			text = "BLACKLISTED DOMAINS:\n\n"
			for i in range(tips.blacklist.size()):
				text += "• " + tips.blacklist[i] + "\n"
	
	content_label.text = text
	print("Content updated - section: ", current_section)

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
	var viewport_size = get_viewport().get_visible_rect().size
	match corner:
		"top_right":
			position = Vector2(viewport_size.x - size.x - margin, margin)
		"top_left":
			position = Vector2(margin, margin)
		"bottom_right":
			position = Vector2(viewport_size.x - size.x - margin, viewport_size.y - size.y - margin)
		"bottom_left":
			position = Vector2(margin, viewport_size.y - size.y - margin)
