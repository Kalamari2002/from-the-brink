extends "res://Prefabs/Components/Characters/SkillBase.gd"

var melee
export var projectile_path : String
var projectile
var position_manager
var curr_scimitar
var melee_active = false

func _ready():
	melee = character.get_node("Selector").find_ability("AspenMeleeCharge")
	print("MELEE PATH: " + melee.get_path())
	projectile = load(projectile_path)
	position_manager = character.get_node("PositionManager")
	character.get_node("Area2D").connect("area_entered",self,"on_area_entered")
	melee.connect("start_atk", self, "set_melee_active",[true])
	melee.connect("end_atk", self, "set_melee_active",[false])

func instantiate_projectile():
	curr_scimitar = projectile.instance()
	curr_scimitar.position = spawn_pos()
	curr_scimitar.set_dir(get_dir())
	get_node("/root/Board").add_child(curr_scimitar)

func begin():
	if melee_active:
		if melee.get_atk_count() > 1:
			melee.decrement_atk_count()
		else:
			return
	.begin()
	instantiate_projectile()

func set_melee_active(val):
	melee_active = val

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
