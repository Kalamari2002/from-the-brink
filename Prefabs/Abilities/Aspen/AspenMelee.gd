extends "res://Prefabs/Abilities/InstaEffectBase.gd"

func confirm_effect():
	if !can_atk:
		return
	cursor_manager.get_adversary_column().affect_quadrants("damage",10) # Requests opposite column to atk the selected quadrant
	atk_count -= 1
	can_atk = false
	atk_rate.start()
	cursor_manager.get_adversary_column().affect_quadrants("greenflame",0)
	if atk_count == 0:
		deactivate() # Ends attack
	
