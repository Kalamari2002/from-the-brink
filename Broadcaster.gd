###
# Broadcaster class broadcasts a String message to all of its Subscribers.
# By convention, only Subscribers send messages to the broadcaster. This class
# contains methods which Subscribers can use to add and remove themselves from 
# this Broadcaster's subscribers list.
###

extends Node2D

var subscribers = [] # Keeps track of all Subscribers

###
# Called by a Subscriber. It adds the Subscriber to the subcsribers list.
# @param subs is the Subscriber to be added
###
func add_subscriber(subs):
	subscribers.append(subs)
	print(get_parent().get_name() + " added " + subs.get_path() + ", " + String(len(subscribers)))
	pass

###
# Called by a Subcscriber. It removes the Subscriber from the subscribers list.
# @param subs is the Subscriber to be removed
###
func remove_subscriber(subs):
	var s = subs.get_path()
	subscribers.erase(subs)
	print("removed " + s + ", " + String(len(subscribers)))
	pass

###
# Sends a String message to all Subscribers in the subscribers list.
# @param message is the String to be broadcasted
###
func broadcast_message(message):
	for s in subscribers:
		s.notify(message)
		pass 
	pass
