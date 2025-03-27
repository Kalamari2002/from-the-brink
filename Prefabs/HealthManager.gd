###
# This character component keeps track of their health. It sends a signal when their health healed, took damage
# or depleted.
###

###
# TODO: ADD INVULNERABILITY ON HIT (INVULNERABILITY TIMER)
###
extends Node2D

signal health_change
signal health_depleted
signal took_damaged
signal healed

export var max_health : int	# determines character initial and max health from inspector

onready var curr_health = max_health
onready var invulnerable = false

const damage_text = preload("res://Prefabs/Components/UI/DamageText.tscn")

func initialize(character : Node2D):
	connect("health_depleted",character,"die")

###
# Called by the character's effect manager to take damage. Changes their health accordingly
# and sends a signals that the character was damaged, and if the health has depleted.
# @param damage to be taken.
###
func damage(amount : int):
	var new_text = damage_text.instance()
	
	emit_signal("took_damaged")
	new_text.initialize(true, amount)
	
	new_text.global_position = global_position
	get_node("/root/Board").add_child(new_text)
	
	curr_health -= amount
	
	if curr_health <= 0:
		curr_health = 0
		emit_signal("health_depleted")

	emit_signal("health_change")

###
# Called by the character's effect manager to heal. Changes their health accordingly
# and sends a signals that the character was healed, adjusts health so it doesn't overheal.
# @param health to be restored.
###
func heal(amount : int):
	var new_text = damage_text.instance()
	
	emit_signal("healed")
	new_text.initialize(false, amount)
	
	new_text.global_position = global_position
	get_node("/root/Board").add_child(new_text)
	
	curr_health += amount
	
	if curr_health > max_health:
		curr_health = max_health

	emit_signal("health_change")

###
# Gets the current health of the character.
# @return current health
###
func get_curr_health():
	return curr_health

func enable_invulnerability():
	invulnerable = true
func disable_invulnerability():
	invulnerable = false
