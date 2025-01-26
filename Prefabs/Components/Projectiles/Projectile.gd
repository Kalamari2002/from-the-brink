### !!!!!!!!!!!!!!!!!!!!
#	MOVEMENT SCRIPT MUST BE THE FIRST CHILD
#	EFFECTONCOLLISION MUST BE THE SECOND CHILD
### !!!!!!!!!!!!!!!!!!!!
extends KinematicBody2D

signal got_hit(area)

var dir : int
var origin_quadrant : int

func set_dir(val):
	dir = val

func get_dir():
	return dir

func set_charge(charge):
	get_child(0).multiply_speed(charge)
	get_child(1).multiply_damage(charge)

func set_origin_quadrant(idx):
	origin_quadrant = idx

func get_origin_quadrant():
	return origin_quadrant

func _on_Area2D_area_entered(area):
	emit_signal("got_hit",area)
	pass # Replace with function body.
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																									  
