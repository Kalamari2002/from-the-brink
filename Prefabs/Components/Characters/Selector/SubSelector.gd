###
# Subselectors are selectors that go inside another selector. These are the brances of
# a selector tree. Acts like a selector, except it can take control for itself and
# go back (return control to previous selector) 
###
extends "res://Prefabs/Components/Characters/Selector/Selector.gd"

export var option_name : String		# Label text that gets shown in the parent selector
export var icon_path : String		# Path of the icon
var parent_selector
var sub_offset = Vector2(180,0)
var sub_flip_offset = Vector2(-180,0)
func _ready():
	active = false
	parent_selector = get_parent().get_parent()
	connect("opened_selector", parent_selector, "deactivate")
	connect("option_picked", parent_selector, "close")
	connect("go_back", parent_selector, "activate")
	parent_selector.connect("seize", self, "seize_selector")
	pass # Replace with function body.

func _input(event):
	if !active:
		return
	if event.is_action_pressed(special_controls):
		go_back()

###
# Overrides the Selector create_cards method. It just overwrites the offset
# to match the subselector offset.
###
func create_cards():
	.create_cards()
	position = sub_offset

###
# Flips its cards and overwrites the offset to match the subselector offset.
###
func flip_cards():
	.flip_cards()
	position = sub_flip_offset

func activate():
	if parent_selector.is_flipped():	# If the parent belongs to a character on the right, we flip this subselector's cards too/
		flip_cards()
	var parent_controls = parent_selector.get_control_scheme()
	up_controls = parent_controls[0]
	down_controls = parent_controls[1]
	confirm_controls = parent_controls[2]
	special_controls = parent_controls[3]
	.activate()
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
# Prevents player from interacting with this subselector and
# gives control back to the parent selector.
###
func go_back():
	print("back")
	deactivate()
	display.visible = false
	emit_signal("go_back")
