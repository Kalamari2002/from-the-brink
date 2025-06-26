###
# This class controls the time scale of the game. It can enter and exit bullet
# time.
###

extends Node2D

signal bullet_time
signal normal_time

const BULLET_TIME_SCALE = 0.4
var curr_scale = 1
var bullet_time_dim

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_time_dim = get_node("/root/Board/Control/BulletTimeDim")
	pass # Replace with function body.

func enter_bullet_time():
	print("BULLET TIME")
	emit_signal("bullet_time")
	curr_scale = BULLET_TIME_SCALE
	bullet_time_dim.get_node("AnimationPlayer").play("FadeIn")
	Engine.time_scale = curr_scale

func normalize_time_scale():
	if curr_scale == 1:
		return
	print("NORMAL TIME")
	emit_signal("normal_time")
	curr_scale = 1
	Engine.time_scale = curr_scale
	bullet_time_dim.get_node("AnimationPlayer").play("FadeOut")

func get_curr_scale()->float:
	return curr_scale

func get_bullet_time_scale()->float:
	return BULLET_TIME_SCALE
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_in_bullet_time()->bool:
	return curr_scale == BULLET_TIME_SCALE
