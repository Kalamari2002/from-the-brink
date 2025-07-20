### !!!!!!!!!!!!!!!!!!!!
#	MOVEMENT SCRIPT MUST BE NAMED "_Movement"
#	EFFECTONCOLLISION MUST BE NAMED "_EffectOnCollision"
### !!!!!!!!!!!!!!!!!!!!
extends KinematicBody2D

signal got_hit(area)

var init_dir : int
var dir : int
var origin_quadrant : int

var movement : Node2D
var effect_on_collision : Node2D
var damage_data : Node
var position_manager : Node2D

func get_dir()->int:
	return dir
	
func get_init_dir()->int:
	return init_dir

func _input(event):
	if event.is_action_pressed("ui_select"): # Move cursor if it's active 
		reflect()
	pass

func set_charge(charge):
	movement.multiply_speed(charge)
	effect_on_collision.multiply_damage(charge)

func initialize(character):
	position_manager = character.get_node("PositionManager")
	global_position = Vector2(character.global_position.x + position_manager.get_spawn_offset(), character.global_position.y)
	dir = 1
	if position_manager.get_is_right():
		dir = -1
	init_dir = dir
	origin_quadrant = position_manager.get_curr_pos()
	
	damage_data = $DamageData
	damage_data.set_origin(character)
	damage_data.atk_type = damage_data.AttackTypes.PROJECTILE
	
	movement = $_Movement
	
	effect_on_collision = $_EffectOnCollision
	effect_on_collision.initialize(self)
	pass

func reflect():
	dir = -dir
	movement.on_reflect()
	effect_on_collision.on_reflect()
	$SelfDestroyTimer.reset_timer()
	pass

func get_origin_quadrant():
	return origin_quadrant

func _on_Area2D_area_entered(area):
	emit_signal("got_hit",area)
	pass
