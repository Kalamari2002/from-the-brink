extends Node2D

var character
var position_manager
# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent().get_parent()
	position_manager = character.get_node("PositionManager")
	pass # Replace with function body.

func random_move():
	if curr_state() == character.GameState.SELECTING or curr_state() == character.GameState.DEAD:
		return
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(-1,1)
	position_manager.step(num)

func curr_state():
	return character.get_curr_state()


func _on_Timer_timeout():
	random_move()
	pass # Replace with function body.
