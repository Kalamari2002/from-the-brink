extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal start_volley
signal end_volley

var xoffset = 64
var character
const projectile = preload("res://Prefabs/Components/Projectiles/Projectile.tscn")
var active = false

var control_scheme
var duration_timer
var fire_rate

# Called when the node enters the scene tree for the first time.
func _ready():
	duration_timer = get_node("Duration")
	fire_rate = get_node("FireRate")
	character = get_parent().get_parent()
	control_scheme = character.get_node("ControlScheme")
	pass # Replace with function body.

func _input(event):
	if !active:
		return
	if event.is_action_pressed(control_scheme.confirm()):
		if fire_rate.time_left == 0:
			instantiate_projectile()
		pass

func activate():
	print("Projectile Volley")
	duration_timer.start()
	active = true
	emit_signal("start_volley")
	pass
	
func deactivate():
	emit_signal("end_volley")
	active = false

func instantiate_projectile():
	var p = projectile.instance()
	p.position = spawn_pos()
	p.set_dir(get_dir())
	get_node("/root/Board").add_child(p)
	fire_rate.start()

func spawn_pos():
	var pos = character.global_position
	pos.x += get_dir() * xoffset
	return pos
	
func get_dir():
	if character.get_id() % 2 == 0:
		return -1
	return 1

func _on_Duration_timeout():
	deactivate()
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

