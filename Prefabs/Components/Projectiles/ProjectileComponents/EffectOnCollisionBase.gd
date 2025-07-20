extends Node2D

export var effect : String
export var arg : int

var base_damage : int

var reflected = false

var instantiator
var parent_projectile : Node2D
var damage_data : Node

func _ready():
	#get_parent().connect("got_hit",self,"collide")
	pass

func initialize(parent_projectile):
	self.parent_projectile = parent_projectile
	self.parent_projectile.connect("got_hit",self,"collide")	
	damage_data = self.parent_projectile.get_node_or_null("DamageData")
	base_damage = damage_data.value
	pass
	
func multiply_damage(mult):
	damage_data.value = int(base_damage * mult) 
	pass
	
func restore_damage():
	damage_data.value = base_damage
	pass
	
func on_reflect():
	reflected = !reflected
	pass
func set_reflected(val:bool):
	reflected = val
	pass

func collide(area : Area2D):
	print("COLLIDE: ")
	if area.is_in_group("characters"):
		print("character")
		var character = area.get_parent()
		if character.get_curr_state() == character.GameState.SELECTING:
			return
		if can_inflict_character(character):
			inflict_character(character)
	pass

func inflict_character(character : Node2D):
	character.get_node("EffectManager").apply_on_hit_effects({"damage":damage_data, effect:arg})
	pass

func can_inflict_character(character : Node2D)->bool:
	var position_manager = character.get_node("PositionManager")
	print("Home Column id: ", position_manager.get_home_column().get_id())
	print("Target Column: ", damage_data.target_column)
	if position_manager.get_home_column().get_id() == damage_data.target_column:
		return (true && !reflected)
	return (false || reflected)

func self_destroy():
	queue_free()
	pass
