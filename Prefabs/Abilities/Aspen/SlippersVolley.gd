extends "res://Prefabs/Abilities/VolleyBase.gd"

func instantiate_projectile():
	if fire_rate.time_left != 0 or !active:
		return
	var p = projectile.instance()
	p.initialize(character)
	get_node("/root/Board").add_child(p)
	fire_rate.start()
