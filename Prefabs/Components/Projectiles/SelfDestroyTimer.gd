extends Node2D

func _ready():
	pass # Replace with function body.

func self_destroy():
	print("destroyed")
	get_parent().queue_free()

func _on_Timer_timeout():
	self_destroy()
	pass # Replace with function body.
