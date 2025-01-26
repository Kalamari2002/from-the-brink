extends "res://Prefabs/Components/Characters/ResourceManager.gd"

var effect_manager : Node2D

func _ready():
	effect_manager = get_parent().get_node("EffectManager")
	pass

func consume(val):
	if depleted:
		return
	curr_value = clamp(curr_value - val, 0, MAX_VALUE)
	if curr_value == 0:
		depleted = true
		effect_manager.apply_effect("burnedout",0)
		display.color_unavailable()
		emit_signal("depleted")
	
	display.update_value(curr_value)
	return true

func replenish(val):
	if is_capped:
		curr_value = clamp(curr_value + val, 0, MAX_VALUE)
	else:
		curr_value += val
	
	if curr_value >= MAX_VALUE:
		display.color_available()
		depleted = false
	display.update_value(curr_value)
