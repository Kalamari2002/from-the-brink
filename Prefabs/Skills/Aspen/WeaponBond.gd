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
	melee.connect("melee_attacked", self, "icon_make_unavailable")
	
	position_manager = character.get_node("PositionManager")
	resource_manager = character.get_node("_ResourceManager")
	
	character.connect("id_assigned", self, "instantiate_projectile")
	pass

func instantiate_projectile():
	scimitar = projectile.instance()
	scimitar.initialize(character)
	#scimitar.set_auto_catch_timer(cooldown.wait_time)
	cooldown.connect("timeout", scimitar, "on_cooldown_end")
	scimitar.connect("succeeded_catch", self, "catch_scimitar")
	get_node("/root/Board").add_child(scimitar)
	pass

func _process(delta):
	if cooldown.time_left != 0:
		icon.update_bar(cooldown.time_left)
	pass

func trigger():
	if !is_active():
		return
	begin()
	pass
	
func begin():
	if scimitar.get_active(): # Means the scimitar is still on its trajectory
		return
	
	if !scimitar.get_was_caught(): # If you try summoning the scimitars after failing to catch them
		if resource_manager.is_available(): # Check if you have bladesong to spend
			resource_manager.consume(BLADESONG_COST)
		else: # If not, you can't toss the scimitar
			return
	
	if melee_active: # Means Aspen is currently doing a melee attack
		if melee.get_atk_count() > 1:
			melee.decrement_atk_count()
			icon_make_unavailable()
		else:
			return
	
	.begin()
	toss_scimitar()
	pass

func toss_scimitar():
	scimitar.toss(character.global_position)
	cooldown.start()
	pass

func set_melee_active(val):
	melee_active = val
	pass

func end_cooldown():
	.end_cooldown()
	icon.update_bar(0)

###
# Called on signal after scimitar collides with the character. Instantly ends this ability's
# cooldown.
###
func catch_scimitar():
	end_cooldown()

func on_character_state_change(state):
	if state == character.GameState.ATTACKING:
		icon_make_available()
	else:
		icon_make_unavailable()
	pass

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
