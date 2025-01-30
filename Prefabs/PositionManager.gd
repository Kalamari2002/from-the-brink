###
# This is a character component that manages a character's position. It makes requests to the
# board to move its character (parent) to different quadrants if possible.
###

extends Node2D

signal changed_quadrants

export var init_end_lag : float		# the time a character needs to wait to move again after changing quadrants
export var init_start_lag : float	# The delay between directional input and quadrant change
var curr_end_lag : float			# current end lag, may be added to/subtracted from
var curr_start_lag : float			# current start lag, may be added to/subtracted from

var curr_pos : int 					# an integer that represents the quadrant where the character is standing
									# 0 = top, 1 = mid, 2 = bottom
var destination : int				# Quadrant idx set that the character wants to move to next.

var home_column : Node2D			# reference to the column where the character is standing
var can_move = true					# determines if the position manager can make requests to the board in the first place 

var is_right : bool					# true if character is on the right column, false if not
var spawn_offset = 64				# horizontal offset for projectiles

onready var endlag = $EndLag
onready var startlag = $StartLag

func _ready():
	if init_end_lag > 0:
		curr_end_lag = init_end_lag
		endlag.wait_time = curr_end_lag
	if init_start_lag > 0:
		curr_start_lag = init_start_lag
		startlag.wait_time = curr_start_lag

###
# Checks if the character can move to a neighbor quadrant. If they can, call change_quadrant().
# If there's start lag, start the lag timer instead (which will then move the character on timeout).
# @param dir the number of quadrants that the character will move. Negative = up, positive = down.
###
func step(dir):
	if !can_move or endlag.time_left != 0 or startlag.time_left != 0:
		return
		
	destination = dir + curr_pos
	
	if curr_start_lag > 0:
		startlag.start()
		return
	
	change_quadrant()

###
# Requests a position change to the character's column. If the character has end lag, start
# the end lag timer, which will stop step() from moving the character until the timer is over.
###
func change_quadrant():
	###
	# Ask the home column if we can move to our destination. 
	# if the column lets this character move to the requested position
	###
	print(curr_end_lag)
	if curr_end_lag > 0:
		endlag.start()
	
	if home_column.step_to_quadrant(curr_pos, destination, get_parent()):
		curr_pos = destination # update the current position.
		emit_signal("changed_quadrants")
	pass

###
# Not implemented yet but the idea is that this is a step() function that lets characters loop
# through columns.
###
func move(dir):
	if !can_move:
		return
	pass

###
# Sets the time a character needs to wait to move again after changing quadrants
###
func change_end_lag(time):
	curr_end_lag += time
	endlag.wait_time = curr_end_lag

###
# Sets the delay between the time of a directional input and the actual quadrant change
###
func change_start_lag(time):
	curr_start_lag += time
	startlag.wait_time = curr_start_lag

###
# Enables or disables the character from moving. Called by certain signal receptions.
# @param perm if true lets character move, if false prevents character from moving
###
func set_can_move(perm):
	can_move = perm

###
# Determines which column to ask for position changes. Called by the character on ready.
# @param path is the world path of the column node
###
func set_home_column(path):
	home_column = get_node(path)

###
# Called by the character after they are assigned a side.
# @param val true if character is on right column, false if they're on the left
###
func set_is_right(val):
	is_right = val

###
# Forces the character to stand in a position. Called by the character at the beginning to determine
# which quadrant the character will start on.
# @param pos is the index of the quadrant where the character will be placed.
###
func set_pos(pos):
	curr_pos = pos # update curr_pos accordingly
	home_column.set_pos(-1,pos,get_parent()) # from is -1 to signal that the character hadn't been placed yet.

###
# Gets the current quadrant where the character is standing.
###
func get_curr_pos():
	return curr_pos

func get_character_pos():
	return get_parent().global_position
	
###
# @return true if character is on the right side, false if on the left
###
func get_is_right():
	return is_right

###
# Some projectiles might require an offset to be spawned. This is their reference.
###
func get_spawn_offset():
	var direction = 1
	if is_right:
		direction = -1
	return spawn_offset * direction

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

func _on_StartLag_timeout():
	change_quadrant()
	pass # Replace with function body.
