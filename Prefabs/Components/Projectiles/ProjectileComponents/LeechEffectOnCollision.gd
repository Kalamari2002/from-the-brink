extends "res://Prefabs/Components/Projectiles/ProjectileComponents/EffectOnCollisionBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func inflict_character(character):
	character.get_node("EffectManager").apply_effect("damage", damage)
	get_parent().get_effect_manager().apply_effect("heal",damage)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
