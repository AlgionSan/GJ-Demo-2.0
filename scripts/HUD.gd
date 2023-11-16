extends CanvasLayer

signal start_game

func _ready():
	pass

func update_goal(cur_goal, max_goals):
	$GoalLabel.text = "Goal: " + str(cur_goal) + "/" + str(max_goals)

func update_time(time):
	$TimeLabel.text = "Time: " + str(int(time))
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Diver's Trove"
	$MessageLabel.show()
	$StartButton.show()
	$ExitButton.show()
	

func _on_StartButton_pressed():
	$StartButton.hide()
	$ExitButton.hide()
	emit_signal("start_game")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
