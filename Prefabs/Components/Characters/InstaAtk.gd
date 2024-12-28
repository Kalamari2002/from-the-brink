###
# Base for any attack that involves a cursor. Prevents atker from moving
# and lets them choose a quadrant to atk. Any character standing at the atked quadrant
# takes damage.
###

extends Node2D

signal start_insta_atk		# attack on activation signal
signal end_insta_atk		# attack on deactivation signal
var active = false			# determines if the atk is active or not

var control_scheme
var cursor_manager
var position_manager

var character		# Reference for the character calling this atk

# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent().get_parent()
	
	connect("start_insta_atk", character, "start_atking") # Wanna let the caller know when this atk has started
	connect("end_insta_atk", character,"end_turn") # Wanna let the caller know when it's over
	
	control_scheme = character.get_node("ControlScheme")
	cursor_manager = character.get_node("CursorManager")
	position_manager = character.get_node("PositionManager")
	
	connect("start_insta_atk", position_manager,"set_can_move",[false])	# Stops position manager from moving when this atk has started 
	connect("end_insta_atk", position_manager,"set_can_move",[true])	# Lets position manager retake control when atk is over
	
	pass
###
# Doesn't take inputs if it's not active
###
func _input(event):
	if !active:
		return
	if event.is_action_pressed(control_scheme.confirm()):
		cursor_manager.get_adversary_column().attack_quadrants(25) # Requests opposite column to atk the selected quadrant
		deactivate() # Ends attack

###
# Called by OptionSelector to initiate this atk. Enables cursor and sends signal that
# insta atk started.
###
func activate():
	active = true
	cursor_manager.enable_cursor()
	emit_signal("start_insta_atk")
	pass

###
# Called to stop the atk. Disables cursor.
###
func deactivate():
	emit_signal("end_insta_atk")
	active = false
	cursor_manager.disable_cursor()
