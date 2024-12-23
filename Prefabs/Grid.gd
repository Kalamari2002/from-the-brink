extends Node2D

###
# Quadrant is the class that represent an individual quadrant in the grid.
# Its main purpose is to keep track of the characters currently standing on it,
# and keep track of whether or not it's currently selected by a player.
###
class Quadrant:
	var selected = false # Set to true if an aim cursor is "hovering" over it (aka, being selected by a player)
	var held_characters = [] # All characters standing in this quadrant
	
	###
	# Adds a character to this quadrant (positions them)
	# @param character is the character to be added to this quadrant
	###
	func position_character(character): 
		held_characters.append(character) 
	
	###
	# Removes a character from this quadrant.
	# @param character to be removed
	###
	func remove_character(character):
		held_characters.erase(character)
	
	###
	# Sets selected to true or false.
	# @param value to set selected to
	###
	func set_selected(value):
		selected = value
	
	###
	# Damages all characters currently standing in this quadrant.
	###
	func hit_characters():
		for c in held_characters:
			c.get_hit()
	
	func damage_characters(dmg):
		for c in held_characters:
			c.take_dmg(dmg)
	
	###
	# Returns how many characters are standing in this quadrant.
	# @return character count
	###
	func get_character_count():
		return len(held_characters)
	
	###
	# Self explanatory
	# @return hur dur
	###
	func is_selected():
		return selected
	pass

###
# This is what each index in the quadrants array represents
# ["left_top","left_mid","left_bot","right_top","right_mid","right_bot"]
###

var quadrants = [] # a list of all Quadrant objects that make up the grid
var default_sprite # unslected quadrants
var selected_sprite # selected quadrants.

# Called when the node enters the scene tree for the first time.
func _ready():
	default_sprite = load("res://Sprites/Map/Testing/grid_default.png")
	selected_sprite = load("res://Sprites/Map/Testing/grid_hover.png")
	
	for i in range(6):
		quadrants.append(Quadrant.new())

###
# Called by characters. Sets the quadrant where the character will start at and moves object 
# to corresponding coords.
# @param character which will be positioned
# @param idx of the quadrant where the character will start on
###
func set_initial_pos(character, idx):
	quadrants[idx].position_character(character)
	character.position = match_quadrant(idx).global_position

###
# Removes a character from one quadrant and adds it to another. Moves object position
# to respective quadrant.
# @param character which will be moved
# @param idx_to_move is the idx of the destination quadrant
###	
func move_character(character, idx_to_move):
	quadrants[character.curr_pos_idx()].remove_character(character)
	quadrants[idx_to_move].position_character(character)
	character.position = match_quadrant(idx_to_move).global_position
	pass

###
# Used to indicate whether a quadrant is selected or not. Changes its sprite and selected variable accordingly.
# @param idx of the quadrant that's being selected or unselected
# @param value determines what the quadrant's selected will be set to, true = selected, false = unselected
###
func set_quadrant(idx, value):
	if value:
		match_quadrant(idx).get_node("Sprite").texture = selected_sprite
	else:
		match_quadrant(idx).get_node("Sprite").texture = default_sprite
	quadrants[idx].set_selected(value) 

###
# Called by characters to move their aims. Unselects previous quadrant and selects new one.
# @param from is the previous quadrant where the aim used to be (unselects)
# @param to the quadrant which the aim will move to (selects)
###
func move_quadrant(from, to):
	set_quadrant(from, false)
	set_quadrant(to, true)

###
# Called by characters after their turn. Unselects all quadrants
###
func clear_selections():
	for i in range(0,6):
		set_quadrant(i,false)

###
# Tells all characters standing on this quadrant to get fucked.
###
func confirm_insta_atk():
	for q in quadrants:
		if q.is_selected():
			#q.hit_characters()
			q.damage_characters(25)
			pass

###
# Converts an idx to the equivalent quadrant node
# @param idx of the quadrant we want to get
# @return the quadrant node that corresponds to the idx
###
func match_quadrant(idx):
	match idx:
		0:
			return get_node("left_top")
		1:
			return get_node("left_mid")
		2:
			return get_node("left_bot")
		3:
			return get_node("right_top")
		4:
			return get_node("right_mid")
		5:
			return get_node("right_bot")
