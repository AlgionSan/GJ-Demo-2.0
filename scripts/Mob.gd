extends RigidBody2D


export var min_speed = 200.0
export var max_speed = 500.0

func _ready():

	$AnimatedSprite.playing = true
	#get list of animation names from Frames Resource
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	#set animation to the index random of mob_types size
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	



func _on_VisibilityNotifier2D_screen_exited():
	#destroy game object
	#queue free is safer in godot, source: trust me
	queue_free()
