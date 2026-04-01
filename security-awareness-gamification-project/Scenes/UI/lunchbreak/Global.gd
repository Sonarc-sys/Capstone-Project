extends Node

var score_Manager = ScoreManager.new()

class ScoreManager:
	var player_score: int = 0
	
	func add_penalty(amount: int):
		player_score -= amount
		print("Penalty has been added. Your Current Score is: ", player_score)
		
