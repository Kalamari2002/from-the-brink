extends "res://Prefabs/Effects/EffectBase.gd"

const REPLENISH_AMOUNT = 1
var health_manager : Node2D

func initialize(eff_man, charctr):
	.initialize(eff_man,charctr)
	health_manager = character.get_node("HealthManager")
	health_manager.connect("took_damaged", self, "end_effect")
	pass

func decrement():
	print("effect decremented")
	duration -= 1
	effect_manager.apply_effect("replenish_resource",REPLENISH_AMOUNT)
	if duration <= 0:
		end_effect()
