extends "res://Prefabs/Components/Characters/SkillBase.gd"

###
# I think making it so that scimitars aren't instantiated and are just a child of Aspen
# would make it easier to manage (and more practical performance wise).
###
const projectile = preload("res://Prefabs/Components/Projectiles/Scimitars.tscn")
var position_manager : Node2D
var resource_manager : Node2D
var melee : Node2D
var curr_scimitar : Node2D
var melee_active = false
var failed_catch = false
const BLADESONG_COST  = 1.25

func initialize(charactr):
	.initialize(charactr)
	
	character.get_node("Area2D").connect("area_entered",self,"on_area_entered")
	
	melee = character.get_node("Selector").find_ability("AspenMeleeCharge")
	melee.connect("start_atk", self, "set_melee_active",[true])
	melee.connect("end_atk", self, "set_melee_active",[false])
	
	position_manager = character.get_node("PositionManager")
	resource_manager = character.get_node("ResourceManager")
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print(curr_scimitar)

func trigger():
	if !is_active():
		return
	if cooldown.time_left != 0:
		if !resource_manager.is_available() or !failed_catch:
			return
		elif failed_catch:
			resource_manager.consume(BLADESONG_COST)
	begin()
	cooldown.start()
	pass

func begin():
	if melee_active:
		if melee.get_atk_count() > 1:
			melee.decrement_atk_count()
		else:
			return
	.begin()
	instantiate_projectile()

func instantiate_projectile():
	curr_scimitar = projectile.instance()
	curr_scimitar.position = spawn_pos()
	curr_scimitar.set_dir(get_dir())
	curr_scimitar.get_node("SelfDestroyTimer").connect("self_destroyed",self,"fail_catch")
	get_node("/root/Board").add_child(curr_scimitar)
	failed_catch = false
	
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

func fail_catch():
	failed_catch = true

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

func _on_Cooldown_timeout():
	failed_catch = false
	pass # Replace with function body.
