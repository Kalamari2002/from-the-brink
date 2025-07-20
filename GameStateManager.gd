###
# Manages all states of the game, from beginning/setup, to gameplay loop, to end.
# It instantiates players, keeping track of their turns and round count.
###

extends Node2D

signal game_set
signal game_started
signal top_of_the_round
signal passed_turn

export (NodePath) var intro_text_path
export (NodePath) var initiative_roll_path
export (NodePath) var ready_path

var pre_game_state = 0

var initiative_order = [] # A list of players, ordered by turn from first to last
var teams = {}
var initiative_idx = 0 # Keeps track of which player in the initiative_order is going currently

var round_count = 0 # The round number, is incremented at the top of the round
var skip_intro = false # If set true, the intro lines are skipped 

var player_count = 4 # Numbers of players playing
var curr_player
var game_over = false

onready var intro_text = get_node(intro_text_path)
onready var initiative_roll = get_node(initiative_roll_path)
onready var ready = get_node(ready_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	instantiate_players()
	get_node("/root/Board/Control/Ready").connect("ready_ended",self,"start_game")
	
	initiative_roll.connect("end_initiative", self, "proceed_game_state")
	
	intro_text.connect("end_intro", self, "proceed_game_state")
	intro_text.play_fade_in()
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"): # lets you skip the intro
		proceed_game_state()
		pass

###
# Creates the players, adding them to the scene, setting their Id's and names, and
# adding them to the initiative_order
###
func instantiate_players():
	var temp_player = preload("res://Prefabs/Components/Characters/Character.tscn")
	var aspen = preload("res://Prefabs/PCs/Aspen/Aspen.tscn")
	var raouss = preload("res://Prefabs/PCs/Raouss/Raouss.tscn")
	var dummy = preload("res://Prefabs/NPCs/TrainingDummy.tscn")

	var p1 = aspen.instance()
	p1.set_name("Player1")
	p1.assign_id(1, self)
	
	var p2 = aspen.instance()
	p2.set_name("Player2")
	p2.assign_id(2, self)
	
	var p3 = aspen.instance()
	p3.set_name("Player3")
	p3.assign_id(3, self)
	
	var p4 = aspen.instance()
	p4.set_name("Player4")
	p4.assign_id(4, self)
	
	get_node("/root/Board").call_deferred("add_child",p1)
	get_node("/root/Board").call_deferred("add_child",p2)
	get_node("/root/Board").call_deferred("add_child",p3)
	get_node("/root/Board").call_deferred("add_child",p4)
	
	initiative_order.append(p4)
	initiative_order.append(p1)
	initiative_order.append(p2)
	initiative_order.append(p3)
	
	for i in initiative_order:
		connect("game_started",i,"on_game_start")
	teams = {
		1 : [2, [1,3]],
		2 : [2, [2,4]]
	}
	pass

func proceed_game_state():
	if pre_game_state > 2:
		return
	match(pre_game_state):
		0:
			intro_text.close()
			roll_initiative()
			initiative_roll.play_fade_in()
			pass
		1:
			initiative_roll.play_fade_out()
			pass
		2:
			ready.play_animation()
	pre_game_state += 1
	pass

###
# Called when the introtext broadcasts that it's ended. Doesn't really roll any numbers, 
# it just shuffles the initiative_order and then displays some Read/Fight text before 
# starting top_of_the_round. Sends a message to the InitiativeRoll containing the names
# of all players in order.
###
func roll_initiative():
	var players = []
	for i in initiative_order: # Get all nodes in the initiative order and extract their names
		players.append(i.get_name())
	initiative_roll.set_initiative_labels(players)
	pass
	
func start_game():
	emit_signal("game_started")
	top_of_the_round()
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

func start_quick_time_event():
	for i in initiative_order:
		i.pause_control()
	pass

func end_quick_time_event():
	for i in initiative_order:
		i.resume_control()
	pass

###
# Attempts to make a player start their atk turn. If they can't, switch turn to the next player
# in the initiative order
# @param player is the player which will start their turn.
###
func pass_control_to_player(player):
	if player.start_turn() != 0:
		switch_turn()
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

###
# Called directly by a character when they die. Subtracts from the player's respective
# "alive" headcount, if all players in a team are dead, end game.
###
func on_character_died(character_id : int):
	if character_id % 2 != 0:
		teams[1][0] -= 1
	else:
		teams[2][0] -= 1

	if teams[1][0] == 0 or teams[2][0] == 0:
		game_set()
	else:
		var character = initiative_order[initiative_idx]
		if character.curr_state == character.GameState.DEAD:
			switch_turn()
	pass

###
# Called directly by a character when they end their turn
###
func on_turn_ended():
	switch_turn()

func game_set():
	if game_over:
		return
	game_over = true
	print("ended!!!")
	emit_signal("game_set")
	var time_in_seconds = 4
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().change_scene("res://Scenes/VictoryScreen.tscn")
