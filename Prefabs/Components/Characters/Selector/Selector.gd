###
# A selector picks and displays a character's options. To add options to a character,
# add a child 2D Node and name it "Options", and just add whatever options you need as
# a child of "Options". Each child node will be displayed as a selectable option in the
# selection menu (Display), which the player can navigate.
###

extends Node2D

signal opened_selector		# Whenever this selector is activated, signal this
signal option_picked		# Whenever an option is picked, signal this
signal go_back				# For subselectors, gives control back to the previous menu/selector

var options = []			# All selectable options in the selector
var selected_idx			# The currently selected option 
var display					# Ref to the Display child

# Dummy options are used to hide the top or bottom options when the player reaches any end of the list
var dummy_option = preload("res://Prefabs/Components/Characters/Options/DummyOption.tscn")

var active = false			# Determines if this selector can be currently navigated/selected from
var flipped = false			# True if this menu belongs to a player on the right column

var character				# Ref to the character that owns this menu
var offset = Vector2(48,-60)			# unflipped offset from character's position
var flip_offset = Vector2(-216,-60)		# flipped offset from character's position

###
# Actions passed by the character to navigate the options menu
###
var up_controls
var down_controls
var confirm_controls
var special_controls

var abilities = []
func _ready():
	print("Base")
	#active = true
	display = get_node("Display")
	character = get_parent()
	
	for c in get_node("Options").get_children():
		options.append(c)
	
	selected_idx = int( len(options)/2 ) # Starting option is the middle one
	create_cards()
	pass

func _input(event):
	if !active:
		return
	if event.is_action_pressed(up_controls):
		switch_selected(-1)
	elif event.is_action_pressed(down_controls):
		switch_selected(1)
	
	if event.is_action_released(confirm_controls):
		options[selected_idx].activate()

###
# Called by the character that owns this menu. It sets which actions
# are up, down, confirm and special to navigate this menu.
# @param up action
# @param down action
# @param confirm action
# @param special action
###
func define_control_scheme(up,down,confirm,special):
	up_controls = up
	down_controls = down
	confirm_controls = confirm
	special_controls = special

###
# Positions itself and tells the display to create one card for each option
# in the menu.
###
func create_cards():
	position = offset
	display.create_cards()

###
# Called by the character after creating the cards if they are in the right column. 
# This overwrites the offset to be the flipped offset and tells the display to flip the cards.
###
func flip_cards():
	position = flip_offset
	flipped = true
	display.flip()
###
# Lets the player navigate and pick from this selector
###
func activate():
	active = true
	display.visible = true
	emit_signal("opened_selector")
	
func deactivate():
	active = false
###
# Hides the menu and prevents the player from interacting with this selector.
###
func close():
	deactivate()
	display.visible = false
	emit_signal("option_picked")

###
# Goes up or down the option list. Update the menu/display with the new 
# selected option at the center, and neighbors on top/bottom.
# @param dir -1 = up, +1 = down
###
func switch_selected(dir):
	if selected_idx + dir >= 0 and selected_idx + dir < len(options):
		selected_idx += dir
		display.update_cards()

###
# @return the currently selected option
###
func curr_selected():
	return options[selected_idx]

###
# @return flipped
###
func is_flipped():
	return flipped

###
# @return the actions corresponding to the player's controls as a list of strings.
###
func get_control_scheme():
	return [up_controls,down_controls,confirm_controls,special_controls]

###
# Returns all the selectable abilities of a character, useful for CPU
# scripts. It clears the abilities array (in case the old list of abilities 
# has been outdated) and calls a helper function to fill it up.
# @return an array of all selectable abilities of a character.
###
func get_abilities():
	abilities.clear()
	traverse_options(self,abilities)
	return abilities
###
# Helper function for get_abilities. Recursively traverses through the selection
# tree and appends everything that belongs to the abilities group.
# @param curr is the current node we're exploring
# @param options is the array to which we'll append all abilities
###
func traverse_options(curr,options):
	if "abilities" in curr.get_groups(): # base case means the current node is a selectable ability
		options.append(curr)
		return # stops us from exploring the ability's children (which aren't selectable)
	
	###
	# If we get to this point, this must be a selector, not an ability. So we traverse
	# its abilities (Option node's children).
	###
	for c in curr.get_node("Options").get_children():
		traverse_options(c,options)

###
# Creates a list of three elements [top neighbor, currently selected option, bottom neighbor]
# and returns it. If there are no bottom or top neighbors, add a "dummy" option instead to
# the list.
# @return a list of 3 options
###
func on_display():
	var to_display = []
	
	if selected_idx > 0: # add top neighbor if there is one
		to_display.append(options[selected_idx - 1])
	elif selected_idx == 0: # otherwise add a dummy
		var new_dummy = dummy_option.instance()
		to_display.append(new_dummy)
	
	to_display.append(options[selected_idx]) # add the currently selected option
	
	if selected_idx < len(options) - 1: # add bottom neighbor if there is one
		to_display.append(options[selected_idx + 1])
	if selected_idx == len(options) - 1: # otherwise add a dummy
		var new_dummy = dummy_option.instance()
		to_display.append(new_dummy)
		
	return to_display
