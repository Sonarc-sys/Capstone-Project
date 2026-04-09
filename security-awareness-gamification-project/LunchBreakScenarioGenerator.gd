extends Resource
class_name ScenarioGenerator

@export var days_array: Array[Resource] = []

func get_rand_lunchbreak():
	if days_array.size() > 0:
		# randi() % size picks a random index from the array
		var random_index = randi() % days_array.size()
		return days_array[random_index]
	return null
