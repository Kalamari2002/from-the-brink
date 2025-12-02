extends "res://Prefabs/Components/Characters/EffectManager.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func apply_on_hit_effects(effects) -> bool:
	if invulnerability.time_left != 0:
		return false
	print("ON HIT")
	for e in effects:
		print("Effect: ", e)
		apply_effect(e, effects[e]) 
	return true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
