extends Area2D

var speed = 200
var target_position = Vector2.ZERO
var velocity = Vector2()



func _ready():
	pass

#input listener
func _input(event):

	if event is InputEventMouseMotion:
		target_position = event.position

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
	
	
func destroy_itself():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
