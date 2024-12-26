extends Node2D

signal got_one_right
signal fucked_one_up

var scheme
var inverse_scheme
var id
var has_succeeded
var queue = []

var freeze_cooldown = 0.3
var frozen = false

func initialize(id_i, scheme_i):
	scheme = {"up": scheme_i[0],"down": scheme_i[1],"confirm": scheme_i[2],"special": scheme_i[3]}
	inverse_scheme = {scheme_i[0]: "up", scheme_i[1]: "down", scheme_i[2]: "confirm", scheme_i[3]: "special"}
	id = id_i
	
func create_sequence(inputs_string):
	for i in inputs_string:
		queue.push_back(scheme[i])
	pass

func check_input(input):
	if frozen:
		return false
	if is_finished():
		return false
	if input == queue[0]:
		queue.pop_front()
		emit_signal("got_one_right")
		return true
	if input in get_scheme_inputs():
		emit_signal("fucked_one_up")
		freeze()
	return false

func freeze():
	frozen = true
	var time_in_seconds = 1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	frozen = false

func get_curr_input():
	return queue[0]

func get_remaining_inputs():
	#print("inverse")
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
