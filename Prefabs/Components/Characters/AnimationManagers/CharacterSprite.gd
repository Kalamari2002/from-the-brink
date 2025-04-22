extends Sprite

signal recover_from_hit

export (Texture) var attack
export (Texture) var burning_1
export (Texture) var burning_2
export (Texture) var selecting_1
export (Texture) var selecting_2
export (Texture) var damaged
export (Texture) var dead
export (Texture) var idle

var texture_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():

	texture_map = {
		"attacking" : attack,
		"burning_1" : burning_1,
		"burning_2" : burning_2,
		"selecting_1" : selecting_1,
		"selecting_2" : selecting_2,
		"damaged" : damaged,
		"dead" : dead,
		"idle" : idle
	}

	pass # Replace with function body.

func set_sprite(sprite : String):
	self.texture = texture_map[sprite]
	pass

func recover_from_hit():
	emit_signal("recover_from_hit")
	pass
