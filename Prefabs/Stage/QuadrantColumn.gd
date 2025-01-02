extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var quadrants = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in self.get_children():
		quadrants.append(i)
	pass # Replace with function body.

func step_to_quadrant(from, to, character):
	if to < 0:
		to = 0
	if to > len(quadrants) - 1:
		to = len(quadrants) - 1
	if from == to:
		return false
	print("moved")
	quadrants[from].remove_character(character)
	quadrants[to].position_character(character)
	return true

func set_pos(from,to,character):
	if from != -1:
		quadrants[from].remove_character(character)
	quadrants[to].position_character(character)

func set_cursor(from, to):
	if from != -1:
		quadrants[from].unselect()
	quadrants[to].select()

func step_cursor(from, to):
	if to < 0:
		to = 0
	if to > len(quadrants) - 1:
		to = len(quadrants) - 1
	if from == to:
		return false
	if from != -1:
		quadrants[from].unselect()
	quadrants[to].select()
	return true

func attack_quadrants(dmg):
	for q in quadrants:
		if q.is_selected():
			q.damage_characters(dmg)

func affect_quadrants(effect, arg):
	for q in quadrants:
		if q.is_selected():
			q.apply_effect(effect,arg)

func get_characters():
	var chars = []
	for q in quadrants:
		for c in q.get_held_characters():
			chars.append(c)
	return chars

func clear_cursor():
	for i in quadrants:
		i.unselect()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
