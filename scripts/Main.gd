extends Node

signal game_not_running
signal game_new_game

export (PackedScene) var mob_scene
export var oxygenTimer : float = 100.0


var game_running: bool = false

func new_game():
	set_process(true)
	emit_signal("game_new_game")
	oxygenTimer = 100
	var goal = 0
	
	$HUD.update_time(oxygenTimer)
	$HUD.update_goal(goal)
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	
	$HUD.show_message("Photograph The Beauty Of The Ocean")
	yield($StartTimer, "timeout")
	game_running= true
	#spawn mobs after timeout
	$MobTimer.start()
	
func game_over():
	$Player.destroy_itself()
	set_process(false)
	game_running = false
	$MobTimer.stop()
	$HUD.show_game_over()

	
func game_win():
	set_process(false)
	game_running = false
	emit_signal("game_not_running")
	$MobTimer.stop()
	$HUD.show_game_win()


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
	
	
	
func end_game(goal):
	if goal == 3:
		game_win()
	else:
		$MobTimer.stop()
		game_over()



func _on_Player_photograph(goal):
	$HUD.update_goal(goal)
	


func _on_Player_return_ship(goal):
	end_game(goal) # Replace with function body.


func _on_MobTimer_timeout():
	var mob_spawn_left = $MobLeftPath/LeftSpawnLocation
	var mob_spawn_right = $MobRightPath/RightSpawnLocation
	var mob = mob_scene.instance()
	add_child(mob)
	
	var spawn_on_left = randi() % 2 == 0
	var direction 
	

	mob_spawn_left.unit_offset = randf()
	mob_spawn_right.unit_offset = randf()
	
	if spawn_on_left:
		mob.position = mob_spawn_left.position
		direction = mob_spawn_left.rotation - PI / 2

		mob.rotation = direction
		
	else:
		mob.position = mob_spawn_right.position
		direction = mob_spawn_right.rotation + PI / 2

		mob.rotation = direction
	
	#movement
	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	
