extends Control

onready var base = $Base
onready var unavailable = $Unavailable
onready var progress_bar = $ProgressBar

var max_val : float

func available():
	unavailable.visible = false
	pass

func unavailable():
	unavailable.visible = true
	pass

func set_max_value(val : float):
	progress_bar.max_value = val
	progress_bar.value = 0
	pass

func update_bar(val : float):
	progress_bar.value = val
	pass
