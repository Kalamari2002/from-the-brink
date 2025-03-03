extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var damage : int
var reflected = false
var instantiator

func _ready():
	get_parent().connect("got_hit",self,"collide")

func change_damage(new_dmg):
	damage = new_dmg

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func collide(area):
	if area.is_in_group("characters"):
		if can_damage_character(area.get_parent()):
			area.get_parent().get_node("EffectManager").apply_effect("damage", damage)
	pass # Replace with function body.

func can_damage_character(character):
	if character.get_id() % 2 == 0:
		if get_parent().get_dir() == -1 and !reflected:
			return false
	else:
		if get_parent().get_dir() == 1 and !reflected:
			return false
	return true
		

func self_destroy():
	queue_free()
