extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_remaining_inputs(id, string):
	if id == 0:
		get_node("MarginContainer/P1Container/participant1").text = string
	if id == 1:
		get_node("MarginContainer/P2Container/participant2").text = string
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func flash_label(id):
	if id == 0:
		get_node("MarginContainer/P1Container/AnimationPlayer").play("flash_red")
	if id == 1:
		get_node("MarginContainer/P2Container/AnimationPlayer").play("flash_red")

func _on_QuickTimeEvent_update_labels(id, inputs):
	update_remaining_inputs(id, inputs)
	pass # Replace with function body.
