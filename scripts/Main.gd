extends Node

signal game_not_running
signal game_new_game

export var oxygenTimer : float = 100.0

var game_running: bool = false

func new_game():
	set_process(true)
	emit_signal("game_new_game")
	oxygenTimer = 100
	var goal = 0
	$HUD.update_time(oxygenTimer)
	$HUD.update_goal(goal)
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	$HUD.show_message("Photograph The Beauty Of The Ocean")
	yield($StartTimer, "timeout")
	game_running= true
	#spawn mobs after timeout
	
func game_over():
	$Player.destroy_itself()
	set_process(false)
	game_running = false
	$HUD.show_game_over()
	
func game_win():
	set_process(false)
	game_running = false
	emit_signal("game_not_running")
	$HUD.show_game_win()
	pass

# Called when the node enters the scene tree for the first time.	
func _ready():
	pass # Replace with function body.


func _process(delta):
	
	if game_running == true:
		oxygenTimer -= delta
	
	if oxygenTimer >= 0:
		$HUD.update_time(oxygenTimer)
	else:
		game_over()
	
	
	




func _on_Player_photograph(goal):
	$HUD.update_goal(goal)
	
	if goal == 3:
		game_win()
