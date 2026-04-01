extends Control


@onready var question_label: Label = $Background/Label 
@onready var option1_butt: Button = $Background/Button 
@onready var option2_butt: Button = $Background/Button2 
@onready var consequence_panel: Panel = $ConsequencePanel

var current_scen: LunchBreakScenario

func display_scenario(scenario: LunchBreakScenario):
	current_scen = scenario
	question_label.text = scenario.scenario_text
	option1_butt.text = scenario.thechoices[0]
	option2_butt.text = scenario.thechoices[1]
	consequence_panel.hide()

func _process_choice(index: int):
	
	if not current_scen: return
	
	var is_right = (index == current_scen.correct_choiceindex)
	
	if not is_right:
		if has_node("/root/Global"):
			get_node("/root/Global").score_Manager.add_penalty(50)
	
	show_consequence(is_right)

func show_consequence(right: bool):
	consequence_panel.show()
	var result_text = "This is right, nice job! " if right else "Sorry, this is not right."
	$ConsequencePanel/ResultLabel.text = result_text + current_scen.consequence_Text

func _on_button_pressed() -> void:
	_process_choice(0) # "Yes" / Option 1

func _on_button_2_pressed() -> void:
	_process_choice(1) # "No" / Option 2
