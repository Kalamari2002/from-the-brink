extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal quadrant_effect(effect,value)

var active = false
var curr_pos
var adversary_column_path
var adversary_column

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_pos = 0
	pass # Replace with function body.

func enable_cursor():
	active = true
	adversary_column.set_cursor(-1,curr_pos)

func disable_cursor():
	active = false
	adversary_column.clear_cursor()
	
func step(dir):
	if !active:
		return
	var destination = dir + curr_pos
	if adversary_column.step_cursor(curr_pos, destination):
		curr_pos = destination
		print(curr_pos)

func set_adversary_column(path):
	adversary_column = get_node(path)

func get_adversary_column():
	return adversary_column
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
