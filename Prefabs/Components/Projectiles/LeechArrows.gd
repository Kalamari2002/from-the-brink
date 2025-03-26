extends "res://Prefabs/Components/Projectiles/Projectile.gd"

var effect_manager

func _ready():
	pass # Replace with function body.

func initialize(character):
	.initialize(character)
	effect_manager = character.get_node("EffectManager")
	movement.set_origin_quadrant(origin_quadrant)

func get_effect_manager():
	return effect_manager
