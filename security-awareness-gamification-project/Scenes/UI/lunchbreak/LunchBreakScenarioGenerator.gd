extends Node
class_name LunchBreakScenarioGenerator

@export var all_Scenarios: Array[LunchBreakScenario] = []

#Returns a random lunch break scenario [cite: 83, 103]
func get_rand_lunchbreak() -> LunchBreakScenario:
	if all_Scenarios.size() > 0:
		all_Scenarios.shuffle()
		return all_Scenarios[0]
	return null
