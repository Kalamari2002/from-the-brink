extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var panel
var texture_rect
var label
var default_color : Color
var select_color : Color
# Called when the node enters the scene tree for the first time.
func _ready():
	panel = get_node("Panel")
	texture_rect = get_node("TextureRect")
	label = get_node("Label")
	default_color = panel.get_node("ColorRect").get_frame_color()
	select_color = Color(1,0.68,0, 0.2)
	pass # Replace with function body.

func hide():
	panel.visible = false
	texture_rect.visible = false
	label.visible = false

func select():
	panel.get_node("ColorRect").set_frame_color(select_color)
	
func unselect():
	panel.set_frame_color(default_color)

func display():
	panel.visible = true
	texture_rect.visible = true
	label.visible = true
