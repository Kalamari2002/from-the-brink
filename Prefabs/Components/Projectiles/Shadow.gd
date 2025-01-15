extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	global_position = get_parent().global_position
	get_node("AnimationPlayer").play("FadeIn")
	pass # Replace with function body.

func _process(delta):
	global_position = Vector2(get_parent().global_position.x, global_position.y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
