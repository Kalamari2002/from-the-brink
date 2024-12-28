###
# Activates one of its children based on player's pick. Each of its children
# is an option. This class is used for testing as of now.
### 
extends Node2D

var is_selecting = false	# determines if the option selector is open or closed

var options = []			# all options which the player can choose

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children(): # each child is an option the player can select
		options.append(c)
	pass
	
func _input(event):
	if !is_selecting:
		return
	if event.is_action_pressed("option_one"):
		confirm_option(0)
	if event.is_action_pressed("option_two"):
		confirm_option(1)
	if event.is_action_pressed("option_three"):
		confirm_option(2)

###
# Calls activate() on the chosen option. Closes the selector.
# @param idx of the option chosen
###
func confirm_option(idx):
	options[idx].activate()
	close()
	
###
# Called by the character. This lets the player use the OptionSelector
# pick an atk option.
###
func open():
	print("Options open")
	is_selecting = true
	pass

###
# Stops player from using the selector until it's opened again.
###
func close():
	is_selecting = false
	pass
