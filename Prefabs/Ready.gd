###
# An unskippable text that serves to let the players prepare themselves briefly
# before the game actually starts. This layer shows up after the initiative order
# has been displayed.
###
extends CanvasLayer

signal ready_ended

###
# Called when the initative order's end is broadcasted.
###
func play_animation():
	get_node("AnimationPlayer").play("ReadyAnimation")

###
# Called by the AnimationPlayer. Broadcasts a message letting the world know
# the ready period thing is over.
###
func end_ready():
	print("end ready")
	emit_signal("ready_ended")
	get_node("Subscriber").send_message("ready_ended")

###
# u know the jist of this.
###
func receive_message(message):
	if message == "initiative_ended": # Fades in after initiative is displayed
		play_animation()
