extends Control


var progress_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = get_node("ProgressBar")
	pass # Replace with function body.

func hide():
	progress_bar.visible = false

func display():
	progress_bar.visible = true

func update_value(value):
	progress_bar.value = value
