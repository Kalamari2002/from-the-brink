###
# Column class is a set of quadrants. It's responsible for moving characters to diff
# quadrants and affecting them (be it with attacks, conditions, etc.). It creates
# a cursor that selects quadrants for specific actions.
###
extends Node2D

export var id : int
var quadrants = []		# an array of quadrants, its children.

func _ready():
	for i in self.get_children():
		quadrants.append(i)
	pass # Replace with function body.

###
# Removes a character from one quadrant and moves them to another if
# possible.
# @param from the initial quadrant idx of the moving character
# @param to the idx of the destination quadrant
# @param character requesting to be moved
# @return true if the requested movement is successful, false if not
###
func step_to_quadrant(from, to, character):
	if to < 0:
		to = 0
	if to > len(quadrants) - 1:
		to = len(quadrants) - 1
	if from == to:
		return false
	quadrants[from].remove_character(character)
	quadrants[to].position_character(character)
	return true

###
# Forces a character to move to a quadrant regardless of column bounds.
# @param from the idx of the initial quadrant of the moving character. Set to -1 if character hadn't been positioned before.
# @param to idx of the destination quadrant
# @param character that's requesting the movement.
###
func set_pos(from,to,character):
	if from != -1:
		quadrants[from].remove_character(character)
	quadrants[to].position_character(character)

###
# Changes the quadrant selected by the cursor.
# @param from is the idx of the previously selected quadrant. Set to -1 if cursor hadn't been positioned before
# @param to is the idx of the new selected quadrant.
###
func set_cursor(from, to):
	if from != -1:
		quadrants[from].unselect()
	quadrants[to].select()

###
# Checks if cursor can move to a destination quadrant, does so if possible. Similar to 
# step_to_quadrant, but for the cursor instead of characters.
# @param from is the idx of the previously selected quadrant. Set to -1 if cursor hadn't been positioned before
# @param to is the idx of the new selected quadrant.
### 
func step_cursor(from, to):
	if to < 0:
		to = 0
	if to > len(quadrants) - 1:
		to = len(quadrants) - 1
	if from == to:
		return false
	if from != -1:
		quadrants[from].unselect()
	quadrants[to].select()
	return true

###
# Damages all characters standing on the selected quadrant
# @param dmg the damage dealt
###
func attack_quadrants(dmg):
	for q in quadrants:
		if q.is_selected():
			q.damage_characters(dmg)

###
# Inflicts an effect (including damage) to all characters standing on the selected quadrant.
# @param effect is a string representing the effect
# @arg is an integer that can be dmg quantity, number of turns, among other things
###
func affect_quadrants(effect, arg):
	for q in quadrants:
		if q.is_selected():
			q.apply_effect(effect,arg)
func affect_on_hit_quadrants(effects):
	for q in quadrants:
		if q.is_selected():
			q.apply_on_hit_effects(effects)


###
# @return all characters in the column
###
func get_characters():
	var chars = []
	for q in quadrants:
		for c in q.get_held_characters():
			chars.append(c)
	return chars

###
# Unelects all quadrants.
###
func clear_cursor():
	for i in quadrants:
		i.unselect()

func get_id()->int:
	return id
