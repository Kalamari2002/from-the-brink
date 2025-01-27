extends "res://Prefabs/Components/Projectiles/ProjectileComponents/EffectOnCollisionBase.gd"

signal caught

func collide(area):
	if area.is_in_group("characters"):
		var character = area.get_parent()
		if character.get_curr_state() == character.GameState.SELECTING:
			return
		if can_inflict_character(character):
			inflict_character(character)
		else:
			emit_signal("caught")
			pass
	pass
