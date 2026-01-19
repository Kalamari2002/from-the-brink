###
# The Character menu node is responsible for managing and displaying
# a player's options when selecting a character and color palette in the
# CharacterSelectScreen.
###
extends "res://Prefabs/HUD/General/BaseMenu.gd"

###
# Unlike a regular Base Menu, the Character menu acts when the "special" key is pressed
# while it's active. It signals the parent CharacterSelectMenu node to exit and deactivates
# itself.
###
func on_cancel():
	self.owner.exit()
	deactivate()
	pass

###
# Called by the parent CharacterSelectMenu when a player enters the game. This activates the menu node.
###
func on_enter():
	activate()
	pass
