extends "res://Prefabs/Components/Characters/OptionBase.gd"

var control_scheme
var cursor_manager
var position_manager
var melee_bar

export var TOTAL_ATK_CNT : int
export var BASE_DAMAGE : int

export var LOW_MULT : float
export var HIGH_MULT : float
export var CRIT_MULT : float

var atk_count
var is_charging = false
var multiplier = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():

	control_scheme = character.get_node("ControlScheme")
	cursor_manager = character.get_node("CursorManager")
	position_manager = character.get_node("PositionManager")
	melee_bar = character.get_node("CharacterDisplay/MeleeBar")
	
	melee_bar.connect("low", self, "update_multiplier", [LOW_MULT])
	melee_bar.connect("base", self, "update_multiplier", [1])
	melee_bar.connect("high", self, "update_multiplier", [HIGH_MULT])
	melee_bar.connect("critical", self, "update_multiplier", [CRIT_MULT])
	
	connect("start_atk", position_manager,"set_can_move",[false])	# Stops position manager from moving when this atk has started 
	connect("end_atk", position_manager,"set_can_move",[true])	# Lets position manager retake control when atk is over
	atk_count = TOTAL_ATK_CNT
	pass # Replace with function body.


func update_multiplier(mult):
	multiplier = mult

func _input(event):
	if !active:
		return
	if event.is_action_pressed(control_scheme.confirm()):
		is_charging = true
		melee_bar.start_charge()
	if event.is_action_released(control_scheme.confirm()):
		if is_charging:
			confirm_effect()

func confirm_effect():
	cursor_manager.get_adversary_column().affect_quadrants("damage", calc_damage()) # Requests opposite column to atk the selected quadrant
	atk_count -= 1
	melee_bar.stop_charge()
	is_charging = false
	if atk_count == 0:
		deactivate() # Ends attack

func decrement_atk_count():
	atk_count -= 1

func get_atk_count():
	return atk_count

func calc_damage():
	return int(BASE_DAMAGE * multiplier)
	
func activate():
	.activate()
	atk_count = TOTAL_ATK_CNT
	cursor_manager.enable_cursor()
	melee_bar.visible = true
	pass
	
func deactivate():
	.deactivate()
	is_charging = false
	cursor_manager.disable_cursor()
	melee_bar.reset_charge()
	melee_bar.visible = false

func seize():
	.seize()
	melee_bar.visible = false
	cursor_manager.disable_cursor()
