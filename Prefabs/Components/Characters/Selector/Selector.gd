extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var options = []
var selected_idx
var display
var dummy_option = preload("res://Prefabs/Components/Characters/Options/DummyOption.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	display = get_node("Display")
	for c in get_node("Options").get_children():
		options.append(c)
	
	selected_idx = int( len(options)/2 )
	display.create_cards()
	#print(selected_idx)
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("p1_move_up"):
		switch_selected(-1)
	elif event.is_action_pressed("p1_move_down"):
		switch_selected(1)

func switch_selected(dir):
	if selected_idx + dir >= 0 and selected_idx + dir < len(options):
		selected_idx += dir
		display.update_cards()

func curr_selected():
	return options[selected_idx]

func on_display():
	var to_display = []
	
	if selected_idx > 0:
		print("prev")
		to_display.append(options[selected_idx - 1])
	elif selected_idx == 0:
		var new_dummy = dummy_option.instance()
		to_display.append(new_dummy)
	
	to_display.append(options[selected_idx])
	print("curr")
	
	if selected_idx < len(options) - 1:
		to_display.append(options[selected_idx + 1])
		print("next")
	if selected_idx == len(options) - 1:
		var new_dummy = dummy_option.instance()
		to_display.append(new_dummy)
	print(len(to_display))
	return to_display

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
