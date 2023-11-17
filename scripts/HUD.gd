extends CanvasLayer

signal start_game

func _ready():
	pass
	
func update_goal(cur_goal):
	$GoalLabel.text = "Objectif: " + str(cur_goal) + "/" + str(3)

func update_time(time):
	$TimeLabel.text = "Minuteur: " + str(int(time))
	
	
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

func show_game_win():
	show_message("vous avez gagné")
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
