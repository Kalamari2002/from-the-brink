extends CanvasLayer

var p1_failure
var p2_failure
var round_count
var player_turn

var characters = []
var labels = []
var gamestatemanager
# Called when the node enters the scene tree for the first time.
func _ready():
	gamestatemanager = get_node("/root/Board/GameManager/GameStateManager")
	gamestatemanager.connect("game_set", self, "on_game_end")
	gamestatemanager.connect("top_of_the_round",self,"update_round_count")
	gamestatemanager.connect("passed_turn", self, "update_player_turn")
	
	round_count = get_node("RoundCount")
	player_turn = get_node("PlayerTurn")
	
	for c in get_node("MarginContainer").get_children():
		labels.append(c)
	for i in get_node("/root/Board/GameManager/GameStateManager").get_initiative_order():
		characters.append(i.get_node("HealthManager"))
	for i in range(len(characters)):
		characters[i].connect("health_change",self,"update_health",[i])
	pass # Replace with function body.

func get_character_hp(path):
	return get_node(path).get_curr_health()

func update_round_count():
	round_count.text = "Round: " + String(gamestatemanager.get_round_count())
	update_player_turn()
	pass

func update_player_turn():
	player_turn.text = gamestatemanager.current_player().get_name() + ", you're up!"
	pass

func update_health(idx):
	labels[idx].text = "HP: " + String(characters[idx].get_curr_health())

func on_game_end():
	 get_node("End").visible = true

func on_ready_ended():
	for i in range(len(characters)):
		update_health(i)
	pass
