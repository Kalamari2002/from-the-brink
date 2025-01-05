extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var character
var selector
var abilities
# Called when the node enters the scene tree for the first time.
func _ready():
	character = get_parent().get_parent()
	selector = character.get_node("Selector")
	
	character.connect("turn_started", self, "pick_attack")
	pass # Replace with function body.

func pick_attack():
	print("DUMMY PICKED ATTACK")
	abilities = selector.get_abilities()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(0,len(abilities)-1)
	abilities[num].activate()
	pass

func print_abilities():
	print("Abilities: ", len(abilities))
	for a in abilities:
		print(a.get_name())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
