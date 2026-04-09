extends Node
#Global Manager for score which will be displayed as money will be autloaded fromt he beginning
var score: int = 0 #money
var currentScoreIncrement = 10 #increment control

#Score Methods ------------------------------------------------------------------------------
#add score
func add_score(amount:int):
	score += amount
	print("score has been added to. Amount added is = ", amount, " New score is: $", score)
	
#Subtract score
func minus_score(amount:int):
	score -= amount
	print("score has been subtracted from. Amount subtracted is = ", amount, " New score is: $", score)

#Reset score on new game
func reset_score():
	score = 0
	

#ScoreIncrement Methods -----------------------------------------------------------
#add score
func add_increment(amount:int):
	currentScoreIncrement += amount
	print("Current Score INcrement: ", currentScoreIncrement)
	
#Subtract score
func minus_increment(amount:int):
	currentScoreIncrement -= amount
	print("Current Score increment: ", currentScoreIncrement)

#Reset score on new game
func reset_increment():
	currentScoreIncrement = 10
	
