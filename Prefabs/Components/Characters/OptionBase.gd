###
# Base class for an ability/option. It's activated by its parent selector
# and signalizes when the option has started and ended.
###
extends Node2D

signal start_atk	# signaled upon activation
signal end_atk		# signaled when the option ends its behavior

export var option_name : String		# Name that appears in the selector label
export var icon_path : String		# icon path
export var instruction : String		# Instruction text on how to use this ability

var active			# Determines if this option can act or not
var character		# Character calling this option
var instruction_label
var control_scheme

var duration_timer
var duration_label
var gamestate_manager
# Called when the node enters the scene tree for the first time.
func _ready():

	duration_timer = get_node("Duration")
	
	duration_label = get_node("/root/Board/AttackDuration")
	gamestate_manager = get_node("/root/Board/GameManager/GameStateManager")
	gamestate_manager.connect("game_set",self,"seize")
	
	active = false
	pass # Replace with function body.

func initialize(charactr):
	character = charactr
	
	instruction_label = character.get_node("Instructions/Label")
	control_scheme = character.get_node("ControlScheme")
	
	connect("start_atk", character, "start_atking") # Wanna let the caller know when this atk has started
	connect("end_atk", character,"end_turn") # Wanna let the caller know when it's over
	
	add_to_group("abilities")
	pass

###
# Call this to make the option start its behavior
###
func activate():
	active = true
	duration_timer.start()
	duration_label.start(duration_timer.time_left)
	instruction_label.visible = true
	instruction_label.text = instruction
	emit_signal("start_atk")

###
# Call this to make the option end its behavior. Signals to the character that
# their turn is over.
###
func deactivate():
	if !active:
		return
	
	duration_timer.stop()
	duration_label.stop()
	active = false
	instruction_label.visible = false
	emit_signal("end_atk")
	pass

###
# Call this to make the option end its behavior and not
# signalize to the player that the attack is over.
###
func seize():
	print(character.get_name() + " " + self.get_name() + " SEIZED")
	duration_timer.stop()
	duration_label.stop()
	active = false
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
	deactivate()
	pass # Replace with function body.
