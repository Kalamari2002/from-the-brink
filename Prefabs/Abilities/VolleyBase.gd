extends "res://Prefabs/Components/Characters/OptionBase.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var xoffset = 64		# horizontal offset from character's pos where projectile will be spawned
const projectile = preload("res://Prefabs/Components/Projectiles/Projectile.tscn")

var control_scheme
var duration_timer
var fire_rate			# Timer obj that determines how fast a projectile can be spammed

# Called when the node enters the scene tree for the first time.
func _ready():
	duration_timer = get_node("Duration")
	fire_rate = get_node("FireRate")

	control_scheme = character.get_node("ControlScheme")
	pass # Replace with function body.
	
###
# Doesn't take inputs if the attack isn't active.
###
func _input(event):
	if !active:
		return
	if event.is_action_pressed(control_scheme.confirm()):
		if fire_rate.time_left == 0: # only if the fire rate cooldown is over we can fire a projectile
			instantiate_projectile()
		pass

###
# Called by OptionSelector to initiate this attack. Starts the duration timer and sends signal that
# the attack has started.
###
func activate():
	.activate()
	duration_timer.start()
	pass

###
# Called when the duration timer times out to end the attack.
###
func deactivate():
	if !active:
		return
	.deactivate()
###
# Creates a projectile at the position of the character + some xoffset. As soon as a projectile is
# fired, we start the fire rate timer and we can't shoot another one until the timer is over.
###
func instantiate_projectile():
	var p = projectile.instance()
	p.position = spawn_pos()
	p.set_dir(get_dir())
	get_node("/root/Board").add_child(p)
	fire_rate.start()
	
###
# Determines if the offset should be to the left or right depending on which column the character
# is standing (projectiles fired from right column are offset to the left, projectiles fired from
# left are offset to the right).
# @return the spawn pos of the projectile
###
func spawn_pos():
	var pos = character.global_position
	pos.x += get_dir() * xoffset
	return pos

###
# Gets the direction to which the projectile should be fired (if it's fired by a character standing
# on the right column, it'll be fired to the left and vice versa)
###
func get_dir():
	if character.get_id() % 2 == 0:
		return -1
	return 1


func _on_Duration_timeout():
	deactivate()
	pass # Replace with function body.
