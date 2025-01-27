extends "res://Prefabs/Components/Projectiles/Projectile.gd"

signal succeeded_catch

var movement : Node2D
var effect_on_collision : Node2D
var hide_timer : Timer
var collision_shape : CollisionShape2D
var active = false
var was_caught = true

func _ready():
	movement = get_node("BoomerangMovement")
	effect_on_collision = get_node("ScimitarEffectOnCollision")
	effect_on_collision.connect("caught",self,"succeed_catch")
	collision_shape = get_node("Area2D/CollisionShape2D")
	hide_timer = get_node("HideTimer")
	hide()
	pass

###
# Makes itself visible, enables its collision and starts following its trajectory.
# @param origin is the initial point from where the scimitar is tossed
# @param direction is the direction where the scimitar will be heading at first, 1 = heading right, -1 = heading left
# @return true if the toss was successful, false if it was unsuccessful
###
func toss(origin : Vector2, direction : int) -> bool:
	if active:
		return false
	active = true
	
	visible = true
	global_position = origin
	collision_shape.set_deferred("disabled",false)

	set_dir(direction)
	if direction == -1:
		get_node("Sprite").flip_h = true
		
	movement.move(direction)
	hide_timer.start()
	return true

###
# Makes itself invisible, disables its collision and stops its movement.
###
func hide():
	active = false
	collision_shape.set_deferred("disabled",true)
	movement.stop()
	hide_timer.stop()
	visible = false
	pass

###
# Called on signal when effectoncollision detects that the scimitar collided with
# a friendly character. Allows scimitar to be tossed again.
###
func succeed_catch():
	was_caught = true
	emit_signal("succeeded_catch") # Let other objects know that the scimitar has been caught
	hide()

func fail_catch():
	was_caught = false
	hide()

func on_cooldown_end():
	was_caught = true

func get_active() -> bool:
	return active

func get_was_caught() -> bool:
	return was_caught

func _on_HideTimer_timeout():
	fail_catch()
	pass