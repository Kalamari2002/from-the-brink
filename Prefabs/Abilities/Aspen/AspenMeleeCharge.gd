extends "res://Prefabs/Abilities/MeleeBase.gd"

func confirm_effect():
	.confirm_effect()
	cursor_manager.get_adversary_column().affect_quadrants("greenflame",0)
