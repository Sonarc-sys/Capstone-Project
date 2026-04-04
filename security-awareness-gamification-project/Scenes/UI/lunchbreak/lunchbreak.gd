extends Control

# UI References
@onready var question_label: Label = $Label 
@onready var option1_butt: Button = $Button 
@onready var option2_butt: Button = $Button2 
@onready var scenario_display: TextureRect = $Background/TextureRect # Ensure TextureRect is inside Background!
@onready var consequence_panel: Panel = $ConsequencePanel
# Data Link
@export var scenario_generator = load("res://Scenes/UI/lunchbre/ScenarioList.tres")


func display_scenario(scenario: Resource):
	current_scen = scenario
	question_label.text = scenario.scenario_text

	if scenario.scenario_image:
		scenario_display.texture = scenario.scenario_image
	
	if scenario.thechoices.size() >= 2:
		option1_butt.text = scenario.thechoices[0]
		option2_butt.text = scenario.thechoices[1]


var current_scen: Resource

func _ready() -> void:
	# 1. Safety check for the UI
	if consequence_panel == null:
		print("Critical Error: Consequence Panel missing from Scene Tree!")
		return
	
	consequence_panel.hide()
	
	# 2. Safety check for the Data
	if scenario_generator:
		# Check if the resource has our function
		if scenario_generator.has_method("get_rand_lunchbreak"):
			var picked_scen = scenario_generator.get_rand_lunchbreak()
			if picked_scen:
				display_scenario(picked_scen)
			else:
				print("Sorry, the Array inside ScenarioList.tres is empty. Add your Day .tres files!")
		else:
			print("Error: The file in Scenario Generator is not the right script type.")
	else:
		print("Error: The Scenario Generator slot in the Inspector is empty!")

func _process_choice(index: int):
	if not current_scen: 
		return
	
	var is_right = (index == current_scen.correct_choiceindex)
	
	if not is_right:
		if has_node("/root/Global"):
			get_node("/root/Global").score_Manager.add_penalty(50)
	
	show_consequence(is_right)

# Show Feedback
func show_consequence(right: bool):
	consequence_panel.show()
	var result_text = "This is right, nice job! " if right else "Sorry, this is not right. "
	
	# Using get_node_or_null is safer in case the label is renamed
	var res_label = consequence_panel.get_node_or_null("ResultLabel")
	if res_label:
		res_label.text = result_text + current_scen.consequence_Text

# Signals from Inspector
func _on_button_pressed() -> void:
	_process_choice(0)

func _on_button_2_pressed() -> void:
	_process_choice(1)
