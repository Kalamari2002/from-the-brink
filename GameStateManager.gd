###
# Manages all states of the game, from beginning/setup, to gameplay loop, to end.
# It instantiates players, keeping track of their turns and round count.
###

extends Node2D

signal game_set
signal top_of_the_round
signal passed_turn

var initiative_order = [] # A list of players, ordered by turn from first to last
var initiative_idx = 0 # Keeps track of which player in the initiative_order is going currently

var round_count = 0 # The round number, is incremented at the top of the round
var skip_intro = false # If set true, the intro lines are skipped 

var player_count = 2 # Numbers of players playing
var curr_player
var game_over = false
# Called when the node enters the scene tree for the first time.
func _ready():
	instantiate_players()
	#game_start()
	pass # Replace with function body.

###
# Creates the players, adding them to the scene, setting their Id's and names, and
# adding them to the initiative_order
###
func instantiate_players():
	var temp_player = preload("res://Prefabs/Components/Characters/Character.tscn")
	var aspen = preload("res://Prefabs/PCs/Aspen/Aspen.tscn")
	var dummy = preload("res://Prefabs/NPCs/TrainingDummy.tscn")

	var p1 = aspen.instance()
	p1.set_name("Player1")
	p1.assign_id(1)
	
	var p2 = dummy.instance()
	p2.set_name("Player2")
	p2.assign_id(2)
	
	get_node("/root/Board").call_deferred("add_child",p1)
	get_node("/root/Board").call_deferred("add_child",p2)
	initiative_order.append(p1)
	initiative_order.append(p2)
	
	for i in initiative_order:
		i.connect("turn_ended", self, "switch_turn")
		i.connect("died", self, "game_set")
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"): # lets you skip the intro
		skip_intro = true
		pass

###
# Called when the introtext broadcasts that it's ended. Doesn't really roll any numbers, 
# it just shuffles the initiative_order and then displays some Read/Fight text before 
# starting top_of_the_round. Sends a message to the InitiativeRoll containing the names
# of all players in order.
###
func roll_initiative():
	
	randomize()
	initiative_order.shuffle()
	
	var allPlayers = ""
	for i in initiative_order: # Get all nodes in the initiative order and extract their names
		var og = String(i.get_path())
		var s =  og.substr(12,(len(og) - 12))
		allPlayers += s + "," # Concatenate their names in a comma separated string
	var toBroadcast = allPlayers.substr(0,len(allPlayers) - 1)
	
	get_node("Subscriber").send_message("gege"+toBroadcast) # Broadcast initiative order, received by InitiativeRoll
	pass
	
###
# Name is self explanatory. Called every time the last player finishes their turn
# and increments the round_count. Called for first time when the Ready object broadcasts
# that the ready period thing is over
###
func top_of_the_round():
	round_count += 1
	emit_signal("top_of_the_round")
	print("\nTop of the round: ", round_count)
	pass_control_to_player(current_player())
	pass

###
# Passes the atk turn to the next player in the initiative order. If there are no
# other players in the initiative_order, we reset it and restart from the top_of_the_round
###
func switch_turn():
	print("SWITCH")
	if game_over:
		return
	initiative_idx += 1
	if initiative_idx < player_count: # Next player
		pass_control_to_player(current_player())
	else: # Reached last player, top_of_the_round
		initiative_idx = 0
		top_of_the_round()
	emit_signal("passed_turn")
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

func get_round_count():
	return round_count

func get_initiative_order():
	return initiative_order

func game_set():
	if game_over:
		return
	game_over = true
	print("ended!!!")
	emit_signal("game_set")
	var time_in_seconds = 4
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().change_scene("res://Scenes/VictoryScreen.tscn")
	
###
# To catch Broadcaster to Subscriber messages. Called by child Subscriber.
# @param message is the received message from child Subscriber
###
func receive_message(message):
	if message == "end_turn_1" or message == "end_turn_2": # If either player finishes their turn
		switch_turn() # switch to the next player
		pass
	if message == "intro_ended":
		roll_initiative()
	if message == "ready_ended":
		top_of_the_round()
	pass
