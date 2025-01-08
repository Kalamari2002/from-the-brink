extends "res://Prefabs/Components/Projectiles/ProjectileComponents/EffectOnCollisionBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func inflict_character(character):
	.inflict_character(character)
	character.get_node("EffectManager").apply_effect("greenflame", 0)
	pass
