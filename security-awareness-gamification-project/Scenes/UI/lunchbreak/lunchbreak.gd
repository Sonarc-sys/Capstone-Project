extends Control


@onready var question_label: Label = $Background/Label 
@onready var option1_butt: Button = $Background/Button 
@onready var option2_butt: Button = $Background/Button2 
@onready var consequence_panel: Panel = $ConsequencePanel

@export var scenario_generator: LunchBreakScenarioGenerator

var current_scen: LunchBreakScenario
func _ready() -> void:
	consequence_panel.hide() #Here, ensure that the consequence feedback is hidden until the completion of the lunch scenario.
	if scenario_generator:
		#Here, use the custom function to get a scenario from the list of possible scenarios.
		var random_scen = scenario_generator.get_rand_lunchbreak()
		if random_scen:
			display_scenario(random_scen)
	else:
		#Here, we have error handling, if I forgot to link the generator, this will prevent the game from randomly crashing with a blank or white screen.
		print("Sorry, but there is no Scenario Generator that is linked to the LunchBreakUI")

#Here, we will now populate the UI. We will take the data from Resource, and put it on the screen. 
func display_scenario(scenario: LunchBreakScenario):
	current_scen = scenario
	question_label.text = scenario.scenario_text
	option1_butt.text = scenario.thechoices[0]
	option2_butt.text = scenario.thechoices[1]
	
	
	#Here, we will check the player's choice against whether the correct answer or not.
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
