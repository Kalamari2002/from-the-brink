###
# A base for quicktime event contests. It creates a quick time event and determines which side is the 
# caller (atker) at. If caller side wins the contest, an effect is applied to the target. If not, 
# nothing happens. Deletes the quicktime event object afterwards. 
###

extends Node2D

signal start_qt_challenge		# attack on activation signal
signal end_qt_challenge			# attack on deactivation signal
var active = false				# determines if current option is active

var control_scheme
var cursor_manager
var position_manager

var character			# Reference for the character calling this attack
var target				# character to whom the effects will be applied if caller wins the contest

var quicktimeevent = preload("res://Prefabs/Components/Characters/QuickTimeEvent.tscn")
var quicktimeobject # used to reference the created quicktime event, deletes it l8r

func _ready():
	character = get_parent().get_parent()
	
	connect("start_qt_challenge", character, "start_atking") # lets caller know when this attack has started
	connect("end_qt_challenge", character,"end_turn") # lets caller know when this attack is over
	
	control_scheme = character.get_node("ControlScheme")
	cursor_manager = character.get_node("CursorManager")
	position_manager = character.get_node("PositionManager")
	pass # Replace with function body.

###
# Called by OptionSelector to initiate this attack. Emits signal that the attack has begun,
# picks the target of the attack and initializes a quick time event
###
func activate():
	active = true
	emit_signal("start_qt_challenge")
	determine_target()
	initialize_event()

###
# Creates a quick time event. It sets which side the attacker/caller is at and starts the qt event.
###
func initialize_event():
	var quicktime = quicktimeevent.instance()
	quicktime.connect("finish",self,"check_result") # Wanna know when the qt event is finished so we can check the winner
	get_node("/root/Board").add_child(quicktime) 
	var caller_val = 0 # 0 = left
	if character.get_id() % 2 == 0: # if character is on the right, caller is the right scheme
		caller_val = 1  # 1 = right
		# startquicktime(side of the caller, left control scheme, right control scheme)
		quicktime.start_quicktime(caller_val, target.get_node("ControlScheme").get_scheme_scancode(), control_scheme.get_scheme_scancode())
	else: # if character is on the left, caller will be the left scheme
		quicktime.start_quicktime(caller_val, control_scheme.get_scheme_scancode(), target.get_node("ControlScheme").get_scheme_scancode())
	quicktimeobject = quicktime
	pass

###
# Picks the target of the qt atk. It just gets the first character in the opposite column.
# If more players are added this is gonna have to be changed.
###
func determine_target():
	target = cursor_manager.get_adversary_column().get_characters()[0]

###
# Called when this object receives the quicktimeevent object's signal that the event is over.
# If the caller was the winner of the contest, we apply an effect on the target. Deletes the
# quicktime object and deactivates the atk.
###
func check_result():
	if quicktimeobject.get_has_caller_won():
		apply_effect()
	
	quicktimeobject.queue_free()
	deactivate()

###
# Effect applied to target
###
func apply_effect():
	target.take_dmg(40)

###
# Called to stop the atk. Sends signal to caller character that the attack is over.
###
func deactivate():
	active = false
	emit_signal("end_qt_challenge")
