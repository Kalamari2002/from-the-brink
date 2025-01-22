extends KinematicBody2D


export (Color) var damage_color
export (Color) var heal_color

var text_color : Color
var quantity_text : String

var label : Label

const GRAVITY = 10
const X_RANGE = 70
const Y_RANGE = -370

var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_x = rng.randf_range(-X_RANGE, X_RANGE)
	direction = Vector2(random_x, Y_RANGE)
	
	label = $Label
	label.text = quantity_text
	label.add_color_override("font_color",text_color)
	
	$AnimationPlayer.play("FadeOut")
	pass # Replace with function body.

func initialize(is_damage, quantity):
	if is_damage:
		text_color = damage_color
		quantity_text = "-" + str(quantity)
	else:
		text_color = heal_color
		quantity_text = "+" + str(quantity)
	pass

func _physics_process(delta):
	move_and_slide(direction)
	direction.y += GRAVITY
	pass

func self_destroy():
	queue_free()
