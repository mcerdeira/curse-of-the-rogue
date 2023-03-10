extends Node2D

func _ready():
	var pos = get_floor_pos()
	if pos != Vector2.ZERO:
		$Map_Sign.position = pos
	else:
		$Map_Sign.visible = false

func get_floor_pos():
	var c = str(Global.CURRENT_FLOOR)
	if c == "0":
		c = ""
	if Global.CURRENT_FLOOR > 7:
		c = "7"
	var n = get_node("pos" + c)
	if(n):
		return n.position
	else:
		return Vector2.ZERO
