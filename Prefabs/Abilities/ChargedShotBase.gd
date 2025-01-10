extends "res://Prefabs/Components/Characters/OptionBase.gd"

var xoffset = 64		# horizontal offset from character's pos where projectile will be spawned
export var projectile_path : String
var projectile

var control_scheme
var duration_timer
var charge = 0

var progress_bar
# Called when the node enters the scene tree for the first time.
func _ready():
	duration_timer = get_node("Duration")
	progress_bar = self.owner.get_node("CharacterDisplay/ChargeBar")
	if projectile_path == "":
		projectile = load("res://Prefabs/Components/Projectiles/Projectile.tscn")
	else:
		projectile = load(projectile_path)
	control_scheme = character.get_node("ControlScheme")
	pass # Replace with function body.

func _process(delta):
	if !active:
		return
	if Input.is_action_pressed(control_scheme.confirm()):
		build_charge(delta)
		pass
	if Input.is_action_just_released(control_scheme.confirm()):
		shoot_projectile()

func activate():
	.activate()
	duration_timer.start()
	progress_bar.visible = true

func deactivate():
	.deactivate()
	charge = 0
	progress_bar.visible = false

func build_charge(delta):
	charge = clamp(charge + delta, 0, 1)
	progress_bar.value = charge * 10

func reset_charge():
	charge = 0
	progress_bar.value = 0

func shoot_projectile():
	#print(charge)
	if charge <= 0.3 or !active:
		reset_charge()
		return
	var p = projectile.instance()
	p.position = spawn_pos()
	p.set_dir(get_dir())
	get_node("/root/Board").add_child(p)
	p.set_charge(charge)
	reset_charge()
	pass
	
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
