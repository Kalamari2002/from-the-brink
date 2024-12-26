extends Node2D


signal start_qt_challenge
signal end_qt_challenge
var active = false

var control_scheme
var cursor_manager
var position_manager

var character
var target

var quicktimeevent = preload("res://Prefabs/Components/Characters/QuickTimeEvent.tscn")
var quicktimeobject

# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent().get_parent()
	control_scheme = character.get_node("ControlScheme")
	cursor_manager = character.get_node("CursorManager")
	position_manager = character.get_node("PositionManager")
	pass # Replace with function body.

func _input(event):
	if !active:
		return

func activate():
	active = true
	emit_signal("start_qt_challenge")
	determine_target()
	var quicktime = quicktimeevent.instance()
	quicktime.connect("finish",self,"check_result")
	
	get_node("/root/Board").add_child(quicktime)
	var caller_val = 0
	if character.get_id() % 2 == 0:
		caller_val = 1 
		quicktime.start_quicktime(caller_val,  target.get_node("ControlScheme").get_scheme_scancode(), control_scheme.get_scheme_scancode())
	else:
		quicktime.start_quicktime(caller_val, control_scheme.get_scheme_scancode(), target.get_node("ControlScheme").get_scheme_scancode())
	quicktimeobject = quicktime
	pass
	
func determine_target():
	target = cursor_manager.get_adversary_column().get_characters()[0]
	print(String(target.get_path()))

func check_result():
	if quicktimeobject.get_has_caller_won():
		apply_effect()
	
	quicktimeobject.queue_free()
	deactivate()

func apply_effect():
	target.take_dmg(40)

func deactivate():
	active = false
	emit_signal("end_qt_challenge")
