extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal turn_ended
signal died

enum GameState {WAITING, SELECTING, ATTACKING, ENDING, DEAD} # Determines what kinds of actions the player can take
var curr_state # current game state of the player

var id

var position_manager
var cursor_manager
var health_manager
var optionse_selector
var control_scheme

# Called when the node enters the scene tree for the first time.
func _ready():
	position_manager = get_node("PositionManager")
	cursor_manager = get_node("CursorManager")
	health_manager = get_node("HealthManager")
	optionse_selector = get_node("OptionSelector")
	control_scheme = get_node("ControlScheme")
	
	curr_state = GameState.WAITING # Starts waiting, can't select actions but can move around
	
	if id % 2 == 0:
		position_manager.set_home_column("/root/Board/Quadrants/right")
		cursor_manager.set_adversary_column("/root/Board/Quadrants/left")
		control_scheme.set_scheme("p2_move_up","p2_move_down","p2_confirm","p2_special")
		
	else:
		position_manager.set_home_column("/root/Board/Quadrants/left")
		cursor_manager.set_adversary_column("/root/Board/Quadrants/right")
		control_scheme.set_scheme("p1_move_up","p1_move_down","p1_confirm","p1_special")
		
	pass # Replace with function body.
	position_manager.set_pos(1)
	
func _input(event):
	if curr_state == GameState.DEAD:
		return
	if curr_state == GameState.SELECTING:
		if event.is_action_pressed(control_scheme.confirm()):
			optionse_selector.open()
		pass
	else:
		if event.is_action_pressed(control_scheme.up()):
			position_manager.step(-1)
		if event.is_action_pressed(control_scheme.down()):
			position_manager.step(1)
	
	if event.is_action_pressed(control_scheme.up()):
		cursor_manager.step(-1)
	if event.is_action_pressed(control_scheme.down()):
		cursor_manager.step(1)

func start_turn():
	curr_state = GameState.SELECTING
	print(String(get_path()) + " is selecting their action")
	pass

func end_turn():
	curr_state = GameState.ENDING
	var time_in_seconds = 2
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	curr_state = GameState.WAITING
	emit_signal("turn_ended")
	print(String(get_path()) + " has ended their turn")
	#subscriber.send_message("end_turn_" + String(player_id))
	pass

func start_atking():
	curr_state = GameState.ATTACKING

func take_dmg(dmg):
	health_manager.change_health(-dmg)

func die():
	if curr_state == GameState.DEAD:
		return
	curr_state = GameState.DEAD
	emit_signal("died")

func assign_id(id):
	self.id = id

func get_id():
	return id
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_InstaAtk_end_insta_atk():
	end_turn()
	pass # Replace with function body.

func _on_InstaAtk_start_insta_atk():
	start_atking()
	pass # Replace with function body.

func _on_HealthManager_health_depleted():
	die()
	pass # Replace with function body.

func _on_ProjectileVolley_start_volley():
	start_atking()
	pass # Replace with function body.

func _on_ProjectileVolley_end_volley():
	end_turn()
	pass # Replace with function body.

func _on_QuickTimeEventChallenge_start_qt_challenge():
	start_atking()
	pass # Replace with function body.

func _on_QuickTimeEventChallenge_end_qt_challenge():
	end_turn()
	pass # Replace with function body.
