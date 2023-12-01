extends Node

signal game_not_running
signal game_new_game



export (PackedScene) var mob_scene
export var oxygenTimer : float = 60.0


var game_running: bool = false


	

func new_game():
	set_process(true)
	emit_signal("game_new_game")
	oxygenTimer = 60.0
	var goal = 0
	
	$HUD.update_time(oxygenTimer)
	$HUD.update_goal(goal)
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$Music.play()
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
	$Music.stop()
	$DeathSound.play()

	
func game_win():
	$Player.destroy_itself()
	set_process(false)
	game_running = false
	emit_signal("game_not_running")
	$MobTimer.stop()
	$HUD.show_game_win()
	$Music.stop()
	$WinSound.play()


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
		mob.get_node("AnimatedSprite").flip_v = true
		mob.rotation = direction
	
	#movement
	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = velocity.rotated(direction)
	
	


func _on_HUD_htp_show():
	
	var instructions_scene = preload("res://scenes/HowToPlay.tscn")
	var instructions_instance = instructions_scene.instance()
	
	# Add the instructions scene as a child of the main scene
	get_tree().get_root().add_child(instructions_instance)
	
	instructions_instance.connect("show_menu", self, "_on_HowToPlay_return")

func _on_HowToPlay_return():
	$HUD.show_hud()
	
