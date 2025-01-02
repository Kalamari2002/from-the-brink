extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal took_damage
signal healed

var health_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	health_manager = get_parent().get_node("HealthManager")
	pass # Replace with function body.

func apply_effect(effect, arg):
	print(effect + " ",arg)
	if effect == "damage":
		take_damage(arg)
	# Else add effect as a child if not already existent
	pass

func clear_effect(effect):
	# Remove effect from children
	pass
	
func take_damage(dmg):
	print("damaged from effect manager")
	health_manager.change_health(-dmg)
	emit_signal("took_damage")
	pass

func heal(health):
	emit_signal("healed")
	pass
	
