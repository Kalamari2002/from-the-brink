extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var base_speed : int
var dir
var curr_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_speed = base_speed
	dir = get_parent().get_dir()
	if dir == -1:
		get_parent().get_node("Sprite").flip_h = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	var travel_vector = Vector2(dir,0)
	get_parent().move_and_collide(travel_vector * delta * curr_speed)
