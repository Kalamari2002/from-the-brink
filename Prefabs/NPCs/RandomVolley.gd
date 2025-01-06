extends Node2D

var character
var active
var attack

# Called when the node enters the scene tree for the first time.
func _ready():
	character = self.owner
	pass # Replace with function body.

func activate(atk):
	print("Random volley activated")
	active = true
	attack = atk
	get_node("Fire").start()
	pass

func deactivate():
	print("deactivate")
	active = false
	get_node("Fire").stop()
	

func _on_Fire_timeout():
	attack.instantiate_projectile()
	pass # Replace with function body.
