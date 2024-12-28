###
# This component controls a character's animations.
###
extends Node2D

var animation_player
export var hit_animation : String
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = get_parent().get_node("AnimationPlayer")
	if hit_animation != "": # If there's a hit animation to be played
		# Set it so that whenever the character is damaged, we play it.
		get_parent().get_node("HealthManager").connect("took_damaged", self, "play_hit_animation")
	pass # Replace with function body.

func play_hit_animation():
	animation_player.play(hit_animation)

