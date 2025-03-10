###
# This component controls a character's animations.
###
extends Node2D

export var hit_animation : String
var pre_damaged_animation : String

var character : Node2D
var position_manager : Node2D
var health_manager : Node2D

onready var animation_player = $AnimationPlayer
onready var sprite_animator = $Sprite/SpriteAnimator
onready var movement_animator = $MovementAnimator

# Called when the node enters the scene tree for the first time.
func _ready():
	play_sprite_animation("idle")
	pass

func initialize(parent):
	character = parent
	character.connect("state_changed",self,"on_state_change")
	
	position_manager = character.get_node("PositionManager")
	position_manager.connect("changed_quadrants",self,"on_step")
	if position_manager.get_is_right():
		$Sprite.flip_h = true
	
	health_manager = character.get_node("HealthManager")
	if hit_animation != "": # If there's a hit animation to be played
		# Set it so that whenever the character is damaged, we play it.
		health_manager.connect("took_damaged", self, "play_hit_animation")
	pass

func play_hit_animation():
	if character.get_curr_state() == character.GameState.DEAD:
		return
	animation_player.play(hit_animation)
	sprite_animator.play("damaged")
	pass

func play_sprite_animation(animation : String):
	sprite_animator.play(animation)
	pre_damaged_animation = animation
	pass

func recover_from_hit():
	play_sprite_animation(pre_damaged_animation)
	pass
	
func on_step():
	print("STEP!")
	movement_animator.play("step")
	pass

func on_state_change(state):
	var gamestate = character.GameState
	match state:
		gamestate.DEAD:
			play_sprite_animation("dead")
		gamestate.SELECTING:
			play_sprite_animation("selecting")
		gamestate.ATTACKING:
			play_sprite_animation("attacking")
		_:
			play_sprite_animation("idle")
	pass
