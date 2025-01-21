extends "res://Prefabs/Components/Characters/OptionBase.gd"

export var projectile_path : String
var projectile

var fire_rate			# Timer obj that determines how fast a projectile can be spammed
var init_fire_rate
const HASTE_FACTOR = 0.7
# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate = get_node("FireRate")
	init_fire_rate = fire_rate.wait_time
	
	if projectile_path == "":
		projectile = load("res://Prefabs/Components/Projectiles/Projectile.tscn")
	else:
		projectile = load(projectile_path)
	pass # Replace with function body.

###
# Doesn't take inputs if the attack isn't active.
###
func _process(delta):
	if !active:
		return
	if Input.is_action_pressed(control_scheme.confirm()):
		instantiate_projectile()

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
	if fire_rate.time_left != 0 or !active:
		return
	var p = projectile.instance()
	p.position = spawn_pos()
	p.set_dir(get_dir())
	get_node("/root/Board").add_child(p)
	fire_rate.start()

func hasten():
	fire_rate.wait_time *= HASTE_FACTOR

func unhaste():
	fire_rate.wait_time = init_fire_rate

###
# Determines if the offset should be to the left or right depending on which column the character
# is standing (projectiles fired from right column are offset to the left, projectiles fired from
# left are offset to the right).
# @return the spawn pos of the projectile
###
func spawn_pos():
	var pos = character.global_position
	var xoffset = character.get_node("PositionManager").get_spawn_offset()
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
