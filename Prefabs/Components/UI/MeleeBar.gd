extends Control

signal low
signal base
signal high
signal critical

var animation_player
export var speed : int
export var character_name : String
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = get_node("AnimationPlayer")
	animation_player.playback_speed = speed
	pass # Replace with function body.

func start_charge():
	var animation
	if character_name == "":
		animation = "charge"
	else:
		animation = "charge_"+character_name
	animation_player.play(animation)

func stop_charge():
	animation_player.stop()

func reset_charge():
	animation_player.stop()
	for c in get_node("Nuggets").get_children():
		c.visible = false
	pass

func low():
	print(1)
	emit_signal("low")

func base():
	print(2)
	emit_signal("base")
	
func high():
	print(3)
	emit_signal("high")

func critical():
	print(4)
	emit_signal("critical")
