extends Node2D

export var damage : int
var reflected = false
var instantiator


func _ready():
	get_parent().connect("got_hit",self,"collide")

func change_damage(new_dmg):
	damage = new_dmg
	
func collide(area):
	if area.is_in_group("characters"):
		if can_inflict_character(area.get_parent()):
			inflict_character(area.get_parent())
	pass # Replace with function body.

func inflict_character(character):
	character.get_node("EffectManager").apply_effect("damage", damage)
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
