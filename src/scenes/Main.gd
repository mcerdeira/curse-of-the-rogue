extends Node2D


func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		$Colums.queue_free()
		$Colums2.queue_free()
