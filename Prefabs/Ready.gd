###
# An unskippable text that serves to let the players prepare themselves briefly
# before the game actually starts. This layer shows up after the initiative order
# has been displayed.
###
extends CanvasLayer

signal ready_ended

export (NodePath) var ui_path
onready var ui = get_node(ui_path)

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
	ui.on_ready_ended()
