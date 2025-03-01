###
# This component controls a character's animations.
###
extends Node2D

export var hit_animation : String

var character : Node2D
var position_manager : Node2D

onready var animation_player = $AnimationPlayer
onready var sprite_animator = $Sprite/SpriteAnimator
onready var movement_animator = $MovementAnimator

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_animator.play("idle")
	pass

func initialize(parent):
	character = parent
	character.connect("state_changed",self,"on_state_change")
	
	position_manager = character.get_node("PositionManager")
	position_manager.connect("changed_quadrants",self,"on_step")

	if position_manager.get_is_right():
		$Sprite.flip_h = true
	
	if hit_animation != "": # If there's a hit animation to be played
		# Set it so that whenever the character is damaged, we play it.
		character.get_node("HealthManager").connect("took_damaged", self, "play_hit_animation")
	pass # Replace with function body.

func play_hit_animation():
	animation_player.play(hit_animation)
	
func on_step():
	print("STEP!")
	movement_animator.play("step")
	pass

func on_state_change(state):
	var gamestate = character.GameState
	match state:
		gamestate.DEAD:
			sprite_animator.play("dead")
		gamestate.SELECTING:
			sprite_animator.play("selecting")
		gamestate.ATTACKING:
			sprite_animator.play("attacking")
		_:
			sprite_animator.play("idle")
	pass

