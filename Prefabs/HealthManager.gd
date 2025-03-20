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

onready var invul_timer = $Invulnerability

export var max_health : int	# determines character initial and max health from inspector

onready var curr_health = max_health
onready var invulnerable = false

const damage_text = preload("res://Prefabs/Components/UI/DamageText.tscn")

func _ready():
	connect("health_depleted",get_parent(),"die")

###
# Called by the character to either take damage or heal. Changes their health accordingly
# and sends a signal of whether the change was damage or heal, and if the health has depleted.
# @param amount by which the health will be changed.
###
func change_health(amount):
	var new_text = damage_text.instance()

	if curr_health + amount > curr_health: # heal
		emit_signal("healed")
		new_text.initialize(false, amount)
	else:
		emit_signal("took_damaged")
		new_text.initialize(true, amount)
	
	new_text.global_position = global_position
	get_node("/root/Board").add_child(new_text)
	
	if curr_health + amount > max_health: # prevent overheal
		curr_health = max_health
	elif curr_health + amount <= 0: # prevent health to go below 0 and signal that health is depleted
		curr_health = 0
		print("depleted")
		emit_signal("health_depleted")
	else:
		curr_health += amount
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
