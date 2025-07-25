extends "res://Prefabs/Components/Projectiles/ProjectileComponents/ProjectileMovementBase.gd"

const Y_INIT = 800
const B_CONST_INIT = -40
var time = 0
var a_const = 90
var b_const = B_CONST_INIT
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	time += delta
	var travel_vector = Vector2(dir * curr_base, y_velocity(time))
	get_parent().move_and_collide(travel_vector * time_manager.get_curr_scale())

func y_velocity(delta):
	return (a_const*delta) + b_const

func bounce():
	time = 0
	b_const = -20
	pass
	
func get_curr_y_vel():
	return y_velocity(time)

func on_reflect():
	.on_reflect()
	b_const = B_CONST_INIT
	time = 0;
	pass
