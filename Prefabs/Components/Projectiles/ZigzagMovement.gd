extends "res://Prefabs/Components/Projectiles/ProjectileComponents/ProjectileMovementBase.gd"
var y_dir = 0
var seq
var seq_idx = 0
var can_move = true
var origin_quadrant = 1
var travel_vector
var prev_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	travel_vector = Vector2(dir,0)
	prev_pos = global_position
	pass # Replace with function body.

func set_origin_quadrant(idx):
	print("set origin")
	match idx:
		0:
			seq = [0,1,0,-1]
		1:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var num = rng.randi_range(0,1)
			if num:
				seq = [0,-1,0,1]
			else:
				seq = [0,1,0,-1]
		2:
			seq = [0,-1,0,1]

func _physics_process(delta):
	#var travel_vector = Vector2(dir,0)
	if abs(global_position.x - prev_pos.x) >= (64 * 2) or abs(global_position.y - prev_pos.y) >= (64 * 3):
		switch_direction()
		pass
	move(delta)
	
func move(delta):
	if !can_move:
		return
	get_parent().move_and_collide(travel_vector * delta * curr_base)

func switch_direction():
	#print("switched direction")
	seq_idx += 1
	if seq_idx >= 4:
		seq_idx = 0
	var x_direction = int(seq[seq_idx] == 0)
	prev_pos = global_position
	travel_vector = Vector2(x_direction * dir, seq[seq_idx])
	pass

func _on_Interval_timeout():
	can_move = !can_move
	pass # Replace with function body.
