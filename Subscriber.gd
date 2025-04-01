####
# Subscribers class listens and sends messages to the broadcaster in the board scene. 
# It's effectively a mediator pattern implementation that makes communication among objects
# and the GameStateManager easier. Use this by attaching it as a child to an object and including
# a receive_message(message) method in it (this is where you determine how the parent will interpret)
# the message.
###
extends Node2D

var broadcaster #Broadcaster object with which it will establish a communication
export var testing : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	if testing:
		return
	broadcaster = get_node("/root/Board/GameManager/Broadcaster")
	broadcaster.add_subscriber(self) #adds itself as a listener
	pass # Replace with function body.
	
###
# Called by the broadcaster. Passes on the received message to the parent of this subscriber.
# @param message is the String which will be passed on to the object using this Subscriber
###
func notify(message):
	get_parent().receive_message(message)
	pass

###
# Broadcasts a message
# @param message is the String which will be sent to the broadcaster
###
func send_message(message):
	broadcaster.broadcast_message(message)
	pass

func remove():
	broadcaster.remove_subscriber(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
