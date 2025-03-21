extends Node2D

signal depleted

export var display_name : String
var display : Control

var character : Node2D

var depleted = false
export var MAX_VALUE : int
export var is_capped : bool
var curr_value

func initialize(character:Node2D):
	self.character = character
	curr_value = MAX_VALUE
	display = character.get_node("CharacterDisplay/" + display_name)
	display.update_value(curr_value)

func consume(val):
	if depleted:
		return
	curr_value = clamp(curr_value - val, 0, MAX_VALUE)
	if curr_value == 0:
		depleted = true
		print("depleted")
		emit_signal("depleted")
	display.update_value(curr_value)

func replenish(val):
	if is_capped:
		curr_value = clamp(curr_value + val, 0, MAX_VALUE)
	else:
		curr_value += val
	
	if curr_value > 0:
		depleted = false
	display.update_value(curr_value)

func get_remaining_resource():
	return curr_value

func get_max_value():
	return MAX_VALUE

func is_available():
	return !depleted
