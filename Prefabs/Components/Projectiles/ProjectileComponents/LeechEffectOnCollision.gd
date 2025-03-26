extends "res://Prefabs/Components/Projectiles/ProjectileComponents/EffectOnCollisionBase.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func inflict_character(character):
	var origin_effect_manager = damage_data.origin.get_node("EffectManager")
	character.get_node("EffectManager").apply_effect("damage", damage_data)
	origin_effect_manager.apply_effect("heal",damage_data.value)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
