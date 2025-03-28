extends "res://Prefabs/Abilities/MeleeBase.gd"

signal melee_attacked

func confirm_effect():
	damage_data.value = calc_damage()
	#cursor_manager.get_adversary_column().affect_quadrants("damage", damage_data) # Requests opposite column to atk the selected quadrant
	atk_count -= 1
	melee_bar.stop_charge()
	is_charging = false
	#cursor_manager.get_adversary_column().affect_quadrants("greenflame",0)
	cursor_manager.get_adversary_column().affect_on_hit_quadrants({"damage":damage_data, "greenflame":0})
	emit_signal("melee_attacked")
	if atk_count == 0:
		deactivate() # Ends attack

