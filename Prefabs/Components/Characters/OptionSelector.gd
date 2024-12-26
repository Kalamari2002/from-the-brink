extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_selecting = false

var options = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		options.append(c)
	pass # Replace with function body.
	
func _input(event):
	if !is_selecting:
		return
	if event.is_action_pressed("option_one"):
		confirm_option(0)
	if event.is_action_pressed("option_two"):
		confirm_option(1)
	if event.is_action_pressed("option_three"):
		confirm_option(2)

func confirm_option(idx):
	options[idx].activate()
	close()
	
func open():
	print("Options open")
	is_selecting = true
	pass
func close():
	is_selecting = false
	pass
