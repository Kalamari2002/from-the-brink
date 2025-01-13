extends "res://Prefabs/Components/Characters/SkillBase.gd"

var time_manager
var control_scheme
var resource_manager
var is_bullet_time = false
var BULLET_TIME_SCALE = 1
func _ready():
	control_scheme = character.get_node("ControlScheme")
	resource_manager = character.get_node("ResourceManager")
	resource_manager.connect("depleted", self, "stop_bullet_time")
	time_manager = get_node("/root/Board/GameManager/TimeScaleManager")
	BULLET_TIME_SCALE = time_manager.get_bullet_time_scale()
	character.connect("turn_started", self, "stop_bullet_time")
func trigger():
	if !is_active():
		return
	begin()
	pass

func _input(event):
	if !is_active():
		return
	if event.is_action_released(control_scheme.special()):
		stop_bullet_time()

func _process(delta):
	if is_bullet_time:
		resource_manager.consume(delta/BULLET_TIME_SCALE)
func begin():
	if resource_manager.get_remaining_resource() <= 0:
		return
	start_bullet_time()

func start_bullet_time():
	is_bullet_time = true
	time_manager.enter_bullet_time()
	
func stop_bullet_time():
	is_bullet_time = false
	time_manager.normalize_time_scale()

func is_active():
	if character.get_curr_state() != character.GameState.WAITING:
		return false
	return true

