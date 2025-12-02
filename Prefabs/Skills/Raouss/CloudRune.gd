extends "res://Prefabs/Components/Characters/SkillBase.gd"

export var reflect_color : Color

var position_manager : Node2D
var effect_manager : Node2D
var animation_manager : Node2D

onready var TOTAL_TIME = $Cooldown.wait_time
onready var reflect_timer = $ReflectWindow

func initialize(parent_character):
	.initialize(parent_character)
	position_manager = parent_character.get_node("PositionManager")
	effect_manager = parent_character.get_node("EffectManager")
	animation_manager = parent_character.get_node("AnimationManager")
	pass

func begin():
	reflect_timer.start()
	effect_manager.set_reflect(true)
	position_manager.set_can_move(false)
	animation_manager.set_sprite_color(reflect_color)
	pass
	
func on_character_state_change(state):
	if state == character.GameState.ATTACKING or state == character.GameState.SELECTING:
		icon_make_unavailable()
	elif state == character.GameState.WAITING:
		icon_make_available()

func is_active():
	return (character.get_curr_state() == character.GameState.WAITING)

func _on_Cooldown_timeout():
	position_manager.set_can_move(true)
	pass

func _on_ReflectWindow_timeout():
	effect_manager.set_reflect(false)
	animation_manager.reset_sprite_color()
	pass
