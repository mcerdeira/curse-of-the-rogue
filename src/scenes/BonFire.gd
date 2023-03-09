extends Node2D


func _ready():
	add_to_group("bonfire")
	if Global.FLOOR_TYPE != Global.floor_types.altar and Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
		return
