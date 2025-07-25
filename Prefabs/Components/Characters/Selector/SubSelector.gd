###
# Subselectors are selectors that go inside another selector. These are the brances of
# a selector tree. Acts like a selector, except it can take control for itself and
# go back (return control to previous selector) 
###
extends "res://Prefabs/Components/Characters/Selector/Selector.gd"

export var option_name : String		# Label text that gets shown in the parent selector
export var icon_path : String		# Path of the icon

var parent_selector : Node2D
var root_selector : Node2D

var sub_offset = Vector2(180,0)
var sub_flip_offset = Vector2(-180,0)

onready var pressed_special = false	# This is here so that if you have a nested submenu it doesn't immediately close its parent submenu when going back

###
# Called by the parent selector. Defines the selector and character that own 
# this subselector, allowing it to make connections without calling get_parent()
# and preserving the parent to child hierarchy.
###
func initialize(character : Node2D):

	display = get_node("Display")
	active = false
	
	self.character = character
	
	root_selector = character.get_node("Selector")
	parent_selector = get_parent().get_parent()

	root_selector.connect("seize", self, "on_seize")
	
	initialize_children()
	create_cards()
	
	if character.get_id() % 2 == 0:	# If even will stand on the right
		flip_cards()
	pass

func _input(event):
	if !active:
		return
	if event.is_action_pressed(special_controls):
		pressed_special = true
	if event.is_action_released(special_controls) and pressed_special:
		go_back()
		pressed_special = false

###
# Overrides the Selector create_cards method. It just overwrites the offset
# to match the subselector offset.
###
func create_cards():
	.create_cards()
	position = sub_offset
	pass

###
# Flips its cards and overwrites the offset to match the subselector offset.
###
func flip_cards():
	.flip_cards()
	position = sub_flip_offset
	pass

func activate() -> bool:
	var parent_controls = parent_selector.get_control_scheme()
	up_controls = parent_controls[0]
	down_controls = parent_controls[1]
	confirm_controls = parent_controls[2]
	special_controls = parent_controls[3]
	return .activate()

###
# @return name/label text of the option
###
func get_name():
	return option_name

###
# @return path of the icon
###
func get_icon_path():
	return icon_path

###
# For subselectors, when we pick an option, we let the root selector know which
# option was picked and then we call the close() function
###
func on_option_picked():
	root_selector.set_last_pick(options[selected_idx])
	close()
	pass

func on_seize():
	deactivate()
	display.visible = false
	pass

###
# In addition to closing themselves, subselectors also call their parent's close()
# method. So all selectors that were opened up to this point are closed, almost
# like a recursion.
###
func close():
	.close()
	pressed_special = false
	parent_selector.close()
	pass

###
# Prevents player from interacting with this subselector and
# gives control back to the parent selector.
###
func go_back():
	print("back")
	deactivate()
	display.visible = false
	parent_selector.activate()
	pass
