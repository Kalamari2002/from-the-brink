extends Node2D

signal s(val)


# Called when the node enters the scene tree for the first time.
func _ready():
	var time_in_seconds = 2
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	emit_signal("s",3)
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
