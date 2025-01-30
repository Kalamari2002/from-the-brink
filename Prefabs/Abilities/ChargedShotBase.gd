extends "res://Prefabs/Components/Characters/OptionBase.gd"

export var projectile_path : String
var projectile

var charge = 0

var progress_bar
# Called when the node enters the scene tree for the first time.
func _ready():
	if projectile_path == "":
		projectile = load("res://Prefabs/Components/Projectiles/Projectile.tscn")
	else:
		projectile = load(projectile_path)
	pass # Replace with function body.

func initialize(pselecter, charactr):
	.initialize(pselecter, charactr)
	progress_bar = character.get_node("CharacterDisplay/ChargeBar")

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
	progress_bar.visible = true

func deactivate():
	.deactivate()
	charge = 0
	progress_bar.visible = false

func seize():
	.seize()
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
	p.initialize(character)
	p.set_charge(charge)
	get_node("/root/Board").add_child(p)
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
