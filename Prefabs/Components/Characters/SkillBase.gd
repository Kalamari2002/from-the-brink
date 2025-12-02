extends Node2D

export var icon_path : String
var icon_ref
var character : Node2D
var icon : Control

onready var cooldown = $Cooldown
 
func _ready():
	icon_ref = load(icon_path)
	pass

func _process(delta):
	if cooldown.time_left != 0:
		icon.update_bar(cooldown.time_left)

func initialize(charactr):
	character = charactr
	character.connect("state_changed", self, "on_character_state_change")
	icon = icon_ref.instance()
	character.get_node("CharacterDisplay/SkillIcons").add_child(icon)
	icon.set_max_value(cooldown.wait_time)

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
	pass

func icon_make_available():
	if !is_active():
		return
	icon.available()
	pass

func icon_make_unavailable():
	icon.unavailable()
	pass

func on_character_state_change(state):
	pass

func is_active():
	return true
