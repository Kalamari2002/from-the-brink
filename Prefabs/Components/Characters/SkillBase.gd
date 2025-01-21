extends Node2D

var character
var cooldown

func _ready():
#	character = get_parent().get_parent()
	cooldown = get_node("Cooldown")
	pass

func initialize(charactr):
	character = charactr

func trigger():
	if cooldown.time_left != 0 or !is_active():
		return
	begin()
	cooldown.start()
	pass

func begin():
	print(get_name())
	pass

func end_cooldown():
	cooldown.stop()

func is_active():
	return true
