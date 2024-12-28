###
# Every participant in a quicktime event is represented by an object of this class. It keeps track
# of the remaining inputs a participant has to go through and freezes if an incorrect input is pressed.
###
extends Node2D

signal got_one_right	# Every time the correct input is pressed this is signaled
signal fucked_one_up	# Every time the participant fucks up this is signaled

var scheme				# Control scheme of the participant. It's a (string, scancode) dictionary.
var inverse_scheme		# Gives us the input in terms of scancode. It's a (scancode, string) dicc.
var id					# Represents the side of the participant (0 = left, 1 = right)
var has_succeeded		# Determines if the participant manged to clear off all inputs in the given time
var queue = []			# Contains the remaining inputs

const FREEZE_COOLDOWN = 1	# Punishment for missing
var frozen = false			# Determines if the participant can check more inputs or not

###
# Assigns an id and control scheme for this participant.
# @param id_i is the id of the participant
# @param scheme_i is the control scheme (in scancode) of the participant
###
func initialize(id_i, scheme_i):
	scheme = {"up": scheme_i[0],"down": scheme_i[1],"confirm": scheme_i[2],"special": scheme_i[3]}
	inverse_scheme = {scheme_i[0]: "up", scheme_i[1]: "down", scheme_i[2]: "confirm", scheme_i[3]: "special"}
	id = id_i

###
# Passed down by a quick time event, records all inputs to go thru and adds them to the queue.
# @param inputs_string is a list of strings representing the inputs.
###	
func create_sequence(inputs_string):
	for i in inputs_string:
		queue.push_back(scheme[i]) # Input gets translated to scancode
	pass

###
# Takes an input and checks if it matches the current one the participant has to press. 
# If it is, pop it from the queue. If not, the participant is frozen and can't check more
# inputs for .3 seconds.
# @param input is the scancode of the input
###
func check_input(input):
	if frozen: # can't check if frozen
		return false
	if is_finished():
		return false
		
	if input == queue[0]: # correct, pop it from queue
		queue.pop_front()
		emit_signal("got_one_right")
		return true
	if input in get_scheme_inputs(): # incorrect, freeze datass
		emit_signal("fucked_one_up")
		freeze()
	return false

###
# Makes it so that the participant can't read inputs, and starts a timer. Only when the timer
# is done can the participant check inputs again.
###
func freeze():
	frozen = true
	var time_in_seconds = FREEZE_COOLDOWN
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	frozen = false

func get_curr_input():
	return queue[0]

###
# Takes all remaining inputs in the queue and translates them from scancode to input (string).
# @return a string that shows the remaining inputs in the queue
###
func get_remaining_inputs():
	var string = ""
	for i in queue:
		string += inverse_scheme[i] + " "
	return string

func clear_inputs():
	queue.clear()

func determine_success(result):
	has_succeeded = result

func get_id():
	return id

func is_finished():
	return (len(queue) == 0)

func get_has_succeeded():
	return has_succeeded

func get_scheme_inputs():
	var inputs = []
	for i in inverse_scheme:
		inputs.append(i)
	return inputs
