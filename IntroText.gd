###
# This is kinda the game object that kicks off everything. It displays each intro line
# in an animation, and when the animation is over, it broadcasts a message that 
# the intro has ended. The player can skip this animation by pressing any accept key.
# Its functions are mostly called by its AnimationPlayer.
###
extends CanvasLayer

signal end_intro

var started = false # Prevents player from skipping the animation when it's over or when it's not even playing yet

export (NodePath) var game_state_manager_path
export (NodePath) var initiative_roll_path

onready var game_state_manager = get_node(game_state_manager_path)
onready var initiative_roll = get_node(initiative_roll_path)

func _ready():
	#play_fade_in()
	pass

func _input(event):
	if !started:
		return
	if event.is_action_pressed("ui_accept"):
		close()
		pass

###
# Stats playing FadeIn animation and lets the player skip it.
###
func play_fade_in():
	started = true # Player can now skip
	get_node("AnimationPlayer").play("FadeIn")

###
# Stops animation and announces intro end.
###
func close():
	get_node("AnimationPlayer").stop()
	self.visible = false
	started = false

###
# Makes the InitiativeRoll layer invisible and broadcasts the message that the
# intro is over. Player can't skip anymore (cause there's nothing to skip dur).
###
func end_intro():
	print("intro ended")
	self.visible = false
	started = false
	emit_signal("end_intro")
	#game_state_manager.roll_initiative()
	pass
