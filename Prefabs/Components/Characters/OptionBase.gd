extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_atk
signal end_atk

export var option_name : String
export var icon_path : String

var active

# Called when the node enters the scene tree for the first time.
func _ready():
	active = false
	pass # Replace with function body.

func activate():
	active = true
	emit_signal("start_atk")

func deactivate():
	active = false
	emit_signal("end_atk")

func get_name():
	return option_name
	
func get_icon_path():
	return icon_path
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
