###
# The EffectManager of a character inflicts to and removes effects from a character.
# It takes strings and interprets what effect it corresponds to. It also adds and remove
# effect icons to show when an effect is active.
###

extends Node2D

signal took_damage(dmg)		# Certain effects are triggered with damage. We use this signal everytime the character is dmged.
signal healed			# Signaled when a character is healed
signal applied_effect(effect_name)
signal removed_effect(effect_name)

var health_manager : Node2D		# Ref to the character's health manager
var character : Node2D
var invulnerability : Timer
var hbox : HBoxContainer			# the horizontal boxed used to keep icons
var collision : CollisionShape2D

const GREENFLAME = preload("res://Prefabs/Effects/GreenFlame.tscn")
const BURNIN = preload("res://Prefabs/Effects/Burnin.tscn")
const MAPLED = preload("res://Prefabs/Effects/Mapled.tscn")
const BURNEDOUT = preload("res://Prefabs/Effects/Burnedout.tscn")

var effect_dict = {
	"greenflame" : GREENFLAME,
	"burnin" : BURNIN,
	"mapled" : MAPLED,
	"burnedout" : BURNEDOUT
}

var curr_effects = {}

func initialize(character:Node2D):
	self.character = character
	collision = self.character.get_node("Area2D/CollisionShape2D")
	health_manager = self.character.get_node("HealthManager")
	hbox = get_node("EffectIcons/MarginContainer/HBoxContainer")
	invulnerability = $Invulnerability
	pass

###
# Takes a string and adds a corresponding effect as a child.
# @param effect is a string that represents the effect to be inflicted. Set to "damage" if you just wanna damage a character
# @param arg is an int that can be used to specify any quantity associated with the effect
###
func apply_effect(effect, arg):
	if effect == "":
		return
	if effect == "damage":
		take_damage(arg)
		return
	if effect == "replenish_resource":
		character.get_node("_ResourceManager").replenish(arg)
		return
	if effect == "heal":
		heal(arg)
		return
	if not effect in curr_effects: # If we don't have the current effect
		var new_effect = effect_dict[effect].instance()	#add the new effect
		new_effect.initialize(self,character)
		add_child(new_effect)
		curr_effects[effect] = new_effect.get_name()	#add it to the records
		
		emit_signal("applied_effect", effect)
	else:	#otherwise
		get_node(curr_effects[effect]).reset_effect()	#we just reset the effect
	pass

###
# @param effects: a dictionary of effects with key-value being effect_name-arg
###
func apply_on_hit_effects(effects):
	if invulnerability.time_left != 0:
		return
	for e in effects:
		print("Effect: ", e)
		apply_effect(e, effects[e]) 
		pass
	pass

###
# Damages a character by requesting a health change from the health manager
# and signaling that the character was damaged.
# @param dmg to be dealt
###
func take_damage(dmg : Node):
	health_manager.damage(dmg.value)
	emit_signal("took_damage", dmg.value)
	if not dmg.ignore_invul:
		call_deferred("start_invulnerability")
	pass

func heal(health):
	health_manager.heal(health)
	emit_signal("healed")
	pass

###
# Removes the effect from the world and records
###
func remove_effect(effect):
	var key = effect.get_name().to_lower()
	curr_effects.erase(key)
	emit_signal("removed_effect",key)
	remove_icon(effect.get_icon())
	remove_child(effect)
	effect.queue_free()

func start_invulnerability():
	invulnerability.start()
	#collision.disabled = true
	pass

func end_invulnerability():
	collision.disabled = false
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

func _on_Invulnerability_timeout():
	call_deferred("end_invulnerability")
	pass
