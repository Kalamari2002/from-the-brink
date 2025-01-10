extends Node2D

export var base_speed : int
var dir
var curr_speed = 0

func _ready():
	curr_speed = base_speed
	dir = get_parent().get_dir()
	if dir == -1:
		get_parent().get_node("Sprite").flip_h = true
		get_parent().get_node("Area2D").scale = Vector2(-1,1)
	pass # Replace with function body.

func multiply_speed(mult):
	curr_speed *= mult

func restore_speed():
	curr_speed = base_speed
