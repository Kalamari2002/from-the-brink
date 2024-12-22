extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#play_animation()
	pass # Replace with function body.

func play_animation():
	get_node("AnimationPlayer").play("ReadyAnimation")

func end_ready():
	print("end ready")
	get_node("Subscriber").send_message("ready_ended")

func receive_message(message):
	if message == "initiative_ended":
		play_animation()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
