extends "res://Prefabs/Components/Characters/SkillBase.gd"

###
# I think making it so that scimitars aren't instantiated and are just a child of Aspen
# would make it easier to manage (and more practical performance wise).
###
const projectile = preload("res://Prefabs/Components/Projectiles/BondedScimitar.tscn")
var scimitar : Node2D
var position_manager : Node2D
var resource_manager : Node2D
var melee : Node2D
var melee_active = false
const BLADESONG_COST  = 1.25

func initialize(charactr):
	.initialize(charactr)
	
	melee = character.get_node("Selector").find_ability("AspenMeleeCharge")
	melee.connect("start_atk", self, "set_melee_active",[true])
	melee.connect("end_atk", self, "set_melee_active",[false])
	
	position_manager = character.get_node("PositionManager")
	resource_manager = character.get_node("ResourceManager")
	
	instantiate_projectile()
	pass

func instantiate_projectile():
	scimitar = projectile.instance()
	scimitar.position = spawn_pos()
	scimitar.connect("succeeded_catch", self, "catch_scimitar")
	get_node("/root/Board").add_child(scimitar)
	print(scimitar.get_dir())
	pass

func trigger():
	if !is_active():
		return
	begin()
	cooldown.start()
	pass
	
func begin():
	if scimitar.get_active(): # Means the scimitar is still on its trajectory
		return
	
	if melee_active: # Means Aspen is currently doing a melee attack
		if melee.get_atk_count() > 1:
			melee.decrement_atk_count()
		else:
			return
	
	if !scimitar.get_was_caught(): # If you try summoning the scimitars after failing to catch them
		if resource_manager.is_available(): # Check if you have bladesong to spend
			resource_manager.consume(BLADESONG_COST)
		else: # If not, you can't toss the scimitar
			return
	
	.begin()
	toss_scimitar()
	pass

func toss_scimitar():
	scimitar.toss(spawn_pos(), get_dir())
	pass

func set_melee_active(val):
	melee_active = val
	pass

###
# Determines if the offset should be to the left or right depending on which column the character
# is standing (projectiles fired from right column are offset to the left, projectiles fired from
# left are offset to the right).
# @return the spawn pos of the projectile
###
func spawn_pos() -> Vector2:
	var pos = character.global_position
	var offset = character.get_node("PositionManager").get_spawn_offset()
	print(offset)
	pos.x += get_dir() * offset
	return pos

###
# Called on signal after scimitar collides with the character. Instantly ends this ability's
# cooldown.
###
func catch_scimitar():
	end_cooldown()

###
# Gets the direction to which the projectile should be fired (if it's fired by a character standing
# on the right column, it'll be fired to the left and vice versa)
###
func get_dir() -> int:
	if character.get_node("PositionManager").get_is_right():
		return -1
	return 1

func is_active() -> bool:
	if character.get_curr_state() != character.GameState.ATTACKING:
		return false
	return true

func _on_Cooldown_timeout():
	scimitar.on_cooldown_end()
	pass # Replace with function body.
