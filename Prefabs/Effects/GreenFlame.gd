###
# When this effect is active, the character suffering it takes additional damage everytime they're
# hit. This effect ends early if the character suffering it takes damage.
###

extends "res://Prefabs/Effects/EffectBase.gd"

const MULTIPLIER = 0.5
var health_manager
onready var timer = $Timer
onready var damage_data = $DamageData

func _ready():
	health_manager = character.get_node("HealthManager")
	
	get_parent().connect("took_damage", self, "combust")
	pass

###
# This is a parent function. Greenflame can't be reset.
###
func reset_effect():
	pass

###
# Called when the damaged character's health manager fires a "took_damage" signal
###
func combust(damage_amount : int):
	if character.get_curr_state() == character.GameState.DEAD:
		return
	damage_data.value = max(1, int(MULTIPLIER * damage_amount))
	timer.start()
	pass

func _on_Timer_timeout():
	effect_manager.apply_effect("damage", damage_data)
	end_effect()
	pass # Replace with function body.
