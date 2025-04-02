###
# InitiativeRoll displays the initiative order after the intro text is over.
# It does NOT actually shuffle anything, just displays the order set by the
# GameStateManager
###

extends CanvasLayer

signal end_initiative

export (NodePath) var ready_path

var started = false # Prevents player from playing fadeout animation when they shouldn't
var players = [] # List of the name of the players to be displayed in the initiative order

onready var ready = get_node(ready_path)
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
	emit_signal("end_initiative")
	close()

func close():
	self.visible = false
	started = false

###
# Called when this object receives the broadcasted message that the intro has ended.
# Sets writes the players' names to the labels. 
# @param players a list of strings containing the names of all players
###
func set_initiative_labels(players):
	get_node("MarginContainer/VBoxContainer/First").text = players[0]
	get_node("MarginContainer/VBoxContainer/Second").text = players[1]
