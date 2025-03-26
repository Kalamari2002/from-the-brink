extends Node

var origin = null
var target_column = -1

export var value = 0
export var ignore_invul = false

enum DamageTypes {
	BLUDGEONING, PIERCING, SLASHING, # 0, 1, 2
	ACID, COLD, FIRE, LIGHTNING,  # 3, 4, 5, 6
	NECROTIC, POISON, THUNDER, # 7, 8, 9
	FORCE, PSYCHIC, RADIANT # 10, 11, 12
}
export var dmg_type = DamageTypes.SLASHING

enum AttackTypes {MELEE, PROJECTILE, EFFECT}
export var atk_type = AttackTypes.MELEE

func set_origin(origin : Node2D):
	self.origin = origin
	var position_manager = origin.get_node("PositionManager")
	target_column = int(not position_manager.get_is_right())
	pass
