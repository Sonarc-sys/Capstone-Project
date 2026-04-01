extends Control
# Remove 'class_name LunchBreakUI' if it's still here

@onready var question_label: Label = $Background/Label # Matches Screenshot 801
@onready var option1_butt: Button = $Background/Button # Matches Screenshot 801
@onready var option2_butt: Button = $Background/Button2 # Matches Screenshot 801
@onready var consequence_panel: Panel = $ConsequencePanel

var current_scen: LunchBreakScenario

func display_scenario(scenario: LunchBreakScenario):
	current_scen = scenario
	question_label.text = scenario.scenario_text
	option1_butt.text = scenario.thechoices[0]
	option2_butt.text = scenario.thechoices[1]
	consequence_panel.hide()

func _process_choice(index: int):
	# Safety check to make sure a scenario is loaded
	if not current_scen: return
	
	var is_right = (index == current_scen.correct_choiceindex)
	
	# Accessing your Global.gd score_Manager
	if not is_right:
		if has_node("/root/Global"):
			get_node("/root/Global").score_Manager.add_penalty(50)
	
	show_consequence(is_right)

func show_consequence(right: bool):
	consequence_panel.show()
	var result_text = "This is right, nice job! " if right else "Sorry, this is not right. "
	# Make sure you have a Label named ResultLabel inside your ConsequencePanel
	$ConsequencePanel/ResultLabel.text = result_text + current_scen.consequence_Text

# --- Signal Connections from Screenshots 802 & 803 ---

func _on_button_pressed() -> void:
	_process_choice(0) # "Yes" / Option 1

func _on_button_2_pressed() -> void:
	_process_choice(1) # "No" / Option 2
