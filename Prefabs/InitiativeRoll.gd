###
# InitiativeRoll displays the initiative order after the intro text is over.
# It does NOT actually shuffle anything, just displays the order set by the
# GameStateManager
###

extends CanvasLayer

var started = false # Prevents player from playing fadeout animation when they shouldn't

var players = [] # List of the name of the players to be displayed in the initiative order

func _input(event):
	if !started:
		return
	if event.is_action_pressed("ui_accept"): # Player needs to press a confirm key to proceed to the game
		play_fade_out()

###
# This is called when this object receives the broadcasted message that the intro has ended.
# It starts playing the FadeIn animation.
###
func play_fade_in():
	get_node("AnimationPlayer").play("FadeIn_Initiative")

###
# Called when the player presses a confirm key after the initiative order is fully displayed.
# Plays the FadeOut animation.
###
func play_fade_out():
	get_node("AnimationPlayer").play("FadeOut_Initiative")

###
# Called by AnimationPlayer when the FadeIn animation finishes. Lets player press the confirm
# key to proceed.
###
func finish_fade_in():
	started = true

###
# Called by the AnimationPlayer, on fadeout. It makes this layer invisible and broadcasts a message
# that the initiative roll has ended (misleading name cause the GameStateManager is the object
# that actually rolls but wtrvr). Also prevents player from playing the FadeOut animation again
# by setting started to false
##
func end_initiative_roll():
	print("end initiative")
	self.visible = false
	started = false
	get_node("Subscriber").send_message("initiative_ended")

###
# Called when this object receives the broadcasted message that the intro has ended.
# Sets writes the players' names to the labels. 
# @param players a list of strings containing the names of all players
###
func set_initiative_labels(players):
	get_node("MarginContainer/VBoxContainer/First").text = players[0]
	get_node("MarginContainer/VBoxContainer/Second").text = players[1]

###
# For Subscriber to notify this object.
# @param message String sent by Subscriber
###
func receive_message(message):
	if message == "intro_ended": # when the intro is over, that's the queue for this object to fade in
		print("fade")
		play_fade_in()
		
	###
	# "gege" is a codeword sent by the GameStateManager. When a message with these initials is sent,
	# the InitiativeRoll object knows that the message will contain the initiative order with all names
	# separated by a comma (eg., "gegePlayer1,Player2,")
	###
	if message.substr(0,4) == "gege":
		var allPlayers = message.substr(4,len(message)-4) # remove the code word from the message
		players = allPlayers.split(",")
		set_initiative_labels(players) # Separate string by comma and put all names in a list, update names
	return
