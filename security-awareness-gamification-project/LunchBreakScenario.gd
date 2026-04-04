extends Resource

@export var scenario_text: String
@export var scenario_image: Texture2D  # ADD THIS LINE
@export var thechoices: Array[String] = []
@export var correct_choiceindex: int
@export var consequence_Text: String
@export var is_safeScenario: bool = true # Binary check for scoring [cite:84]
