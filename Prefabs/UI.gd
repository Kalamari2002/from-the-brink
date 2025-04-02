extends CanvasLayer

export (Resource) var player_health
export (NodePath) var hbox_path

var p1_failure
var p2_failure
var round_count
var player_turn

var characters = []
var health_labels = []
var gamestatemanager

onready var hbox = get_node(hbox_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	gamestatemanager = get_node("/root/Board/GameManager/GameStateManager")
	gamestatemanager.connect("game_set", self, "on_game_end")
	gamestatemanager.connect("top_of_the_round",self,"update_round_count")
	gamestatemanager.connect("passed_turn", self, "update_player_turn")
	
	round_count = get_node("RoundCount")
	player_turn = get_node("PlayerTurn")
	
	for i in get_node("/root/Board/GameManager/GameStateManager").get_initiative_order():
		characters.append(i)
	for i in range(len(characters)):
		var health_manager = characters[i].get_node("HealthManager")
		health_manager.connect("health_change",self,"update_health",[i])
	pass

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
	var health_manager = characters[idx].get_node("HealthManager")
	health_labels[idx].text = "Player " + String(characters[idx].get_id()) + ": " + String(health_manager.get_curr_health())

func on_game_end():
	 get_node("End").visible = true

func on_ready_ended():
	for i in range(len(characters)):
		var new_health_label = player_health.instance()
		hbox.add_child(new_health_label)
		health_labels.append(new_health_label)
		update_health(i)
	pass
