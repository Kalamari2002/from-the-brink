extends Node2D


var trigger_both = false
var both_pressed = false
var character
var control_scheme

export var atk_tap : String
export var atk_release : String
export var dfs_spc_tap : String
export var dfs_spc_release : String
export var off_spc_tap : String
export var off_spc_release : String
export var both_release : String

var skill_map = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	character = self.owner
	control_scheme = character.get_node("ControlScheme")
	
	skill_map = {
		"atk_tap" : atk_tap,
		"atk_release" : atk_release,
		"dfs_spc_tap" : dfs_spc_tap,
		"dfs_spc_release" : dfs_spc_release,
		"off_spc_tap" : off_spc_tap,
		"off_spc_release" : off_spc_release,
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
		#trigger_ability("dfs_spc_tap")
		trigger_ability(curr_spc("tap"))
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
				#trigger_ability("dfs_spc_release")
				trigger_ability(curr_spc("release"))
				
			else:
				trigger_both = false
		both_pressed = false

func curr_spc(action):
	if character.get_curr_state() != character.GameState.ATTACKING:
		return "dfs_spc_"+action
	return "off_spc_"+action

func trigger_ability(command):
	if skill_map[command] == "":
		return
	get_node(skill_map[command]).trigger()
	pass
