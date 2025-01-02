extends "res://Prefabs/Components/Characters/OptionBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var control_scheme
var cursor_manager
var position_manager


# Called when the node enters the scene tree for the first time.
func _ready():

	control_scheme = character.get_node("ControlScheme")
	cursor_manager = character.get_node("CursorManager")
	position_manager = character.get_node("PositionManager")
	
	connect("start_atk", position_manager,"set_can_move",[false])	# Stops position manager from moving when this atk has started 
	connect("end_atk", position_manager,"set_can_move",[true])	# Lets position manager retake control when atk is over
	
	pass # Replace with function body.

func _input(event):
	if !active:
		return
	if event.is_action_pressed(control_scheme.confirm()):
		confirm_effect()

func confirm_effect():
	cursor_manager.get_adversary_column().affect_quadrants("damage",25) # Requests opposite column to atk the selected quadrant
	deactivate() # Ends attack
	
func activate():
	.activate()
	cursor_manager.enable_cursor()
	pass
	
func deactivate():
	.deactivate()
	cursor_manager.disable_cursor()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
