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

# Called when the node enters the scene tree for the first time.
func _ready():
	y_origin = global_position.y
	arc_movement  = get_node("ArcMovement")
	collision_shape = get_node("Area2D/CollisionShape2D")
	collision_shape.disabled = true
	animation_player = get_node("AnimationPlayer")
	shadow = get_node("Shadow")
	if dir == -1:
		animation_player.play("Rotate_Reverse")
	else:
		animation_player.play("Rotate")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var animation_speed = rng.randf_range(0.6, 1.4)
	animation_player.playback_speed = animation_speed

func set_origin(character):
	effect_manager = character.get_node("EffectManager")

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

func get_effect_manager():
	return effect_manager
