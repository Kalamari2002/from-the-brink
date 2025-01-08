###
# Represents an effect like a buff or debuff. It decrements its duration either at the start
# or end of the inflicted's turn, and wears off when the duration hits 0. An effect is activated
# by being added as a child to the effect manager of a character.
###

extends Node2D

export var init_duration : int # effectively how many of the inflicted's turns this effect lasts for
var duration

export var decrement_type : int # 0 means the duration decrements at the start of the inflicted's turn, 1 means it decrements at the end
var character

export var icon_name : String
var path_conc = "res://Prefabs/Effects/TextureRects/"
var effect_manager # parent effect manager.

var icon


func _ready():
	character = get_parent().get_parent()
	effect_manager = character.get_node("EffectManager")
	
	var temp_icon = load(path_conc + icon_name + ".tscn") # setting logo
	icon = temp_icon.instance()
	effect_manager.add_icon(icon) # adds an effect icon above the character
	
	duration = init_duration
	print("under effect")
	if decrement_type == 0: # setting the decrement type just connects the decrement function to the respective character turn signal
		character.connect("turn_started", self, "decrement")
	if decrement_type == 1:
		character.connect("turn_ended", self, "decrement")
	pass # Replace with function body.

###
# Decrements the remaining duration of the effect. If it hits 0,
# the effect is over.
###
func decrement():
	print("effect decremented")
	duration -= 1
	if duration <= 0:
		end_effect()

###
# Effect ends by removing its icon and itself from the effect manager. Then it kills itself.
###
func end_effect():
	print("effect over")
	effect_manager.remove_icon(icon)
	effect_manager.remove_child(self)
	self.queue_free()
	pass
