extends Control


var progress_bar : ProgressBar
var animation_player : AnimationPlayer
export (StyleBox) var available_style
export (StyleBox) var unavailable_style
# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar = get_node("ProgressBar")
	animation_player = get_node("AnimationPlayer")
	pass # Replace with function body.

func hide():
	progress_bar.visible = false

func display():
	progress_bar.visible = true

func update_value(value):
	progress_bar.value = value

func color_unavailable():
	progress_bar.add_stylebox_override("fg",unavailable_style)

func color_available():
	progress_bar.add_stylebox_override("fg",available_style)
	pass
