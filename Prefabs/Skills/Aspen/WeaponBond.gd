extends "res://Prefabs/Components/Characters/SkillBase.gd"

export var projectile_path : String
var projectile
var position_manager
var curr_scimitar
func _ready():
	projectile = load(projectile_path)
	position_manager = character.get_node("PositionManager")
	character.get_node("Area2D").connect("area_entered",self,"on_area_entered")

func instantiate_projectile():
	curr_scimitar = projectile.instance()
	curr_scimitar.position = spawn_pos()
	curr_scimitar.set_dir(get_dir())
	get_node("/root/Board").add_child(curr_scimitar)

func begin():
	.begin()
	instantiate_projectile()

###
# Determines if the offset should be to the left or right depending on which column the character
# is standing (projectiles fired from right column are offset to the left, projectiles fired from
# left are offset to the right).
# @return the spawn pos of the projectile
###
func spawn_pos():
	var pos = character.global_position
	var offset = character.get_node("PositionManager").get_spawn_offset()
	print(offset)
	pos.x += get_dir() * offset
	return pos

func catch_scimitar():
	print("CAUGHT")
	end_cooldown()
	curr_scimitar.queue_free()

func on_area_entered(area):
	if curr_scimitar == null:
		return
	if area.get_parent() == curr_scimitar:
		catch_scimitar()

###
# Gets the direction to which the projectile should be fired (if it's fired by a character standing
# on the right column, it'll be fired to the left and vice versa)
###
func get_dir():
	if character.get_node("PositionManager").get_is_right():
		return -1
	return 1

func is_active():
	if character.get_curr_state() != character.GameState.ATTACKING:
		return false
	return true
