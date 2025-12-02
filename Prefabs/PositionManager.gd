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
var character : Node2D

var can_move = true					# determines if the position manager can make requests to the board in the first place 

var is_right : bool					# true if character is on the right column, false if not
var spawn_offset = 64				# horizontal offset for projectiles

var endlag : Timer
var startlag : Timer

func initialize(character : Node2D):
	endlag = $EndLag
	startlag = $StartLag
	
	if init_end_lag > 0:
		curr_end_lag = init_end_lag
		endlag.wait_time = curr_end_lag
	if init_start_lag > 0:
		curr_start_lag = init_start_lag
		startlag.wait_time = curr_start_lag
	
	self.character = character
	
	var id = self.character.get_id()
	if id % 2 == 0:	# If even will stand on the right
		set_home_column("/root/Board/Quadrants/right")
		set_is_right(1)
	else:			# If odd will stand on the left
		set_home_column("/root/Board/Quadrants/left")
		set_is_right(0)
	set_pos(1)
	pass

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
	if curr_end_lag > 0:
		endlag.start()
	
	if home_column.step_to_quadrant(curr_pos, destination, character):
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
	print("SET_CAN_MOVE")
	can_move = perm

###
# Determines which column to ask for position changes. Called by the character on ready.
# @param path is the world path of the column node
###
func set_home_column(path):
	home_column = get_node(path)

func get_home_column() -> Node2D:
	return home_column

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
	home_column.set_pos(-1,pos,character) # from is -1 to signal that the character hadn't been placed yet.

###
# Gets the current quadrant where the character is standing.
###
func get_curr_pos() -> int:
	return curr_pos

func get_character_pos():
	return character.global_position
	
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

func _on_StartLag_timeout():
	change_quadrant()
	pass # Replace with function body.
