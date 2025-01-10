extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func flip_self():
	self.rect_scale = Vector2(-self.rect_scale.x,self.rect_scale.y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
