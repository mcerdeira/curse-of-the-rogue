extends Node2D

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.normal or !Global.pick_random([false, false, true]):
		queue_free()
		return
