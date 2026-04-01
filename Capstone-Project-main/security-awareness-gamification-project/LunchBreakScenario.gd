extends Resource
class_name LunchBreakScenario

@export var scenario_text: String = "" #The setup.
@export var thechoices: Array[String] = [] #The options the player can pick.
@export var correct_choiceindex: int = 0
@export var consequence_Text: String = "" #What happens when they pick the scenario.
@export var is_safeScenario: bool = true # Binary check for scoring [cite:84]
