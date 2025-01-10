extends "res://Prefabs/Components/Projectiles/Projectile.gd"

var effect_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_origin(character):
	effect_manager = character.get_node("EffectManager")
	var position_manager = character.get_node("PositionManager")
	set_origin_quadrant(position_manager.get_curr_pos())
	get_node("ZigzagMovement").set_origin_quadrant(position_manager.get_curr_pos())

func get_effect_manager():
	return effect_manager
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
