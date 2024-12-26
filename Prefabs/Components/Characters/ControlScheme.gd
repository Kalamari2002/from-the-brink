extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var scheme = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_scheme(up,down,confirm,special):
	#scheme = {"up": up, "down": down, "confirm": confirm, "special" : special}
	scheme = {"up": up, "down": down, "confirm": confirm, "special" : special}
	print(InputMap.get_action_list(up)[0].scancode)
	pass

func vaxis():
	var vertical = Input.get_action_strength(scheme["up"]) - Input.get_action_strength(scheme["down"])
	return vertical

func up():
	return scheme["up"]
	
func down():
	return scheme["down"]
	
func confirm():
	return scheme["confirm"]
	
func special():
	return scheme["special"]

func get_input(input):
	return scheme[input]

func get_scheme():
	return scheme

func get_scheme_scancode():
	var scans = []
	for i in scheme:
		scans.append(InputMap.get_action_list(scheme[i])[0].scancode)
	return scans
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
