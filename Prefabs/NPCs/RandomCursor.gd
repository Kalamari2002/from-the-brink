extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var character
var cursor_manager
var active
var attack

# Called when the node enters the scene tree for the first time.
func _ready():
	character = self.owner
	pass # Replace with function body.

func activate(atk):
	print("Random cursor activated")
	active = true
	attack = atk
	get_node("ToHit").start()
	get_node("ChangeQuadrant").start()
	cursor_manager = character.get_node("CursorManager")
	pass

func deactivate():
	active = false
	get_node("ChangeQuadrant").stop()

func confirm_atk():
	attack.confirm_effect()
	deactivate()
	pass

func change_quadrant():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(-1,1)
	cursor_manager.step(num)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ChangeQuadrant_timeout():
	if !active:
		return
	change_quadrant()
	pass # Replace with function body.


func _on_ToHit_timeout():
	confirm_atk()
	pass # Replace with function body.
