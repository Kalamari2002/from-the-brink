extends Node2D

signal entered_bullet_time
signal exited_bullet_time

const BULLET_TIME_SPEED = 0.5
var time_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func enter_bullet_time():
	time_speed = BULLET_TIME_SPEED
	emit_signal("entered_bullet_time")

func exit_bullet_time():
	time_speed = 1
	emit_signal("exited_bullet_time")

func get_time_speed():
	return time_speed

func get_bullet_time_speed():
	return BULLET_TIME_SPEED
