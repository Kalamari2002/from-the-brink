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
		if can_inflict_character(area.get_parent()):
			inflict_character(area.get_parent())
	pass # Replace with function body.

func inflict_character(character):
	if damage != 0:
		character.get_node("EffectManager").apply_effect("damage", damage)
	character.get_node("EffectManager").apply_effect(effect, arg)
	pass

func can_inflict_character(character):
	if character.get_id() % 2 == 0:
		if get_parent().get_dir() == -1 and !reflected:
			return false
	else:
		if get_parent().get_dir() == 1 and !reflected:
			return false
	return true
		

func self_destroy():
	queue_free()
