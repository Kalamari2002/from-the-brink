extends "res://Prefabs/Abilities/InstaEffectBase.gd"
var firebolt_path = "res://Prefabs/Abilities/Aspen/FireBoltVolley.tscn"
var leech_path = "res://Prefabs/Abilities/Aspen/LeechArrowsVolley.tscn"
var slipper_path = "res://Prefabs/Abilities/Aspen/SlippersVolley.tscn"

var items_selector : Node2D
var damage_data : Node
var dug_quadrants = []

func initialize(pselecter, charactr):
	.initialize(pselecter,charactr)
	damage_data = $DamageData
	items_selector = character.get_node("Selector/Options/Items")
	pass

func confirm_effect():
	if !can_atk:
		return
	
	#cursor_manager.get_adversary_column().affect_quadrants("damage",damage_data) # Requests opposite column to atk the selected quadrant
	cursor_manager.get_adversary_column().affect_on_hit_quadrants({"damage":damage_data})
	scavenge_option(cursor_manager.get_curr_pos())
	
	atk_count -= 1
	can_atk = false
	atk_rate.start()
	if atk_count == 0:
		deactivate() # Ends attack
	pass
	
func scavenge_option(quadrant_idx):
	if quadrant_idx in dug_quadrants:
		return
	
	match quadrant_idx:
		0:
			items_selector.add_option(firebolt_path)
		1:
			items_selector.add_option(leech_path)
		2:
			items_selector.add_option(slipper_path)
		_:
			items_selector.add_option(firebolt_path)
	
	dug_quadrants.append(quadrant_idx)
