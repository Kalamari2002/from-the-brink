extends Node2D

var subscriber # child subscriber
var player_id = 0 # The unique id of this player

var failures_curr = 0 #TBI
var successes_curr = 0 #TBI
var is_stabilized = false #TBI
var curr_state # current game state of the player

enum GameState {WAITING, SELECTING, ATTACKING, DEAD}
enum Conditions {INSPIRED, POLYMORPHED, SLOW, HASTED}

func _ready():
	curr_state = GameState.WAITING # Starts waiting, can't select actions but can move around
	subscriber = get_node("Subscriber")
	pass

###
# Called by the GameStateManager
###
func initialize(id):
	player_id = id

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
		if event.is_action_pressed("select_action"):
			print("attack")
			attack()

###
# Ends player's turn. Sets current game state to be WAITING and broadcasts a message
# letting other objects in the scene know that this player has finished its turn.
###
func end_turn():
	curr_state = GameState.WAITING
	
	###I'm not rly sure why but this prevents players from ending their turn and starting another simultaneously
	yield(get_tree(), "idle_frame") ### wait for the next frame to be drawn before executing this
	
	print(String(get_path()) + " has ended their turn")
	subscriber.send_message("end_turn_" + String(player_id))
	pass
	
func attack():
	curr_state = GameState.ATTACKING
	### attack
	end_turn()
	pass

###
# Gets the player's id.
# @return player_id
###
func player_id():
	return player_id

###
# To catch Broadcaster to Subscriber messages. Called by child Subscriber.
# @param message is the received message from child Subscriber
###
func receive_message(message):
	#print(String(self.get_path()) + " received the message: " + message)
	pass
