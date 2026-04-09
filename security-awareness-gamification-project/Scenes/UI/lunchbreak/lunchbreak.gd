extends Control

# UI References
@onready var question_label: Label = $Label 
@onready var option1_butt: Button = $Button 
@onready var option2_butt: Button = $Button2 
@onready var scenario_display: TextureRect = $Background/TextureRect # Ensure TextureRect is inside Background!
@onready var consequence_panel: Panel = $ConsequencePanel
# Data Link
@export var scenario_generator = load("res://Scenes/UI/lunchbre/ScenarioList.tres")
var rounds_count: int = 0

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
	randomize()
	consequence_panel.hide()
	
	if scenario_generator:
		# SHUFFLE ONCE at the very start of the game
		scenario_generator.days_array.shuffle()
		# Start with the first card (Index 0)
		display_scenario(scenario_generator.days_array[0])
			
			
			
			
func _process_choice(index: int):
	# 1. STOP if the panel is already visible (Double-click protection)
	if consequence_panel.visible:
		return
		
	if not current_scen: 
		return
	
	# 2. LOCK buttons immediately
	option1_butt.disabled = true
	option2_butt.disabled = true
	
	var is_right = (index == current_scen.correct_choiceindex)

	if is_right:
		Global.add_receipt_entry(100, "Secure Decision", false)
	else:
		Global.add_receipt_entry(-500, current_scen.scenario_text, true)
	
	rounds_count += 1
	show_consequence(is_right)

func show_consequence(right: bool):
	consequence_panel.show()
	var result_text = "CORRECT! " if right else "INCORRECT. "
	
	var res_label = consequence_panel.get_node_or_null("ResultLabel")
	if res_label:
		res_label.text = result_text + current_scen.consequence_Text
	
	# Wait for the player to read the result of the 5th scenario
	await get_tree().create_timer(2.0).timeout
	
	# Check if we finished the 5th round
	if rounds_count >= 5:
		print("Game Over! Switching to Scoreboard...")
		await get_tree().create_timer(0.5).timeout 
		get_tree().change_scene_to_file("res://Scenes/Scoreboard.tscn")
	else:
		get_next_scenario()
# Signals from Inspector
func _on_button_pressed() -> void:
	_process_choice(0)

func _on_button_2_pressed() -> void:
	_process_choice(1)



func get_next_scenario():
	consequence_panel.hide()
	
	if scenario_generator:
		var list = scenario_generator.days_array
		# Since rounds_count goes 1, 2, 3, 4... we use it to grab the NEXT card
		if rounds_count < list.size():
			var picked_scen = list[rounds_count]
			display_scenario(picked_scen)
			
			# IMPORTANT: Re-enable buttons so they can be clicked again
			option1_butt.disabled = false
			option2_butt.disabled = false
		else:
			# Safety transition to scoreboard if count gets too high
			get_tree().change_scene_to_file("res://Scenes/UI/Scoreboard.tscn")
