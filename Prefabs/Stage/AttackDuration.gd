extends Label
var timer
var counting
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	pass # Replace with function body.
func _process(delta):
	if !counting:
		return
	text = str(int(timer.time_left))

func start(time):
	counting = true
	visible = true
	timer.start(time)

func stop():
	counting = false
	timer.stop()
	visible = false

func hide():
	counting = false
	visible = false

func _on_Timer_timeout():
	hide()
	pass # Replace with function body.
