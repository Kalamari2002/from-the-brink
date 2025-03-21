###
# Records the control scheme/input map of a player.
###
extends Node2D

var scheme = {} # The inputs and their corresponding action labels
export var up1 : String
export var down1 : String
export var confirm1 : String
export var special1 : String

export var up2 : String
export var down2 : String
export var confirm2 : String
export var special2 : String


func initialize(character: Node2D):
	var character_id = character.get_id()
	if character_id % 2 == 0:
		set_scheme(2)
	else:
		set_scheme(1)
	pass

###
# Takes action labels and maps them to inputs.
###
#func set_scheme(up,down,confirm,special):
#	scheme = {"up": up, "down": down, "confirm": confirm, "special" : special}
func set_scheme(player):
	if player == 1:
		scheme = {"up": up1, "down": down1, "confirm": confirm1, "special" : special1}
	if player == 2:
		scheme = {"up": up2, "down": down2, "confirm": confirm2, "special" : special2}
	if player == 0:
		scheme = {"up": "dummy", "down": "dummy", "confirm": "dummy", "special" : "dummy"}

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
	if scheme["up"] == "dummy":
		print("bot")
		return [-1,-2,-3,-4]
	
	var scans = []
	for i in scheme:
		scans.append(InputMap.get_action_list(scheme[i])[0].scancode)
	return scans
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
