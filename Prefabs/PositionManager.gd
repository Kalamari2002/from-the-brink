extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal player_moved(curr_position)


var curr_pos

var home_column
# Called when the node enters the scene tree for the first time.
func _ready():

	
	pass # Replace with function body.

func step(dir):
	var destination = dir + curr_pos
	if home_column.step_to_quadrant(curr_pos, destination, get_parent()):
		curr_pos = destination
		print(curr_pos)

func emit():
	print(curr_pos)

func move(dir):
	pass
	#emit signal with updated pos

func get_curr_pos():
	return curr_pos

func set_home_column(path):
	home_column = get_node(path)

func set_pos(pos):
	curr_pos = pos
	home_column.set_pos(-1,pos,get_parent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
