###
# This class starts a contested quicktime event. Two control schemes are passed in, and one is assigned
# to the caller. Creates a list of QuickTimeEventParticipant's to represent each contestant. At the end 
# of the event, this object determines if the caller won or not. 
###
extends Node2D


signal finish				# Signals when the quick time event exits
var participants = []		# List of QuickTimeEventParticipants that keep track of the contestants
export var input_count : int	# Number of inputs in the time event
var is_active = false			# Doesn't start taking inputs until it's set to active
var part = preload("res://Prefabs/Components/Characters/QuickTimeParticipant.tscn")	# Participant
var canvaslayer			# To display the inputs
var side_of_caller		# Integer that determines which column the caller is at (0 = left, 1 = right)
var subscriber			# To announce to participants' respective objects that the contest is over
var animation_player	# Ref to animation player
var has_caller_won		# true if the caller finishes the event before the target, false if otherwise

func _ready():
	canvaslayer = get_node("QuickTimeLayer")
	subscriber = get_node("Subscriber")
	animation_player = get_node("AnimationPlayer")
	pass # Replace with function body.

func _input(event):
	if !is_active:
		return
	if event is InputEventKey:
		if event.is_pressed():
			check_input(event.scancode) # Check the code of the input key
	pass

###
# This is the function you call to start the quicktime event. It takes the side of the caller,
# a left and right scheme and add the participants with those args. Starts the timer and becomes
# active.
# @param side of the caller (0 = left , 1 = right)
# @param left_scheme is an array of scancodes of the left input map/scheme
# @param right_scheme is an array of scancodes of the right input map/scheme
###
func start_quicktime(side, left_scheme, right_scheme):
	if is_active:
		return
	subscriber.send_message("quick_time_start") # signals broadly that a quick time has started
	
	side_of_caller = side
	add_participant(0,left_scheme)
	add_participant(1,right_scheme)
	
	generate_string()
	
	is_active = true
	
	get_node("Timer").start()
	for p in participants:
		update_label(p)

###
# Generates a random string of inputs that the participants must get right. This is done
# with random integer values, where 0 = up, 1 = down, 2 = confirm and 3 = special key.
# At the end, the generated string is passed to the participant.
###
func generate_string():
	var rng = RandomNumberGenerator.new()
	
	var sequence = []
	for i in range(input_count):
		rng.randomize()
		var num = rng.randi_range(0,3)
		match num:
			0:
				sequence.append("up")
			1:
				sequence.append("down")
			2:
				sequence.append("confirm")
			3:
				sequence.append("special")
	
	for p in participants:
		p.create_sequence(sequence)

###
# Takes a key scancode and checks if it matches the input that any of the contestants
# must currently press. If one of the participants finishes the sequence with this input, 
# the quick itme results are set.
# @param input the scancode of the input key
###
func check_input(input):
	for p in participants:
		p.check_input(input)
		if p.is_finished():
			end_quicktime()

###
# Adds a QuickTimeEventParticipant to the list of contestants. It connects signals
# to the input labels so that it updates everytime a participant gets an input right.
# @param id is the side of the QuickTimeEventParticipant. 0 = left, 1 = right
# @param scheme is a list of scancodes representing the particpant's scheme: [up,down,confirm,special]
###
func add_participant(id, scheme):
	var new_participant = part.instance()
	new_participant.initialize(id,scheme)
	
	new_participant.connect("got_one_right",self,"update_label",[new_participant])
	new_participant.connect("fucked_one_up", self,"label_flash",[new_participant])
	
	add_child(new_participant)
	participants.append(new_participant)
	pass

###
# Called when a participant signals that they got an input right.
# @param participant is the QuickTimeEventParticipant that got the input right 
###
func update_label(participant):
	canvaslayer.update_remaining_inputs(participant.get_id(), participant.get_remaining_inputs())

###
# Called when a participants signals that they missed an input. Makes the input label become
# red for as long as the participant can't input.
# @param particpant
###
func label_flash(participant):
	canvaslayer.flash_label(participant.get_id())
	pass

###
# This is called either when time's up or when one of the participants finish their inputs.
# This method determines whether each participant succeeded or not and makes the correspondent
# label blink for feedback.  
###
func end_quicktime():
	get_node("Timer").stop()
	is_active = false
	
	for p in participants: # determine the success of each participants, clear the remaining inputs
		p.determine_success(p.is_finished())
		p.clear_inputs()

	if participants[0].get_has_succeeded():
		animation_player.play("left_wins")
	elif participants[1].get_has_succeeded():
		animation_player.play("right_wins")
	else:
		animation_player.play("draw")
###
# This function actually ends the quick time after the results are determined at end_quicktime(). 
# This is where we determine if the caller won or not. Called by animator.
###
func exit():
	has_caller_won = participants[side_of_caller].get_has_succeeded()
	participants.clear()
	subscriber.send_message("quick_time_end")
	subscriber.remove()
	emit_signal("finish")

func get_has_caller_won():
	return has_caller_won

func _on_Timer_timeout():
	end_quicktime()
	pass # Replace with function body.
	 
func receive_message(message):
	pass
