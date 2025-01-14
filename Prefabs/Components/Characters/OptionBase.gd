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
var parent_selector
var duration_timer
var duration_label
var gamestate_manager
# Called when the node enters the scene tree for the first time.
func _ready():
	character = self.owner
	duration_timer = get_node("Duration")
	parent_selector = get_parent().get_parent()
	
	duration_label = get_node("/root/Board/AttackDuration")
	gamestate_manager = get_node("/root/Board/GameManager/GameStateManager")
	gamestate_manager.connect("game_set",self,"seize")
	
	connect("start_atk", parent_selector, "close")
	
	connect("start_atk", character, "start_atking") # Wanna let the caller know when this atk has started
	connect("end_atk", character,"end_turn") # Wanna let the caller know when it's over
	character.connect("died", self, "seize")
	
	add_to_group("abilities")
	
	active = false
	pass # Replace with function body.

###
# Call this to make the option start its behavior
###
func activate():
	active = true
	duration_timer.start()
	print(option_name)
	duration_label.start(duration_timer.time_left)
	emit_signal("start_atk")

###
# Call this to make the option end its behavior
###
func deactivate():
	duration_timer.stop()
	duration_label.stop()
	active = false
	emit_signal("end_atk")

func seize():
	active = false
	duration_timer.stop()
	duration_label.stop()

func hasten():
	pass

func unhaste():
	pass

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


func _on_Duration_timeout():
	if !active:
		return
	print("TIMEOUT")
	deactivate()
	pass # Replace with function body.
