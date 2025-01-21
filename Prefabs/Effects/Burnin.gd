extends "res://Prefabs/Effects/EffectBase.gd"

var position_manager

const INIT_COUNT = 3
var move_count

# Called when the node enters the scene tree for the first time.
func _ready():
	move_count = INIT_COUNT
	position_manager = character.get_node("PositionManager")
	position_manager.connect("changed_quadrants",self,"decrement_move_count")
	pass # Replace with function body.

func reset_effect():
	move_count = INIT_COUNT

func decrement_move_count():
	move_count -= 1
	if move_count <= 0:
		end_effect()
	pass

func _on_ToDamage_timeout():
	effect_manager.apply_effect("damage",1)
	pass # Replace with function body.
