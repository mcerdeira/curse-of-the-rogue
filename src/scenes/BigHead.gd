extends AnimatedSprite

func _ready():
	visible = Global.FLOOR_TYPE == Global.floor_types.intro
	if !visible:
		queue_free()
