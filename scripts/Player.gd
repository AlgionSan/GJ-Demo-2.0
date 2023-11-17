extends Area2D

signal photograph


var speed = 200
var target_position = Vector2.ZERO
var velocity = Vector2()
var marineLifeCount : int = 0
var maxMarineLife : int = 3

# List to store unique identifiers of photographed objects
var photographed_objects : Array = []

onready var player_label = $PlayerInteractLabel
onready var all_interactions = []


func _ready():
	hide()
	update_interactions()

#input listener
func _input(event):

	if event is InputEventMouseMotion:
		target_position = event.position
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()

#update function per frame
func _process(delta):
	if position.distance_to(target_position) > 5:
		move_towards(target_position,delta)

#movement	
func move_towards(end_position, delta):

	var direction = (end_position - position).normalized()
	velocity = direction * speed 
	rotation = direction.angle()
	position += velocity * delta
	
func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false	
	
func destroy_itself():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)


#interaction and player collission methods
###################################

func _on_Player_area_entered(area):
	all_interactions.insert(0,area)
	update_interactions()

func _on_Player_area_exited(area):
	all_interactions.erase(area)
	update_interactions()
	
func update_interactions():
	if all_interactions:
		player_label.text = all_interactions[0].interact_label
	else:
		player_label.text = ""
		

func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"photograph_goal": 
				handle_photograph_goal(cur_interaction)
				
func photograph_marine_life():
	if marineLifeCount < maxMarineLife:
		marineLifeCount += 1
		print("Photographed marine life! " + str(marineLifeCount) + " out of " + str(maxMarineLife))
		update_interactions()  # Update interactions after a successful photograph
		
		emit_signal("photograph", marineLifeCount)
	else:
		print("You've already photographed enough marine life!")
		
# Function to handle the "photograph_goal" case
func handle_photograph_goal(cur_interaction):
	if cur_interaction.interact_value in photographed_objects:
		print("You've already photographed this object!")
		player_label.text = "You've already photographed this object!"
	else:
		photograph_marine_life()
		photographed_objects.append(cur_interaction.interact_value)



func _on_Main_game_not_running():
	set_process(false)
