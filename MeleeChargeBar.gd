extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var nugget_low
export (PackedScene) var nugget_base
export (PackedScene) var nugget_high
export (PackedScene) var nugget_critical

var nugget_type = []
var type_idx = 0
var vbox
var idx = 0

var decrementing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	setup([5,14,18,20])
	pass # Replace with function body.

func setup(multiplier_range):
	nugget_type.append(nugget_low)
	nugget_type.append(nugget_base)
	nugget_type.append(nugget_high)
	nugget_type.append(nugget_critical)
	vbox = get_node("MarginContainer/VBoxContainer")
	
	var range_idx = 0
	for i in range(1,21):
		if i > multiplier_range[range_idx]:
			range_idx += 1
		var to_add = nugget_type[range_idx].instance()
		to_add.visible = false
		vbox.add_child(to_add)
	pass

func update():
	if decrementing:
		vbox.get_child(idx).visible = false
		idx -= 1
		if idx < 0:
			decrementing = false
			idx = 0
	else:
		vbox.get_child(idx).visible = true
		idx += 1
		if idx > 19:
			decrementing = true
			idx = 19
	pass
