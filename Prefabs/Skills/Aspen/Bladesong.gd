extends "res://Prefabs/Components/Characters/SkillBase.gd"

var time_manager : Node2D
var control_scheme : Node2D
var resource_manager : Node2D
var is_bullet_time = false
var BULLET_TIME_SCALE = 1

func _ready():
	time_manager = get_node("/root/Board/GameManager/TimeScaleManager")
	BULLET_TIME_SCALE = time_manager.get_bullet_time_scale()

func initialize(charactr):
	.initialize(charactr)
	character.connect("turn_started", self, "stop_bullet_time")
	
	control_scheme = character.get_node("ControlScheme")
	
	resource_manager = character.get_node("ResourceManager")
	resource_manager.connect("depleted", self, "stop_bullet_time")
	pass

func trigger():
	if cooldown.time_left != 0 or !is_active():
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
	print(cooldown.time_left)

func begin():
	if resource_manager.get_remaining_resource() <= 0:
		return
	start_bullet_time()

func start_bullet_time():
	is_bullet_time = true
	time_manager.enter_bullet_time()
	
func stop_bullet_time():
	if !is_bullet_time:
		return
	is_bullet_time = false
	time_manager.normalize_time_scale()
	cooldown.start()

func is_active():
	if character.get_curr_state() != character.GameState.WAITING:
		return false
	return true

