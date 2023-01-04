extends StaticBody2D

func _ready():
	queue_free()
	if Global.FLOOR_TYPE != Global.floor_types.normal:
		queue_free()
