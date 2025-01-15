extends "res://Prefabs/Components/Projectiles/ProjectileComponents/EffectOnCollisionBase.gd"

export var recover_on_hit : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func inflict_character(character):
	character.get_node("EffectManager").apply_effect("damage", damage)
	get_parent().get_effect_manager().apply_effect("replenish_resource",recover_on_hit)
	pass
