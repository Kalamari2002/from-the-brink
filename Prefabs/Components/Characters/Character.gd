###
# A character orchestrates all its components together. Its main purpose is take inputs and react to
# GameStateManager queues.
###
extends Node2D

signal state_changed(state)
signal died
signal turn_started
signal turn_ended
signal id_assigned
signal atk_started
signal atk_ended

var game_state_manager : Node2D

enum GameState {WAITING, SELECTING, ATTACKING, ENDING, DEAD} # Determines what kinds of actions the player can take
var curr_state			# current game state of the character

var id		# Unique id assigned by the GameStateManager
var color_palette : int

onready var character_display = $CharacterDisplay
onready var control_scheme = $ControlScheme
onready var health_manager = $HealthManager
onready var effect_manager = $EffectManager
onready var position_manager = $PositionManager
onready var cursor_manager = $CursorManager
onready var selector = $Selector
onready var resource_manager = $_ResourceManager
onready var skill_manager = $SkillManager
onready var animation_manager = $AnimationManager

# Called when the node enters the scene tree for the first time.
func _ready():
	on_ready()

func on_ready():
	if id % 2 == 0:	# If even will stand on the right
		character_display.flip_self()
	color_palette = id
	
	curr_state = GameState.WAITING # Starts waiting, can't select actions but can move around
	control_scheme.initialize(self)
	health_manager.initialize(self)
	effect_manager.initialize(self)
	position_manager.initialize(self)
	cursor_manager.initialize(self)
	selector.initialize(self)
	resource_manager.initialize(self)
	skill_manager.initialize(self)
	animation_manager.initialize(self)
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

func on_game_start():
	skill_manager.enable()
	pass
func on_game_set():
	if curr_state != GameState.DEAD:
		effect_manager.set_invincibility(true)
	selector.seize()
	pass

###
# Lets character select their options. Called by the GameStateManager.
# @return 0 if player can start turn
# @return -1 if player is DEAD
###
func start_turn() -> int:
	if curr_state == GameState.DEAD:
		return -1
	#curr_state = GameState.SELECTING
	change_state(GameState.SELECTING)
	selector.activate()
	emit_signal("turn_started")
	return 0

###
# Sets character to ENDING and tells the game_state_manager that this player
# has finished their turn. This is mainly called by options via signal.
###
func end_turn():  
	change_state(GameState.ENDING)
	game_state_manager.on_turn_end()
	emit_signal("atk_ended")
	pass

func pause_control():
	position_manager.set_can_move(false)

func resume_control():
	position_manager.set_can_move(true)

###
# Sets game state to attacking. This is called on signals by attack options.
###
func start_atking():
	change_state(GameState.ATTACKING)
	game_state_manager.on_atk_start()
	emit_signal("atk_started")
	pass
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
	if curr_state == GameState.SELECTING:
		game_state_manager.skip_turn()
	change_state(GameState.DEAD)
	emit_signal("died") # Lets other objects know that this character is dead
	game_state_manager.on_character_died(id)
	selector.seize()
	pass

###
# Called by GameStateManager at the start of the game. Determines the id of this character.
###
func assign_id(id : int, game_state_manager : Node2D):
	self.id = id
	self.game_state_manager = game_state_manager
	pass

func change_state(state):
	if curr_state == GameState.DEAD:
		return false
	curr_state = state
	emit_signal("state_changed",curr_state)
	return true

###
# @return id of the character
###
###
func get_id():
	return id

func get_color_palette()->int:
	return color_palette

func get_curr_state():
	return curr_state

func _on_HealthManager_health_depleted():
	die()
	pass # Replace with function body.
