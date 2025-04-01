###
# A character orchestrates all its components together. Its main purpose is take inputs and react to
# GameStateManager queues.
###
extends Node2D

signal turn_started
signal turn_ended		# Signal is taken by GameStateManager to switch turns or end the game
signal died				# Signaled when character dies
signal id_assigned
signal state_changed(state)

enum GameState {WAITING, SELECTING, ATTACKING, ENDING, DEAD} # Determines what kinds of actions the player can take
var curr_state			# current game state of the character

var id		# Unique id assigned by the GameStateManager

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
		
	curr_state = GameState.WAITING # Starts waiting, can't select actions but can move around
	control_scheme.initialize(self)
	health_manager.initialize(self)
	effect_manager.initialize(self)
	position_manager.initialize(self)
	cursor_manager.initialize(self)
	selector.initialize(null,self)
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

###
# Lets character select their options. Called by the GameStateManager
###
func start_turn():
	if curr_state == GameState.DEAD:
		return
	#curr_state = GameState.SELECTING
	change_state(GameState.SELECTING)
	selector.activate()
	emit_signal("turn_started")
	print(String(get_path()) + " is selecting their action")
	pass

###
# Sets character to WAITING and stops them from selecting options. Stalls for 2 seconds
# before passing the turn to another player. Called by the GameStateManager.
###
func end_turn():
	#curr_state = GameState.ENDING
	change_state(GameState.ENDING)
	var time_in_seconds = 2
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	if !change_state(GameState.WAITING):
		return
	emit_signal("turn_ended")
	print(String(get_path()) + " has ended their turn")
	pass

func pause_control():
	position_manager.set_can_move(false)

func resume_control():
	position_manager.set_can_move(true)

###
# Sets game state to attacking. This is called on signals by attack options.
###
func start_atking():
	#curr_state = GameState.ATTACKING
	change_state(GameState.ATTACKING)

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
	#curr_state = GameState.DEAD
	change_state(GameState.DEAD)
	selector.seize_selector()
	emit_signal("died") # Lets other objects know that this character is dead

###
# Called by GameStateManager at the start of the game. Determines the id of this character.
###
func assign_id(id):
	self.id = id

func change_state(state):
	if curr_state == GameState.DEAD:
		return false
	curr_state = state
	emit_signal("state_changed",curr_state)
	return true

###
# @return id of the character
###
func get_id():
	return id

func get_curr_state():
	return curr_state

func _on_HealthManager_health_depleted():
	die()
	pass # Replace with function body.
