extends "res://Prefabs/Effects/EffectBase.gd"

var position_manager : Node2D
const PENALTY = 0.3
func _ready():
	position_manager.change_end_lag(PENALTY)

func initialize(eff_man, charctr):
	.initialize(eff_man, charctr)
	position_manager = character.get_node("PositionManager")

func end_effect():
	position_manager.change_end_lag(-PENALTY)
	.end_effect()
	pass
