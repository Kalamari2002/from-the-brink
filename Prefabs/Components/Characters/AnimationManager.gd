###
# This component controls a character's animations.
###
extends Node2D

export var hit_animation : String


var character : Node2D
var position_manager : Node2D
var health_manager : Node2D
var effect_manager : Node2D

var lingering_animations = ["burnin"]

onready var last_requested_animation = "idle"
onready var curr_lingering_animation = ""
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
	
	effect_manager = character.get_node("EffectManager")
	effect_manager.connect("applied_effect", self, "on_effect_apply")
	effect_manager.connect("removed_effect", self, "on_effect_remove")
	
	position_manager = character.get_node("PositionManager")
	position_manager.connect("changed_quadrants",self,"on_step")
	if position_manager.get_is_right():
		$Sprite.flip_h = true
	
	health_manager = character.get_node("HealthManager")
	if hit_animation != "": # If there's a hit animation to be played
		# Set it so that whenever the character is damaged, we play it.
		health_manager.connect("took_damaged", self, "play_hit_animation")
	pass

func on_effect_apply(effect_name : String):

	if effect_name in lingering_animations:
		print("Animation effect: " + effect_name)
		play_lingering_animation(effect_name)
	pass
func on_effect_remove(effect_name: String):

	if effect_name in lingering_animations:
		end_lingering_animation(effect_name)
	pass

func play_sprite_animation(animation : String):

	if animation == "dead":
		sprite_animator.play(animation)
	print("Current animation: ", curr_lingering_animation)
	last_requested_animation = animation
	if curr_lingering_animation == "":
		if animation == "":
			print("EMPTY")
		sprite_animator.play(animation)
	pass

func play_hit_animation():

	if character.get_curr_state() == character.GameState.DEAD or curr_lingering_animation != "":
		return
	animation_player.play(hit_animation)
	sprite_animator.play("damaged")
	pass
func recover_from_hit():
	play_sprite_animation(last_requested_animation)
	pass

func play_lingering_animation(animation : String):

	var curr_state = character.get_curr_state()
	if curr_state == character.GameState.DEAD:
		return
	if animation == "":
		print("EMPTY")
	sprite_animator.play(animation)
	curr_lingering_animation = animation
func end_lingering_animation(animation : String):

	if animation != curr_lingering_animation:
		return
	curr_lingering_animation = ""
	play_sprite_animation(last_requested_animation)

func on_step():
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
