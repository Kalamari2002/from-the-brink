extends "res://Prefabs/Effects/EffectBase.gd"

var position_manager

const INIT_COUNT = 15
var move_count
var x_offset = 20

onready var damage_data = $DamageData

func _ready():
	move_count = INIT_COUNT
	position_manager = character.get_node("PositionManager")
	position_manager.connect("changed_quadrants",self,"decrement_move_count")
	if position_manager.get_is_right():
		$MashDirectionsInstruction.position.x = 130
	else:
		$MashDirectionsInstruction.position.x = -60
	pass

func reset_effect():
	move_count = INIT_COUNT

func decrement_move_count():
	move_count -= 1
	if move_count <= 0:
		end_effect()
	pass

func _on_ToDamage_timeout():
	effect_manager.apply_effect("damage",damage_data)
	pass # Replace with function body.
