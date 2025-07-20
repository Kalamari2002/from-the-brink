extends Node2D

export var base_speed : int
var dir : int 
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
	pass
	
func multiply_speed(mult):
	curr_base *= mult
	pass

func on_reflect():
	dir = get_parent().get_dir()
	pass
