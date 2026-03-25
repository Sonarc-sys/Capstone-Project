extends Node


var current_emailcount: int = 0 #[cite: 92, 116]
var players_score: int = 0 #[cite: 107, 118]

func _on_emails_processed(is_correct: bool):
	current_emailcount += 1
	
	
	if is_correct:
		players_score += 100 #Adjust this value based on our ScoreManager value: [cite: 118]
	else:
		players_score -= 50 #[cite:119]
	
	#Check for the Lunch Break trigger value.
	if current_emailcount == 5:
		trigger_thelunch_break()
	elif current_emailcount >= 10:
		show_the_endofdayreport() #[cite: 117, 122]
			
func trigger_thelunch_break():
	#Now, Transition to the LunchBreakScenario [cite: 81, 103]
	print("Now, Switch to Lunch Break")
	
func show_the_endofdayreport():
	#Pass the score and faults to the Report screen [cite: 14, 122]
	print("Creating Final Report Now: ")
