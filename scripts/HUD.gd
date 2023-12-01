extends CanvasLayer

signal start_game
signal htp_show

func _ready():
	hide_hud()
	
func update_goal(cur_goal):
	$GoalLabel.text = "Goal: " + str(cur_goal) + "/" + str(3)

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
	hide_hud()
	$StartButton.show()
	$HowToPlayButton.show()
	$ExitButton.show()

func show_game_win():
	show_message("You Won")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Diver's Trove"
	$MessageLabel.show()
	$StartButton.show()
	$ExitButton.show()

func _on_StartButton_pressed():
	$GoalLabel.show()
	$TimeLabel.show()
	$StartButton.hide()
	$HowToPlayButton.hide()
	$ExitButton.hide()
	emit_signal("start_game")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_HowToPlayButton_button_down():
	# Load the Instructions scene
	$StartButton.hide()
	$HowToPlayButton.hide()
	$ExitButton.hide()
	$MessageLabel.hide()
	emit_signal("htp_show")
	
func show_hud():
	$StartButton.show()
	$HowToPlayButton.show()
	$ExitButton.show()
	$MessageLabel.show()
	

func hide_hud():
	$GoalLabel.hide()
	$TimeLabel.hide()
	
