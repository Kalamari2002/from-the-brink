extends "res://Prefabs/Components/Characters/OptionBase.gd"

var effect_manager : Node2D

func initialize(charactr):
	character = charactr
	control_scheme = character.get_node("ControlScheme")
	
	connect("start_atk", character, "start_atking") # Wanna let the caller know when this atk has started
	connect("end_atk", character,"end_turn") # Wanna let the caller know when it's over
	
	add_to_group("abilities")
	effect_manager = character.get_node("EffectManager")

func activate():
	active = true
	print(option_name)
	emit_signal("start_atk")
	effect_manager.apply_effect("mapled",0)
	deactivate()

func deactivate():
	active = false
	emit_signal("end_atk")
