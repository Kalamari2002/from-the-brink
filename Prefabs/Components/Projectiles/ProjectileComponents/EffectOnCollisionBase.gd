extends Node2D

export var damage : int
var init_damage
export var effect : String
export var arg : int
var reflected = false
var instantiator


func _ready():
	init_damage = damage
	get_parent().connect("got_hit",self,"collide")

func multiply_damage(mult):
	damage = int(damage*mult) 

func restore_damage():
	damage = init_damage

func collide(area):
	if area.is_in_group("characters"):
		var character = area.get_parent()
		if character.get_curr_state() == character.GameState.SELECTING:
			return
		if can_inflict_character(character):
			inflict_character(character)
	pass

func inflict_character(character):
	if damage != 0:
		character.get_node("EffectManager").apply_effect("damage", damage)
	character.get_node("EffectManager").apply_effect(effect, arg)
	pass

func can_inflict_character(character):
	var char_position_manager = character.get_node("PositionManager")
	if char_position_manager.get_is_right():
		if get_parent().get_dir() == -1 and !reflected:
			return false
	else:
		if get_parent().get_dir() == 1 and !reflected:
			return false
	return true
		

func self_destroy():
	queue_free()
