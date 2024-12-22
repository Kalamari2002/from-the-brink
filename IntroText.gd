###
# This is kinda the game object that kicks off everything. It displays each intro line
# in an animation, and when the animation is over, it broadcasts a message that 
# the intro has ended. The player can skip this animation by pressing any accept key.
# Its functions are mostly called by its AnimationPlayer.
###
extends CanvasLayer

var started = false # Prevents player from skipping the animation when it's over or when it's not even playing yet

func _ready():
	play_fade_in()

func _input(event):
	if !started:
		return
	if event.is_action_pressed("ui_accept"):
		skip()

###
# Stats playing FadeIn animation and lets the player skip it.
###
func play_fade_in():
	started = true # Player can now skip
	get_node("AnimationPlayer").play("FadeIn")

###
# Stops animation and announces intro end.
###
func skip():
	get_node("AnimationPlayer").stop()
	end_intro()

###
# Makes the InitiativeRoll layer invisible and broadcasts the message that the
# intro is over. Player can't skip anymore (cause there's nothing to skip dur).
###
func end_intro():
	print("intro ended")
	self.visible = false
	started = false
	get_node("Subscriber").send_message("intro_ended")
	pass

func receive_message(message):
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
