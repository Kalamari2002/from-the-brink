extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal health_change
signal health_depleted
signal took_damaged
signal healed

export var max_health : int
var curr_health : int

func _ready():
	curr_health = max_health

func change_health(amount):
	
	if curr_health + amount < curr_health:
		emit_signal("took_damaged")
	elif curr_health + amount > curr_health:
		emit_signal("healed")
	
	if curr_health + amount > max_health:
		curr_health = max_health
	elif curr_health + amount <= 0:
		curr_health = 0
		print("depleted")
		emit_signal("health_depleted")
	else:
		curr_health += amount
	emit_signal("health_change")
	

func get_curr_health():
	return curr_health
