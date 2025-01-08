extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal got_hit(area)

var dir

func set_dir(val):
	dir = val

func get_dir():
	return dir
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_area_entered(area):
	emit_signal("got_hit",area)
	pass # Replace with function body.
