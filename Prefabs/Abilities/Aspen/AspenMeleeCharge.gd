extends "res://Prefabs/Abilities/MeleeBase.gd"

func confirm_effect():
	cursor_manager.get_adversary_column().affect_quadrants("damage", calc_damage()) # Requests opposite column to atk the selected quadrant
	atk_count -= 1
	melee_bar.stop_charge()
	is_charging = false
	cursor_manager.get_adversary_column().affect_quadrants("greenflame",0)
	if atk_count == 0:
		deactivate() # Ends attack

