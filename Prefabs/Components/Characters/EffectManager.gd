###
# The EffectManager of a character inflicts to and removes effects from a character.
# It takes strings and interprets what effect it corresponds to. It also adds and remove
# effect icons to show when an effect is active.
###

extends Node2D

signal took_damage(dmg)		# Certain effects are triggered with damage. We use this signal everytime the character is dmged.
signal applied_effect(effect_name)
signal removed_effect(effect_name)
signal healed			# Signaled when a character is healed
signal invulnerability_start

var health_manager : Node2D		# Ref to the character's health manager
var character : Node2D
var invulnerability : Timer
var hbox : HBoxContainer			# the horizontal boxed used to keep icons

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
	health_manager = self.character.get_node("HealthManager")
	hbox = get_node("EffectIcons/MarginContainer/HBoxContainer")
	invulnerability = $Invulnerability
	pass

###
# Takes a string and adds a corresponding effect as a child. Ignores invulnerability if called 
# on its own (useful for passive damage effects and non-attack effects).
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
# Used to damage/inflict effects on the character by hitting them (thru a melee or
# projectile attack). This function checks for the current invulnerability timer, 
# and applies effect to the character only if they aren't invulnerable.
# @param effects: a dictionary of effects with {key : value} being {"effect name" : arg}
# @return false if the effect doesn't go through (character was invulnerable)
# @return true if the effect goes through (character was vulnerable)
###
func apply_on_hit_effects(effects) -> bool:
	if invulnerability.time_left != 0:
		return false
	print("ON HIT")
	for e in effects:
		print("Effect: ", e)
		apply_effect(e, effects[e]) 
	return true

###
# Damages a character by passing the damage value to the health manager and signaling 
# that the character was damaged. If source doesn't ignore invulnerability, start the
# invulnerability timer.
# @param damage_data object for the damage source
###
func take_damage(dmg : Node):
	health_manager.damage(dmg.value)
	emit_signal("took_damage", dmg.value)
	if not dmg.ignore_invul:
		call_deferred("start_invulnerability")
	pass

###
# Heals a character by
###
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

###
# Called when taken damage by a source that doesn't ignore invulnerability. Starts
# the invulnerability timer.
###
func start_invulnerability():
	emit_signal("invulnerability_start")
	invulnerability.start()
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
