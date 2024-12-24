extends CanvasLayer

var p1_failure
var p2_failure

var characters = []
var labels = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_node("/root/Board/GameManager/GameStateManager").connect("game_set", self, "on_game_end")
	for c in get_node("MarginContainer").get_children():
		labels.append(c)
	for i in get_node("/root/Board/GameManager/GameStateManager").get_initiative_order():
		characters.append(i.get_node("HealthManager"))
	for i in range(len(characters)):
		characters[i].connect("health_change",self,"update_health",[i])
	pass # Replace with function body.

func get_character_hp(path):
	return get_node(path).get_curr_health()

func update_health(idx):
	labels[idx].text = "HP: " + String(characters[idx].get_curr_health())

func on_game_end():
	 get_node("End").visible = true

func receive_message(message):
	if message == "ready_ended":
		for i in range(len(characters)):
			update_health(i)
