###
# Passes the player's controler to the Character menu node. Also hides and displays the
# base menu when the player enters or exits the game.
###
extends Control

export var up : String			# up key for this player's menu
export var down : String		# down key for this player's menu
export var confirm : String		# confirm key for this player's menu
export var special : String		# special key for this player's menu

export var is_playing : bool	# Determines if this player is currently in the game (has an active select menu)

onready var characters_display = $CharactersDisplay
onready var control_scheme = $MenuControlScheme
onready var menu = $Characters
onready var cursor = $Cursor

###
# Assigns key references and hides + deactivates menu if this player starts
# out of the game (ie. player 3 and player 4).
###
func _ready():
	control_scheme.up = up
	control_scheme.down = down
	control_scheme.confirm = confirm
	control_scheme.special = special
	
	if not is_playing:
		hide_base()
		menu.deactivate()
	pass

func _input(event):
	if event.is_action_pressed(control_scheme.confirm) and not is_playing:
		enter()
	pass

###
# Called when a player enters the game (presses the confirm key while out of the game).
# Activates the Character menu node, displays the base menu and declares this player as "playing".
###
func enter():
	menu.on_enter()
	show_base()
	is_playing = true

###
# Called when a player exits the game (presses special when in the character menu).
# Hides the base menu and declares this player as "not playing".
###
func exit():
	hide_base()
	is_playing = false

###
# Hides the base menu display and this menu's cursor.
###
func hide_base():
	characters_display.visible = false
	cursor.visible = false
	pass
	
###
# Shows the base menu display and its cursor.
###
func show_base():
	characters_display.visible = true
	cursor.visible = true
	pass
