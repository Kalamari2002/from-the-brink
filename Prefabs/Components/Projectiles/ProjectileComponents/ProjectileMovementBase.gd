extends Node2D

export var base_speed : int
var dir
var curr_base = 0
var is_slown = false
var time_manager

func _ready():
	curr_base = base_speed
	time_manager = get_node("/root/Board/GameManager/TimeScaleManager")
	dir = get_parent().get_dir()
	if dir == -1:
		get_parent().get_node("Sprite").flip_h = true
		get_parent().get_node("Area2D").scale = Vector2(-1,1)
	pass # Replace with function body.

func apply_acceleration(delta):
	curr_base += (delta * time_manager.get_curr_scale())
	
func multiply_speed(mult):
	curr_base *= mult
