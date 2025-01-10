extends Node2D


var trigger_both = false
var both_pressed = false
var character
var control_scheme

export var atk_tap : String
export var atk_release : String
export var spc_tap : String
export var spc_release : String
export var both_release : String

var skill_map = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	character = self.owner
	control_scheme = character.get_node("ControlScheme")
	
	skill_map = {
		"atk_tap" : atk_tap,
		"atk_release" : atk_release,
		"spc_tap" : spc_tap,
		"spc_release" : spc_release,
		"both_release" : both_release
	}
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed(control_scheme.confirm()) and Input.is_action_pressed(control_scheme.special()):
		both_pressed = true
	
	if Input.is_action_just_pressed(control_scheme.confirm()):
		trigger_ability("atk_tap")
		pass
		
	if Input.is_action_just_pressed(control_scheme.special()):
		trigger_ability("spc_tap")
		pass

	if Input.is_action_just_released(control_scheme.confirm()):
		if both_pressed:
			trigger_ability("both_release")
			trigger_both = true
		else:
			if !trigger_both:
				trigger_ability("atk_release")
			else:
				trigger_both = false
		both_pressed = false
	
	if Input.is_action_just_released(control_scheme.special()):
		if both_pressed:
			trigger_ability("both_release")
			trigger_both = true
		else:
			if !trigger_both:
				trigger_ability("spc_release")
			else:
				trigger_both = false
		both_pressed = false

func trigger_ability(command):
	if skill_map[command] == "":
		return
	get_node(skill_map[command]).trigger()
	pass
