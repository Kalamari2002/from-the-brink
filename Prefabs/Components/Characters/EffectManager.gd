###
# The EffectManager of a character inflicts to and removes effects from a character.
# It takes strings and interprets what effect it corresponds to. It also adds and remove
# effect icons to show when an effect is active.
###

extends Node2D

signal took_damage		# Certain effects are triggered with damage. We use this signal everytime the character is dmged.
signal healed			# Signaled when a character is healed

var health_manager		# Ref to the character's health manager

var green_flame = preload("res://Prefabs/Effects/GreenFlame.tscn")	# Green Flame effect
var hbox				# the horizontal boxed used to keep icons

# Called when the node enters the scene tree for the first time.
func _ready():
	health_manager = get_parent().get_node("HealthManager")
	hbox = get_node("EffectIcons/MarginContainer/HBoxContainer")
	pass # Replace with function body.

###
# Takes a string and adds a corresponding effect as a child.
# @param effect is a string that represents the effect to be inflicted. Set to "damage" if you just wanna damage a character
# @param arg is an int that can be used to specify any quantity associated with the effect
###
func apply_effect(effect, arg):
	print(effect + " ",arg)
	if effect == "damage":
		take_damage(arg)
	if effect == "greenflame":
		var new_green = green_flame.instance()
		add_child(new_green)
	# Else add effect as a child if not already existent
	pass

###
# Damages a character by requesting a health change from the health manager
# and signaling that the character was damaged.
# @param dmg to be dealt
###
func take_damage(dmg):
	print("damaged from effect manager")
	health_manager.change_health(-dmg)
	emit_signal("took_damage")
	pass

###
# Called by an effect, takes a TextureRect scene and adds it to the hbox.
# @param icon is the TextureRect object.
###
func add_icon(icon):
	hbox.add_child(icon)

###
# Called by an effect, removes a TextureRect from the hbox.
# @param icon is the TextureRect to be removed.
###
func remove_icon(icon):
	hbox.remove_child(icon)
	icon.queue_free()


func heal(health):
	emit_signal("healed")
	pass
	
