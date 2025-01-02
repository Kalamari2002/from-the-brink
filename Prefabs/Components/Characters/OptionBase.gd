###
# Base class for an ability/option. It's activated by its parent selector
# and signalizes when the option has started and ended.
###
extends Node2D

signal start_atk	# signaled upon activation
signal end_atk		# signaled when the option ends its behavior

export var option_name : String		# Name that appears in the selector label
export var icon_path : String		# icon path

var character		# Character calling this option
var active			# Determines if this option can act or not

# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent().get_parent().get_parent()
	active = false
	pass # Replace with function body.

###
# Call this to make the option start its behavior
###
func activate():
	active = true
	print(option_name)
	emit_signal("start_atk")
	deactivate()

###
# Call this to make the option end its behavior
###
func deactivate():
	active = false
	emit_signal("end_atk")

###
# @return option name/text label
###
func get_name():
	return option_name

###
# @return path of the icon
###
func get_icon_path():
	return icon_path
