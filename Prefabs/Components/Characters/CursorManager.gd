###
# This component lets the character create a curors at the adversary column with
# which they can attack or apply effects to adversary quadrants.
###

extends Node2D

var active = false			# determines if cursor can behave/act or not
var curr_pos				# current position of the cursor
var adversary_column		# ref to the adversary column

func initialize(character):
	curr_pos = 0 # by default, cursor starts at the top quadrant of the adversary column
	var character_id = character.get_id()
	if character_id % 2 == 0:
		set_adversary_column("/root/Board/Quadrants/left")
	else:
		set_adversary_column("/root/Board/Quadrants/right")
	pass

###
# Displays cursor position and makes it active. Called by attack options.
###
func enable_cursor():
	active = true
	adversary_column.set_cursor(-1,curr_pos)

###
# Hides cursor and makes it unactive. Called by attack options.
###
func disable_cursor():
	active = false
	adversary_column.clear_cursor()

###
# Very similar to the position manager. It requests to the adversary column to move the cursor to 
# another quadrant.
# @param dir the number of quadrants to move the cursor. Negative = up, positive = down.
###
func step(dir):
	if !active:
		return
	var destination = dir + curr_pos
	if adversary_column.step_cursor(curr_pos, destination): # if adversary column lets cursor move to requested quadrant
		curr_pos = destination # update the current position of the cursor

func get_curr_pos():
	return curr_pos

###
# Determines in which column the cursor will be at. Called by the character on ready.
# @param path of the column where we'll deploy the cursor
###
func set_adversary_column(path):
	adversary_column = get_node(path)

###
# Returns the adversary column.
# @return adversary column (duh)
###
func get_adversary_column():
	return adversary_column
