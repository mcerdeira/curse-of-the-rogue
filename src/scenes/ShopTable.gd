extends Node2D

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()

func _physics_process(delta):
	z_index = global_position.y
