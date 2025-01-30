### !!!!!!!!!!!!!!!!!!!!
#	MOVEMENT SCRIPT MUST BE THE FIRST CHILD
#	EFFECTONCOLLISION MUST BE THE SECOND CHILD
### !!!!!!!!!!!!!!!!!!!!
extends KinematicBody2D

signal got_hit(area)

var dir : int
var origin_quadrant : int

func _ready():
	print("HERE")

func get_dir():
	return dir

func set_charge(charge):
	get_child(0).multiply_speed(charge)
	get_child(1).multiply_damage(charge)

func initialize(character):
	var position_manager = character.get_node("PositionManager")
	global_position = Vector2(character.global_position.x + position_manager.get_spawn_offset(), character.global_position.y)
	dir = 1
	if position_manager.get_is_right():
		dir = -1
	origin_quadrant = position_manager.get_curr_pos()

func get_origin_quadrant():
	return origin_quadrant

func _on_Area2D_area_entered(area):
	emit_signal("got_hit",area)
	pass # Replace with function body.
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																									  
