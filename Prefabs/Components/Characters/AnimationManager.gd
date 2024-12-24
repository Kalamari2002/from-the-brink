extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animation_player
export var hit_animation : String
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = get_parent().get_node("AnimationPlayer")
	if hit_animation != "":
		get_parent().get_node("HealthManager").connect("took_damaged", self, "play_hit_animation")
	pass # Replace with function body.

func play_hit_animation():
	animation_player.play(hit_animation)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
