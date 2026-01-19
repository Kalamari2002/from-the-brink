###
# Represents a single node of a menu tree.
###

extends Node

export (NodePath) var label_path

export var option_name : String

var display

export var activated : bool

onready var option = 0
onready var cursor = self.owner.get_node("Cursor")
onready var control_scheme = self.owner.get_node("MenuControlScheme")
onready var pressed_back = false	# prevents menus from closing simultaneously when their submenus close 
func _ready():
	if not label_path.is_empty():
		display = get_node(label_path)
	pass

func _input(event):
	if not activated: 
		return

	if event.is_action_pressed(control_scheme.up):
		on_step(-1)
	elif event.is_action_pressed(control_scheme.down):
		on_step(1)
	elif event.is_action_pressed(control_scheme.confirm):
		on_confirm()
	elif event.is_action_pressed(control_scheme.special):
		pressed_back = true
	
	if event.is_action_released(control_scheme.special) and pressed_back:
		on_cancel()
		pressed_back = false
	pass

###
# Moves cursor to the option that's currently being pointed to
###
func align_cursor():
	print("Hovered: ", self)
	var child_display = get_child(option).display
	if child_display != null:
		cursor.position.y = child_display.rect_position.y
	pass

###
# Either increments or decrement the option index. Then, updates
# the cursor position. 
###
func on_step(dir : int):
	#print("step")
	if get_child_count() == 0:
		return
	option = clamp(option + dir, 0, get_child_count() - 1)
	align_cursor()
	pass

###
# Goes one menu deeper: activates submenu or option and deactivates self
###
func on_confirm():
	#print("confirm")
	get_children()[option].activate()
	deactivate()
	pass

###
# Goes back one menu: activates parent menu and deactivates self
###
func on_cancel():
	print("Back")
	get_parent().activate()
	get_parent().align_cursor()
	deactivate()
	option = 0
	pass

###
# Activates the current menu or option
###
func activate():
	if display != null:
		display.activate()
	activated = true
	pass

###
# Deactivates the current menu
###
func deactivate():
	if display != null:
		display.deactivate()
	activated = false
	pressed_back = false
	pass
