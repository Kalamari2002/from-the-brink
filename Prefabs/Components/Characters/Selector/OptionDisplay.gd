###
# A single option card that's added as a child of a Selector's Display.
# It can hide its components or change its layout to fit a character's side (flip).
###
extends Control

var panel
var texture_rect
var label
var hbox

var default_color : Color
var select_color : Color

func _ready():
	panel = get_node("MarginContainer/Panel")
	texture_rect = get_node("MarginContainer/HBoxContainer/TextureRect")
	label = get_node("MarginContainer/HBoxContainer/Label")
	hbox = get_node("MarginContainer/HBoxContainer")
	default_color = panel.get_node("ColorRect").get_frame_color()
	select_color = Color(1,0.68,0, 0.2)
	pass

###
# Called by the display when its selector belongs to a character in the right.
# Changes alignment to right aligned and makes it so that the label is positioned before the
# icon.
###
func flip():
	hbox.set_alignment(2)
	hbox.move_child(hbox.get_child(1), 0)
	pass

func get_label():
	return label

###
# Makes all of its visible components invisible.
###
func hide():
	panel.visible = false
	texture_rect.visible = false
	label.visible = false
	
###
# Makes all of its visible components visible.
###
func display():
	panel.visible = true
	texture_rect.visible = true
	label.visible = true

###
# Called by display whenever this card corresponds to the selected option.
###
func select():
	panel.get_node("ColorRect").set_frame_color(select_color)
	
func unselect():
	panel.set_frame_color(default_color)


