extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var character
var selector
var abilities = []
# Called when the node enters the scene tree for the first time.
func _ready():
	character = self.owner
	selector = character.get_node("Selector")
	
	character.connect("turn_started", self, "pick_attack",[2])
	#character.connect("turn_started", self, "pick_random_attack")
	get_abilities()
	connect_signals()
	pass # Replace with function body.

func connect_signals():
	abilities[1].connect("start_atk",self,"begin_attack",[0,abilities[1]])
	abilities[2].connect("start_atk",self,"begin_attack",[1,abilities[2]])
	abilities[2].connect("end_atk",self,"end_attack",[1])
	pass

func begin_attack(script_idx,atk):
	get_child(script_idx).activate(atk)

func end_attack(script_idx):
	get_child(script_idx).deactivate()

func pick_attack(atk):
	abilities[atk].activate()

func pick_random_attack():
	print("DUMMY PICKED ATTACK")
	#abilities = selector.get_abilities()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1,len(abilities)-1)
	abilities[num].activate()
	pass

func get_abilities():
	abilities = selector.get_abilities()

func print_abilities():
	print("Abilities: ", len(abilities))
	for a in abilities:
		print(a.get_name())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
