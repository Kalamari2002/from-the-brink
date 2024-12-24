extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_insta_atk
signal end_insta_atk
var active = false
var cursor_manager
signal insta_atk(dmg)
# Called when the node enters the scene tree for the first time.
func _ready():
	cursor_manager = get_parent().get_node("CursorManager")
	pass # Replace with function body.

func _input(event):
	if !active:
		return
	if event.is_action_pressed("select_action"):
		print("atk")
		cursor_manager.get_adversary_column().attack_quadrants(25)
		deactivate()

func activate():
	active = true
	cursor_manager.enable_cursor()
	emit_signal("start_insta_atk")
	pass
	
func deactivate():
	emit_signal("end_insta_atk")
	active = false
	cursor_manager.disable_cursor()
