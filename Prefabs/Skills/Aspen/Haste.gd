extends "res://Prefabs/Components/Characters/SkillBase.gd"


var is_hasted = false
var selector
var resource_manager
var control_scheme
# Called when the node enters the scene tree for the first time.
func _ready():
	resource_manager = character.get_node("ResourceManager")
	resource_manager.connect("depleted", self, "end_haste")
	
	selector = character.get_node("Selector")
	
	control_scheme = character.get_node("ControlScheme")
	
	character.connect("turn_ended",self,"end_haste")
	pass # Replace with function body.

#func _input(event):
#	if !is_active():
#		return
#	if event.is_action_released(control_scheme.special()):
#		start_haste()

func _process(delta):
	if is_hasted:
		resource_manager.consume(delta)
func begin():
	if resource_manager.get_remaining_resource() <= 0:
		return
	start_haste()
func start_haste():
	print("HASTED")
	is_hasted = true
	selector.get_last_pic().hasten()
	pass
func end_haste():
	print("UNHASTE")
	is_hasted = false
	selector.get_last_pic().unhaste()
	pass
func is_active():
	if character.get_curr_state() != character.GameState.ATTACKING:
		return false
	return true
