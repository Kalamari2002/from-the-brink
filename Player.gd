extends Node2D

var subscriber # child subscriber
var player_id = 0 # The unique id of this player

var failures_curr = 0 #TBI
var successes_curr = 0 #TBI
var is_stabilized = false #TBI
var is_attack_over = true # if this is set to false, the player can't start another attack mid turn and has to wait for it to end
var curr_state # current game state of the player

var min_grid_idx # determines which is the top-most quadrant that this player can occupy
var max_grid_idx # determines which is the bottom-most quadrant they can occupy
var curr_pos # current quadrant this player is occupying

var min_aim_idx # top-most quadrant this player can aim at
var max_aim_idx # bottom-most quadrant this player can aim at
var aim_pos # current quadrant player is aiming at

###
# WAITING: lets player move around, default state
# SELECTING: stops player from moving, directional inputs scroll thru options instead
# ATTACKING: set to after selecting an attack, lets player aim
# ENDING: set to right after player finishes attack, prevents player from starting another attack
# DEAD: self explanatory
###
enum GameState {WAITING, SELECTING, ATTACKING, ENDING, DEAD} # Determines what kinds of actions the player can take
enum Conditions {INSPIRED, POLYMORPHED, SLOW, HASTED} # Inflicted statuses

var grid # Grid object which keeps track of selected/aimed quadrants and where each player is

func _ready():
	curr_state = GameState.WAITING # Starts waiting, can't select actions but can move around
	subscriber = get_node("Subscriber")
	grid = get_node("/root/Board/Grid")
	grid.set_initial_pos(self,curr_pos) # This is called after initialize, where curr_pos is calculated
	pass

###
# Called by the GameStateManager, sets the data specific to this player obejct.
# @param id is the player number, ranging from 1-2 rn, possibly more later
# @param sprite is the path string from which the player sprite will be loaded
###
func initialize(id, sprite):
	player_id = id
	if id % 2 == 0:
		get_node("Sprite").flip_h = true
	get_node("Sprite").texture = load(sprite)
	if player_id % 2 == 0: # Players with even ID will be positioned in the right column
		# Right quadrants, position: 3 - 5
		min_grid_idx = 3
		max_grid_idx = 5
		
		# Aim quadrants are just the opposite qudrants from position
		min_aim_idx = 0
		max_aim_idx = 2
	else: # Players with odd ID will be positioned in the left column
		min_grid_idx = 0
		max_grid_idx = 2
		
		min_aim_idx = 3
		max_aim_idx = 5

	var pos = (max_grid_idx + min_grid_idx)/2 # Starting at the middle quadrant
	curr_pos = pos
	aim_pos = min_aim_idx

###
# Called by the GameStateManager, lets player select their next move. This
# changes the player's state to SELECTING.
###
func start_turn():
	curr_state = GameState.SELECTING
	print(String(get_path()) + " is selecting their action")
	pass

func _input(event):
	if curr_state == GameState.SELECTING:
		if event.is_action_pressed("select_action"): # placeholder, mainly for debug
			print("attack")
			attack()
	elif curr_state == GameState.ATTACKING:
		if event.is_action_pressed("select_action"): # confirm attack
			confirm_attack()
		if event.is_action_pressed("p"+String(player_id())+"_move_up"): # control aim
			move_aim(-1)
		if event.is_action_pressed("p"+String(player_id())+"_move_down"):
			move_aim(1)
	else:
		if event.is_action_pressed("p"+String(player_id())+"_move_up"): # control position
			move(-1)
		if event.is_action_pressed("p"+String(player_id())+"_move_down"):
			move(1)

###
# Ends player's turn. Sets current game state to be WAITING and broadcasts a message
# letting other objects in the scene know that this player has finished its turn.
###
func end_turn():
	curr_state = GameState.WAITING
	is_attack_over = true
	###I'm not rly sure why but this prevents players from ending their turn and starting another simultaneously
	yield(get_tree(), "idle_frame") ### wait for the next frame to be drawn before executing this
	
	print(String(get_path()) + " has ended their turn")
	subscriber.send_message("end_turn_" + String(player_id))
	pass

###
# Sets up player state and attack_over before letting player aim.
###
func attack():
	curr_state = GameState.ATTACKING
	is_attack_over = false
	start_insta_atk()
	pass

###
# Tells grid to display the aim, makes the current quadrant that the player is aiming at
# be selected. 
###
func start_insta_atk():
	grid.set_quadrant(aim_pos, true)
	pass

###
# Tells grid to damage all characters in selected quadrants then clears off the board
# from selected quadrants (all quadrants are unselected). Finishes this player's turn
# shortly after
###
func confirm_attack():
	grid.confirm_insta_atk()
	grid.clear_selections()
	curr_state = GameState.ENDING
	
	var time_in_seconds = 2
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	end_turn()

###
# Checks if player can move in the input direction. If so, tell grid to add this player to
# the quadrant they're moving to, update current position.
# @param dir the direction in which the player is moving. -1 moves the character up, 1 moves the character
# down.
###
func move(dir):
	var newPos = curr_pos + dir
	if newPos >= min_grid_idx and newPos <= max_grid_idx:
		grid.move_character(self,newPos)
		curr_pos = newPos

###
# Very similar to move function, except we're moving the aim.
# @param dir the direction in which the aim is moving. -1 moves the aim up, 1 moves the aim down. 
###
func move_aim(dir):
	var newPos = aim_pos + dir
	if newPos >= min_aim_idx and newPos <= max_aim_idx:
		grid.move_quadrant(aim_pos, newPos)
		aim_pos = newPos

###
# Called by the grid if player is standing in a quadrant that's being attacked by an opponent.
###
func get_hit():
	print(String(get_path()) + " was hit!")
###
# Gets the player's id.
# @return player_id
###
func player_id():
	return player_id

###
# Gets the current quadrant where this player is standing.
# @return the current quadrant
###
func curr_pos_idx():
	return curr_pos

###
# To catch Broadcaster to Subscriber messages. Called by child Subscriber.
# @param message is the received message from child Subscriber
###
func receive_message(message):
	#print(String(self.get_path()) + " received the message: " + message)
	pass
