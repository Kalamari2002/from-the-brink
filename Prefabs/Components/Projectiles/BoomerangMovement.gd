extends "res://Prefabs/Components/Projectiles/ProjectileComponents/ProjectileMovementBase.gd"


var left_column : Node2D
var right_column : Node2D

var going_back = false
var stopped = true

var acceleration = 40
var bullet_time_offset = 2
var animation_player

func _ready():
	left_column = get_tree().get_root().get_node("Board/Quadrants/left")
	right_column = get_tree().get_root().get_node("Board/Quadrants/right")
	animation_player = get_parent().get_node("AnimationPlayer")

func _physics_process(delta):
	movement(delta)

func movement(delta):
	if stopped:
		return
	
	if global_position.x > right_column.global_position.x or global_position.x < left_column.global_position.x:
		switch_speed()
	
	var travel_vector = Vector2(dir,0)
	get_parent().move_and_collide(travel_vector * curr_base * time_manager.get_curr_scale())
	if going_back:
		curr_base -= (acceleration * delta)
	pass

func move(direction : int):
	dir = direction
	stopped = false
	curr_base = base_speed
	
	if dir == -1:
		animation_player.play("Rotate_Reverse")
	else:
		animation_player.play("Rotate")

func stop():
	stopped = true
	curr_base = 0
	going_back = false
	animation_player.stop()

func switch_speed():
	going_back = true
