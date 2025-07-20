extends "res://Prefabs/Components/Projectiles/Projectile.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bounced = false
var y_origin
var collision_shape
var arc_movement
var animation_player
var shadow
var effect_manager

func _ready():
	y_origin = global_position.y
	set_animation()

func initialize(character):
	.initialize(character)
	effect_manager = character.get_node("EffectManager")
	arc_movement  = $_Movement
	
	collision_shape = $Area2D/CollisionShape2D
	collision_shape.disabled = true
	
	animation_player = $AnimationPlayer
	shadow = $Shadow

func set_animation():
	if dir == -1:
		animation_player.play("Rotate_Reverse")
	else:
		animation_player.play("Rotate")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var animation_speed = rng.randf_range(0.6, 1.4)
	animation_player.playback_speed = animation_speed
	pass

func _process(delta):
	if abs(global_position.y - y_origin) <= 20 and arc_movement.get_curr_y_vel() > 0:
		bounce()

func bounce():
	if bounced:
		return
	collision_shape.disabled = false
	animation_player.stop(false)
	bounced = true
	arc_movement.bounce()
	shadow.visible = false
	pass

func reflect():
	if bounced:
		return
	.reflect()
	pass

func get_effect_manager():
	return effect_manager
