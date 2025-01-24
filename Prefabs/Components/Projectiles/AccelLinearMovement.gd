extends "res://Prefabs/Components/Projectiles/ProjectileComponents/ProjectileMovementBase.gd"


var acceleration
var CONSTANT = 900
var time_elapsed = 0.0

func _process(delta):
	time_elapsed += delta 

func _physics_process(delta):
	var travel_vector = Vector2(dir,0)
	get_parent().move_and_collide(travel_vector * velocity(time_elapsed) * time_manager.get_curr_scale())

func velocity(time):
	var offset = 1.4
	var expo = time - offset
	return pow(CONSTANT, expo) * 900
