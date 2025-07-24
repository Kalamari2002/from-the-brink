extends "res://Prefabs/Components/Characters/OptionBase.gd"


var cursor_manager : Node2D
var position_manager : Node2D
var melee_bar : Control
var damage_data : Node

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
	atk_count = TOTAL_ATK_CNT
	pass # Replace with function body.

func initialize(charactr):
	
	.initialize(charactr)
	
	control_scheme = character.get_node("ControlScheme")
	cursor_manager = character.get_node("CursorManager")
	position_manager = character.get_node("PositionManager")

	connect("start_atk", position_manager,"set_can_move",[false])	# Stops position manager from moving when this atk has started 
	connect("end_atk", position_manager,"set_can_move",[true])	# Lets position manager retake control when atk is over
	
	melee_bar = character.get_node("CharacterDisplay/MeleeBar")
	
	melee_bar.connect("low", self, "update_multiplier", [LOW_MULT])
	melee_bar.connect("base", self, "update_multiplier", [1])
	melee_bar.connect("high", self, "update_multiplier", [HIGH_MULT])
	melee_bar.connect("critical", self, "update_multiplier", [CRIT_MULT])
	
	damage_data = $DamageData
	damage_data.set_origin(character)
	print("origin: ", damage_data.origin.get_name())
	print("target: ", damage_data.target_column)
	print("damage: ", damage_data.value)
	print("damage type: ", damage_data.dmg_type)
	print("attack type: ", damage_data.atk_type)
	
	pass

func update_multiplier(mult):
	multiplier = mult
	print(multiplier)

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
	damage_data.value = calc_damage()
	#cursor_manager.get_adversary_column().affect_quadrants("damage", damage_data) # Requests opposite column to atk the selected quadrant
	cursor_manager.get_adversary_column().affect_on_hit_quadrants({"damage":damage_data})
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
