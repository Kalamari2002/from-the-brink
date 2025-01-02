###
# A character orchestrates all its components together. Its main purpose is take inputs and react to
# GameStateManager queues.
###
extends Node2D

signal turn_ended		# Signal is taken by GameStateManager to switch turns or end the game
signal died				# Signaled when character dies
signal id_assigned

enum GameState {WAITING, SELECTING, ATTACKING, ENDING, DEAD} # Determines what kinds of actions the player can take
var curr_state			# current game state of the character

var id		# Unique id assigned by the GameStateManager

var position_manager
var cursor_manager
var health_manager
var options_selector
var selector
var control_scheme

# Called when the node enters the scene tree for the first time.
func _ready():
	position_manager = get_node("PositionManager")
	cursor_manager = get_node("CursorManager")
	health_manager = get_node("HealthManager")
	options_selector = get_node("OptionSelector")
	selector = get_node("Selector")
	control_scheme = get_node("ControlScheme")
	
	curr_state = GameState.WAITING # Starts waiting, can't select actions but can move around
	
	if id % 2 == 0:	# If even will stand on the right
		position_manager.set_home_column("/root/Board/Quadrants/right")
		cursor_manager.set_adversary_column("/root/Board/Quadrants/left")
		control_scheme.set_scheme("p2_move_up","p2_move_down","p2_confirm","p2_special")
		selector.flip_cards()
		selector.define_control_scheme("p2_move_up","p2_move_down","p2_confirm","p2_special")
		
	else:			# If odd will stand on the left
		position_manager.set_home_column("/root/Board/Quadrants/left")
		cursor_manager.set_adversary_column("/root/Board/Quadrants/right")
		control_scheme.set_scheme("p1_move_up","p1_move_down","p1_confirm","p1_special")
		selector.define_control_scheme("p1_move_up","p1_move_down","p1_confirm","p1_special")
		
	pass # Replace with function body.
	position_manager.set_pos(1)
	emit_signal("id_assigned")
func _input(event):
	if curr_state == GameState.DEAD:
		return

	if curr_state != GameState.SELECTING: # Otherwise, if character isn't SELECTING
		if event.is_action_pressed(control_scheme.up()): # If character can move, directions are interpreted as position changes 
			position_manager.step(-1)
		if event.is_action_pressed(control_scheme.down()):
			position_manager.step(1)
	
	if event.is_action_pressed(control_scheme.up()): # Move cursor if it's active 
		cursor_manager.step(-1)
	if event.is_action_pressed(control_scheme.down()):
		cursor_manager.step(1)

###
# Lets character select their options. Called by the GameStateManager
###
func start_turn():
	if curr_state == GameState.DEAD:
		return
	curr_state = GameState.SELECTING
	selector.activate()
	print(String(get_path()) + " is selecting their action")
	pass

###
# Sets character to WAITING and stops them from selecting options. Stalls for 2 seconds
# before passing the turn to another player. Called by the GameStateManager.
###
func end_turn():
	curr_state = GameState.ENDING
	var time_in_seconds = 2
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	curr_state = GameState.WAITING
	emit_signal("turn_ended")
	print(String(get_path()) + " has ended their turn")
	pass

###
# Sets game state to attacking. This is called on signals by attack options.
###
func start_atking():
	curr_state = GameState.ATTACKING

###
# Tells health manager to decrease health by x amount.
# @param dmg amount of health damaged
###
func take_dmg(dmg):
	health_manager.change_health(-dmg)

###
# Changes game state to dead. Called by health manager signal.
###
func die():
	if curr_state == GameState.DEAD:
		return
	curr_state = GameState.DEAD
	emit_signal("died") # Lets other objects know that this character is dead

###
# Called by GameStateManager at the start of the game. Determines the id of this character.
###
func assign_id(id):
	self.id = id

###
# @return id of the character
###
func get_id():
	return id

func _on_HealthManager_health_depleted():
	die()
	pass # Replace with function body.
