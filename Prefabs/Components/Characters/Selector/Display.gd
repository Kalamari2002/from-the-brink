###
# Displays the options from a Selector as a list of labels and icons (cards). This
# class creates cards and can match their layout depending if a character is to the
# left or right.
###
extends Control

var vbox
var option = preload("res://Prefabs/Components/Characters/Selector/OptionDisplay.tscn")
var to_display
var selected_idx
var offset : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	vbox = get_node("VBoxContainer")
	pass # Replace with function body.

###
# Called by its selector. It tells each optiondisplay object to change its layout
# to a "flipped" layout (label first, icon second, right alignment)
###
func flip():
	for o in vbox.get_children():
		o.flip()
	pass

###
# Takes the 3 options that should be displayed in a selector and creates a card with their 
# names and icon paths. For dummy options, we hide the corresponding card.
###
func create_cards():
	rect_position = offset
	for o in get_parent().on_display():
		var new_card = option.instance()
		var card_label = new_card.get_node("MarginContainer/HBoxContainer/Label")
		
		card_label.text = o.get_name()
		
		vbox.add_child(new_card)
		
		if card_label.text == "dummy":
			new_card.hide()
			
		if o == get_parent().curr_selected():
			new_card.select()
		pass

###
# This is called every time a player changes the selected option.
# It rechecks which new options should be displayed and changes the names of the
# top, middle and bottom displayed options accordingly. Hides option if it's a dummy.
###
func update_cards():
	var on_display = get_parent().on_display()
	for i in range(len(on_display)):
		var display_label = vbox.get_child(i).get_node("MarginContainer/HBoxContainer/Label")
		if on_display[i].get_name() == "dummy":
			vbox.get_child(i).hide()
			continue
		else:
			vbox.get_child(i).display()
			display_label.text = on_display[i].get_name()
		pass
