extends Node2D

func _ready():
	$Map_Sign.position.y = get_floor_pos()

func get_floor_pos():
	var c = str(Global.CURRENT_FLOOR)
	if c == "0":
		c = ""
	var n = get_node("pos" + c)
	if(n):
		return n.position.y
	else:
		return 0
