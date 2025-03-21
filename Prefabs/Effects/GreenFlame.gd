###
# When this effect is active, the character suffering it takes additional damage everytime they're
# hit. This effect ends early if the character suffering it takes damage.
###

extends "res://Prefabs/Effects/EffectBase.gd"

const MULTIPLIER = 0.5
var health_manager
onready var timer = $Timer
onready var set_damage = 0
func _ready():
	health_manager = character.get_node("HealthManager")
	
	get_parent().connect("took_damage", self, "combust")
	pass

###
# This is a parent function. Greenflame can't be reset.
###
func reset_effect():
	pass

func combust(dmg):
	set_damage = dmg
	timer.start()
	pass


func _on_Timer_timeout():
	var extra_damage = max(1, int(MULTIPLIER * set_damage))
	#health_manager.change_health(-extra_damage)
	effect_manager.apply_effect("damage", extra_damage)
	end_effect()
	pass # Replace with function body.
