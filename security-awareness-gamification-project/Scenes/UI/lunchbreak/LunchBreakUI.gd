extends Control

class_name LunchBreakUI

@onready var question_label: Label = $Background/QuestionLabel
@onready var option1_butt: Button = $Background/Option1
@onready var option2_butt: Button = $Background/Option2
@onready var consequence_panel: Panel = $ConsequencePanel

var current_scen: LunchBreakScenario

func display_scenario(scenario: LunchBreakScenario):
	current_scen = scenario
	question_label.text = scenario.scenario_text
	
	#Set the text for your 2 options from the resource array.
	option1_butt.text = scenario.thechoices[0]
	option2_butt.text = scenario.thechoices[1]
	
	consequence_panel.hide()


func _on_option_pressed(index: int):
	var is_right = (index == current_scen.correct_choiceindex)
	
	#Handle scoring and consequences.
	if not is_right:
		#Subtract money if the player is incorrect.
		if has_node("/root/Global"):
			get_node("/root/Global").score_manager.add_penalty(50)
		
	show_consequence(is_right)


func show_consequence(right: bool):
	consequence_panel.show()
	var result_text ="This is right, nice job!" if right else "Sorry, this is not right."
	$ConsequencePanel/ResultLabel.text = result_text + current_scen.consequence_Text
