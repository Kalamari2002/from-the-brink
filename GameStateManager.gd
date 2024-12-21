###
# Manages all states of the game, from beginning/setup, to gameplay loop, to end.
# It instantiates players, keeping track of their turns and round count.
###

extends Node2D

var round_start_lines = [
	"O\' brave Heroes, kindred spirits",
	"The winds hath broughts your songs to me",
	"She hath whispered me your stories",
	"And so, I ask you again,",
	"Will you answer this call?"
] # Arcsys intro looking ass text

var initiative_order = [] # A list of players, ordered by turn from first to last
var initiative_idx = 0 # Keeps track of which player in the initiative_order is going currently

var round_count = 0 # The round number, is incremented at the top of the round
var skip_intro = false # If set true, the intro lines are skipped 

var player_count = 2 # Numbers of players playing

# Called when the node enters the scene tree for the first time.
func _ready():
	instantiate_players()
	game_start()
	pass # Replace with function body.

###
# Maybe this will have a little more to it in the future, but for now it 
# just calls read_quote()
###
func game_start():
	ready_quote()
	pass

###
# Creates the players, adding them to the scene, setting their Id's and names, and
# adding them to the initiative_order
###
func instantiate_players():
	var temp_player = preload("res://Prefabs/Player.tscn")
	
	var player_instance_a = temp_player.instance()
	player_instance_a.set_name("Player1")
	player_instance_a.initialize(1, "res://Sprites/Characters/Players/Sothro.png") # setting player1 data
	
	var player_instance_b = temp_player.instance()
	player_instance_b.set_name("Player2")
	player_instance_b.initialize(2, "res://Sprites/Characters/Players/Poko.png") # setting player2 data
	
	get_node("/root/Board").call_deferred("add_child",player_instance_a)
	get_node("/root/Board").call_deferred("add_child",player_instance_b)
	
	###
	# For now, the initiative order will be by player number.
	# It'll be shuffled later on in the roll_initiative function.
	###
	initiative_order.append(player_instance_a)
	initiative_order.append(player_instance_b)
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"): # lets you skip the intro
		skip_intro = true
		pass

###
# Reads each line from the intro quotes every 3 seconds. When lines are finished,
# roll initiative.
###
func ready_quote():
	for l in round_start_lines:
		if skip_intro:
			break
		print(l)
		var time_in_seconds = 3
		yield(get_tree().create_timer(time_in_seconds), "timeout")
	roll_initiative()

###
# Doesn't really roll any numbers, it just shuffles the initiative_order
# and then displays some Read/Fight text before starting top_of_the_round.
###
func roll_initiative():
	print('\n')
	print("Roll for Initiative...")
	var time_in_seconds_a = 3
	yield(get_tree().create_timer(time_in_seconds_a), "timeout")
	
	randomize()
	initiative_order.shuffle()

	print("Player" + String(initiative_order[0].player_id()) + " you're up!") 
	var time_in_seconds_b = 2
	yield(get_tree().create_timer(time_in_seconds_b), "timeout")
	
	print("Stand Your Ground...")
	var time_in_seconds_c = 3
	yield(get_tree().create_timer(time_in_seconds_c), "timeout")
	print("And Fight!") 
	var time_in_seconds_d = 2
	yield(get_tree().create_timer(time_in_seconds_d), "timeout")
	top_of_the_round()
	pass
	
###
# Name is self explanatory. Called every time the last player finishes their turn
# and increments the round_count
###
func top_of_the_round():
	round_count += 1
	print("\nTop of the round: ", round_count)
	pass_control_to_player(current_player())
	pass

###
# Passes the atk turn to the next player in the initiative order. If there are no
# other players in the initiative_order, we reset it and restart from the top_of_the_round
###
func switch_turn():
	initiative_idx += 1
	if initiative_idx < player_count: # Next player
		pass_control_to_player(current_player())
	else: # Reached last player, top_of_the_round
		initiative_idx = 0
		top_of_the_round()
	pass

###
# Makes a player start their atk turn.
# @param player is the player which will start their turn.
###
func pass_control_to_player(player):
	player.start_turn()
	pass

###
# The current player going
###	
func current_player():
	return initiative_order[initiative_idx]

###
# To catch Broadcaster to Subscriber messages. Called by child Subscriber.
# @param message is the received message from child Subscriber
###
func receive_message(message):
	if message == "end_turn_1" or message == "end_turn_2": # If either player finishes their turn
		switch_turn() # switch to the next player
		pass
	pass
