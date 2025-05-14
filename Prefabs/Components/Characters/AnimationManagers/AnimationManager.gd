###
# This component controls a character's animations.
###
extends Node2D

export (Resource) var palette_1
export (Resource) var palette_2
export (Resource) var palette_3
export (Resource) var palette_4

export var hit_animation : String

var character : Node2D
var position_manager : Node2D
var health_manager : Node2D
var effect_manager : Node2D

var color_palette : int

var lingering_animations = ["burnin"]

onready var last_requested_animation = "idle"	# used to keep track of which animation to go back to after recovering from a hit or lingering animation
onready var curr_lingering_animation = ""	# reflects the currently playing lingering animation. set to "" if no lingering animations are playing

onready var animation_player = $AnimationPlayer
onready var movement_animator = $MovementAnimator

#onready var sprite_animator = $Sprite/SpriteAnimator
var character_sprite : Sprite
var sprite_animator : AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func initialize(parent):
	character = parent
	character.connect("state_changed",self,"on_state_change")
	
	effect_manager = character.get_node("EffectManager")
	effect_manager.connect("applied_effect", self, "on_effect_apply")
	effect_manager.connect("removed_effect", self, "end_lingering_animation")
	
	position_manager = character.get_node("PositionManager")
	position_manager.connect("changed_quadrants",self,"on_step")
	
	health_manager = character.get_node("HealthManager")
	if hit_animation != "": # If there's a hit animation to be played
		# Set it so that whenever the character is damaged, we play it.
		health_manager.connect("took_damaged", self, "play_hit_animation")
	
	create_character_sprite(character.get_color_palette())
	play_sprite_animation("idle")
	pass

func create_character_sprite(color_palette : int):
	match(color_palette):
		1:
			character_sprite = palette_1.instance()
		2:
			character_sprite = palette_2.instance()
		3:
			character_sprite = palette_3.instance()
		4:
			character_sprite = palette_4.instance()
	
	character_sprite.set_name("_CharacterSprite")
	character_sprite.connect("recover_from_hit", self, "recover_from_hit")
	add_child(character_sprite)
	
	sprite_animator = character_sprite.get_node("AnimationPlayer")
	
	if position_manager.get_is_right():
		character_sprite.flip_h = true
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


