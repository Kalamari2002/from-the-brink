extends Node2D
var selected = false # Set to true if an aim cursor is "hovering" over it (aka, being selected by a player)
var held_characters = [] # All characters standing in this quadrant
export var default_texture : String
export var selected_texture : String

###
# Adds a character to this quadrant (positions them)
# @param character is the character to be added to this quadrant
###
func position_character(character):
	print("position")
	character.position = self.global_position 
	held_characters.append(character)
	print("len: ", len(held_characters)) 

###
# Removes a character from this quadrant.
# @param character to be removed
###
func remove_character(character):
	held_characters.erase(character)

###
# Sets selected to true, changes sprite texture accordingly
###
func select():
	selected = true
	get_node("Sprite").texture = load("res://Sprites/Map/Testing/grid_hover.png")

func unselect():
	selected = false
	get_node("Sprite").texture = load("res://Sprites/Map/Testing/grid_default.png")

###
# Damages all characters currently standing in this quadrant.
###
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

func _on_InstaAtk_insta_atk(dmg):
	print(dmg)
