extends "res://Prefabs/Components/Projectiles/SelfDestroyTimer.gd"

signal self_destroyed

func self_destroy():
	emit_signal("self_destroyed")
	.self_destroy()

