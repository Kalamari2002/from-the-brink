extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var xoffset = 64		# horizontal offset from character's pos where projectile will be spawned
var trigger_secondary = false
var both_pressed = false
export var projectile_path : String
var projectile
var fire_rate
var character
var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	character = self.owner
	fire_rate = get_node("FireRate")
	projectile = load(projectile_path)
	pass # Replace with function body.

func _process(delta):
	if !active:
		return
	if Input.is_action_pressed("p1_confirm") and Input.is_action_pressed("p1_special"):
		both_pressed = true
	
	if Input.is_action_just_released("p1_confirm"):
		if both_pressed:
			instantiate_projectile()
			trigger_secondary = true
		else:
			if !trigger_secondary:
				print("attack")
			else:
				trigger_secondary = false
		both_pressed = false
	
	if Input.is_action_just_released("p1_special"):
		if both_pressed:
			instantiate_projectile()
			trigger_secondary = true
		else:
			if !trigger_secondary:
				print("special")
			else:
				trigger_secondary = false
		both_pressed = false

func activate():
	active = true

func deactive():
	active = false
	fire_rate.stop()

func instantiate_projectile():
	if fire_rate.time_left != 0 or !active:
		return
	print("SECONDARY")
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
