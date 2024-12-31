extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vbox
var option = preload("res://Prefabs/Components/Characters/Selector/OptionDisplay.tscn")
var to_display
var selected_idx
# Called when the node enters the scene tree for the first time.
func _ready():
	vbox = get_node("VBoxContainer")
	pass # Replace with function body.

func create_cards():
	#print(len(get_parent().on_display()))
	for o in get_parent().on_display():
		var new_card = option.instance()
		new_card.get_node("Label").text = o.get_name()
		vbox.add_child(new_card)
		if new_card.get_node("Label").text == "dummy":
			new_card.hide()
		if o == get_parent().curr_selected():
			new_card.select()
		pass

func update_cards():
	var on_display = get_parent().on_display()
	for i in range(len(on_display)):
		var display_label = vbox.get_child(i).get_node("Label")
		if on_display[i].get_name() == "dummy":
			vbox.get_child(i).hide()
			continue
		else:
			vbox.get_child(i).display()
			display_label.text = on_display[i].get_name()
		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
