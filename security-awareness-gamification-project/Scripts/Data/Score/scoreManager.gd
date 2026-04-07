extends Node
#Global Manager for score which will be displayed as money will be autloaded fromt he beginning
var score: int = 0 #money

#add score
func add_score(amount:int):
	score += amount
	print("score has been added to. New score is: $", score)
	
#Subtract score
func minus_score(amount:int):
	score -= amount
	print("score has been subtracted from. New score is: $", score)

#Reset score on new game
func reset_score():
	score = 0
	
