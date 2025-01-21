extends "res://Prefabs/Abilities/VolleyBase.gd"

var position_manager

func initialize(pselecter, charactr):
	.initialize(pselecter,charactr)
	position_manager = character.get_node("PositionManager")
	pass

func instantiate_projectile():
	if fire_rate.time_left != 0 or !active:
		return
	var p = projectile.instance()
	p.position = spawn_pos()
	p.set_dir(get_dir())
	p.set_origin(character)
	get_node("/root/Board").add_child(p)
	fire_rate.start()
