extends CanvasLayer

func update_remaining_inputs(id, string):
	if id == 0:
		get_node("MarginContainer/P1Container/participant1").text = string
	if id == 1:
		get_node("MarginContainer/P2Container/participant2").text = string
	pass

func flash_label(id):
	if id == 0:
		get_node("MarginContainer/P1Container/AnimationPlayer").play("flash_red")
	if id == 1:
		get_node("MarginContainer/P2Container/AnimationPlayer").play("flash_red")

func _on_QuickTimeEvent_update_labels(id, inputs):
	update_remaining_inputs(id, inputs)
	pass # Replace with function body.
