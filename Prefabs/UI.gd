extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var p1_failure
var p2_failure

# Called when the node enters the scene tree for the first time.
func _ready():
	p1_failure = get_node("MarginContainer/p1_failure")
	p2_failure = get_node("MarginContainer/p2_failure")
	pass # Replace with function body.

func receive_message(message):
	if message == "ready_ended":
		p1_failure.text = "HP: " + String(get_node("/root/Board/Player1").get_hp())
		p2_failure.text = "HP: " + String(get_node("/root/Board/Player2").get_hp())
		
	if message == "player1_hit":
		print("UI RECEIVED MSG")
		p1_failure.text = "HP: " + String(get_node("/root/Board/Player1").get_hp())
	if message == "player2_hit":
		print("UI RECEIVED MSG")
		p2_failure.text = "HP: " + String(get_node("/root/Board/Player2").get_hp())
		#get_node("MarginContainer/p1").text = "Failure: " + String
	if message == "player1_died" or message == "player2_died":
		get_node("End").visible = true
