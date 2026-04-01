extends Control

class_name DesktopUI

@onready var email_butt: Button = $Taskbar/EmailButton
@onready var tooltip_panel: TooltipPanelUI = $TootltipPanelUI
@onready var email_inboxUI: Control = $EmailInboxUI
@onready var Help_Icon: Button = $DesktopIcons/HelpIcon

func _ready() -> void:
	#We will hide the email inbox by default, and will only show the desktop.
	email_inboxUI.hide()
	tooltip_panel.hide()
	
	#We will Connect the email button to open the inbox.
	email_butt.pressed.connect(_email_button_pressed)
	
	#The Initial tooltip panel update for Day 1.
	if tooltip_panel:
		tooltip_panel.update_tooltips()


func _email_button_pressed() -> void:
	#Switch views: Hide all desktop icons, and show email interface.
	email_inboxUI.show()
	print("Desktop: Now opening the Email Client, Welcome:")


func _help_icon_ispressed() -> void:
	if tooltip_panel.visible:
		tooltip_panel.hide_tooltip()
	else:
		tooltip_panel.show()# Show the base advice/any red flags.
