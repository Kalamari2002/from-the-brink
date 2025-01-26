extends "res://Prefabs/Components/Projectiles/Projectile.gd"

var movement : Node2D
var collision_shape : CollisionShape2D
var active = false
var was_caught = true

func _ready():
	movement = get_node("BoomerangMovement")
	collision_shape = get_node("Area2D/CollisionShape2D")
	pass

func toss(origin : Vector2) -> bool:
	if active:
		return false
	active = true
	global_position = origin
	collision_shape.disabled = false
	movement.move()
	
	return true

func hide():
	active = false
	collision_shape.disabled = true
	movement.stop()
	pass

func succeed_catch():
	was_caught = true
	hide()

func fail_catch():
	was_caught = false
	hide()

func get_active():
	return active

func get_was_caught():
	return was_caught

func _on_HideTimer_timeout():
	fail_catch()
	pass
