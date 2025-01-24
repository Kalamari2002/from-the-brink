extends "res://Prefabs/Components/Projectiles/ProjectileComponents/ProjectileMovementBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _physics_process(delta):
	var travel_vector = Vector2(dir,0)
	get_parent().move_and_collide(travel_vector * curr_base * time_manager.get_curr_scale())
