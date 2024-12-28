###
# This is a character component that manages a character's position. It makes requests to the
# board to move its character (parent) to different quadrants if possible.
###

extends Node2D

var curr_pos		# an integer that represents the quadrant where the character is standing
					# 0 = top, 1 = mid, 2 = bottom

var home_column		# reference to the column where the character is standing
var can_move = true	# determines if the position manager can make requests to the board in the first place 

###
# Moves a character an X number of quadrants up or down if the character is currently allowed to move. 
# Step prevents characters from looping across the column.
# @param dir the number of quadrants that the character will move. Negative = up, positive = down.
###
func step(dir):
	if !can_move:
		return
	var destination = dir + curr_pos
	
	###
	# Ask the home column if we can move to our destination. 
	# if the column lets this character move to the requested position
	###
	if home_column.step_to_quadrant(curr_pos, destination, get_parent()):
		curr_pos = destination # update the current position.

###
# Not implemented yet but the idea is that this is a step() function that lets characters loop
# through columns.
###
func move(dir):
	if !can_move:
		return
	pass

###
# Gets the current quadrant where the character is standing.
###
func get_curr_pos():
	return curr_pos

###
# Determines which column to ask for position changes. Called by the character on ready.
# @param path is the world path of the column node
###
func set_home_column(path):
	home_column = get_node(path)

###
# Forces the character to stand in a position. Called by the character at the beginning to determine
# which quadrant the character will start on.
# @param pos is the index of the quadrant where the character will be placed.
###
func set_pos(pos):
	curr_pos = pos # update curr_pos accordingly
	
	# set_post(from, to, character to move)
	home_column.set_pos(-1,pos,get_parent()) # from is -1 to signal that the character hadn't been placed yet.

###
# Enables or disables the character from moving. Called by certain signal receptions.
# @param perm if true lets character move, if false prevents character from moving
###
func set_can_move(perm):
	can_move = perm

###
# When a quick time event starts, no character can move. Characters regain movement when a quick time event
# ends.
###
func receive_message(message):
	if message == "quick_time_start":
		set_can_move(false)
	if message == "quick_time_end":
		set_can_move(true)
	pass
