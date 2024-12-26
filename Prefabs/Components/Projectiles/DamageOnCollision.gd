extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var damage : int

func change_damage(new_dmg):
	damage = new_dmg

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_area_entered(area):
	if area.is_in_group("characters"):
		area.get_parent().take_dmg(damage)
	pass # Replace with function body.

func self_destroy():
	queue_free()
