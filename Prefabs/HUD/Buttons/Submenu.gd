###
# A Submenu contains children MenuNodes. It acts a little different than
# a regular MenuNode, as in it must close and open submenus when selected. 
###
extends "res://Prefabs/HUD/General/MenuNode.gd"

export (NodePath) var submenu_display_path
onready var submenu_display = get_node(submenu_display_path)

func activate():
	.activate()
	submenu_display.visible = true
	align_cursor()

func deactivate():
	.deactivate()
	submenu_display.visible = false
