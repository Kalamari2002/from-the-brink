extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Node2D/sender").connect("s", self, "receive")
	pass # Replace with function body.

func receive():
	print("RECEIVED BIATCh")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
