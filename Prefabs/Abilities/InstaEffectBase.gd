extends "res://Prefabs/Components/Characters/OptionBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var control_scheme
var cursor_manager
var position_manager
var atk_rate

export var TOTAL_ATK_CNT : int
var atk_count
var can_atk = true

# Called when the node enters the scene tree for the first time.
func _ready():

	control_scheme = character.get_node("ControlScheme")
	cursor_manager = character.get_node("CursorManager")
	position_manager = character.get_node("PositionManager")
	
	atk_rate = get_node("AtkRate")
	
	connect("start_atk", position_manager,"set_can_move",[false])	# Stops position manager from moving when this atk has started 
	connect("end_atk", position_manager,"set_can_move",[true])	# Lets position manager retake control when atk is over
	atk_count = TOTAL_ATK_CNT
	pass # Replace with function body.

func _input(event):
	if !active:
		return
	if event.is_action_pressed(control_scheme.confirm()):
		confirm_effect()

func confirm_effect():
	if !can_atk:
		return
	cursor_manager.get_adversary_column().affect_quadrants("damage",10) # Requests opposite column to atk the selected quadrant
	atk_count -= 1
	can_atk = false
	atk_rate.start()
	if atk_count == 0:
		deactivate() # Ends attack
	
func activate():
	.activate()
	can_atk = true
	atk_count = TOTAL_ATK_CNT
	cursor_manager.enable_cursor()
	pass
	
func deactivate():
	.deactivate()
	atk_rate.stop()
	cursor_manager.disable_cursor()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AtkRate_timeout():
	can_atk = true
	pass # Replace with function body.
