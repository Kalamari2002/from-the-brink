extends "res://Prefabs/Components/Projectiles/ProjectileComponents/ProjectileMovementBase.gd"


var left_column
var right_column
var going_back = false
var acceleration = 15
var animation_player
# Called when the node enters the scene tree for the first time.
func _ready():

	left_column = get_tree().get_root().get_node("Board/Quadrants/left")
	right_column = get_tree().get_root().get_node("Board/Quadrants/right")
	animation_player = get_parent().get_node("AnimationPlayer")
	
	if dir == -1:
		animation_player.play("Rotate_Reverse")
	else:
		animation_player.play("Rotate")

func _physics_process(delta):
	
	if global_position.x > right_column.global_position.x or global_position.x < left_column.global_position.x:
		switch_speed()
	
	var travel_vector = Vector2(dir,0)
	get_parent().move_and_collide(travel_vector * delta * curr_speed)
	if going_back:
		curr_speed -= acceleration

func switch_speed():
	going_back = true
