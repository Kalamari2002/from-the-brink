extends "res://Prefabs/Components/Projectiles/ProjectileComponents/EffectOnCollisionBase.gd"

export var recover_on_hit : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func inflict_character(character):
	var origin_effect_manager = damage_data.origin.get_node("EffectManager")
	if character.get_node("EffectManager").apply_on_hit_effects({"damage":damage_data}):
		origin_effect_manager.apply_effect("replenish_resource",recover_on_hit)
	pass
