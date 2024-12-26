###
# TODO: RESET PARTICIPANTS ARRAY AFTER A QUICKTIME EVENT IS OVER
# TODO: REPLACE PARTICIPANT WITH QUICKTIMEPARTICIPANT PREFAB
###
extends Node2D

###
# QuickTimeEvent
###

signal finish
var participants = []
export var input_count : int
var is_active = false
var part = preload("res://Prefabs/Components/Characters/QuickTimeParticipant.tscn")
var canvaslayer
var side_of_caller
var subscriber
var animation_player
var has_caller_won
# Called when the node enters the scene tree for the first time.
func _ready():
	canvaslayer = get_node("QuickTimeLayer")
	subscriber = get_node("Subscriber")
	animation_player = get_node("AnimationPlayer")
	pass # Replace with function body.

func _input(event):
	#if event.is_action_pressed("ui_accept"):
		#start_quicktime(0,[87, 83, 81, 65],[73, 75, 79, 76])
	if !is_active:
		return
	if event is InputEventKey:
		#print(event.scancode)
		if event.is_pressed():
			check_input(event.scancode)
		#check_input(event.scancode)
	pass

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

func check_input(input):
	for p in participants:
		p.check_input(input)
		if p.is_finished():
			end_quicktime()
			return

func add_participant(id, scheme):
	#var new_participant = Participant.new(id,scheme)
	var new_participant = part.instance()
	new_participant.initialize(id,scheme)
	new_participant.connect("got_one_right",self,"update_label",[new_participant])
	new_participant.connect("fucked_one_up", self,"label_flash",[new_participant])
	add_child(new_participant)
	participants.append(new_participant)
	pass

func update_label(participant):
	canvaslayer.update_remaining_inputs(participant.get_id(), participant.get_remaining_inputs())

func label_flash(participant):
	canvaslayer.flash_label(participant.get_id())
	pass

func start_quicktime(side, left_scheme, right_scheme):
	if is_active:
		return
	subscriber.send_message("quick_time_start")
	side_of_caller = side
	add_participant(0,left_scheme)
	add_participant(1,right_scheme)
	generate_string()
	is_active = true
	get_node("Timer").start()
	for p in participants:
		update_label(p)

func end_quicktime():
	get_node("Timer").stop()
	print("FINISHED!")
	is_active = false
	for p in participants:
		p.determine_success(p.is_finished())
		p.clear_inputs()
	if participants[0].get_has_succeeded():
		animation_player.play("left_wins")
	elif participants[1].get_has_succeeded():
		animation_player.play("right_wins")
	else:
		animation_player.play("draw")
###
# MAKE ANIMATOR CALL THIS
###
func exit():
	has_caller_won = participants[side_of_caller].get_has_succeeded()
	participants.clear()
	subscriber.send_message("quick_time_end")
	subscriber.remove()
	emit_signal("finish")

#func announce_results():
#	for p in participants:
#		if p.get_has_succeeded():
#			print(String(p.get_id()) + " has succeeded")
#		else:
#			print(String(p.get_id()) + " has failed")
#	if has_caller_won():
#		print("CALLER WON")
#	else:
#		print("CALLER LOST")

func get_has_caller_won():
	return has_caller_won

func _on_Timer_timeout():
	end_quicktime()
	pass # Replace with function body.
	
func receive_message(message):
	pass
