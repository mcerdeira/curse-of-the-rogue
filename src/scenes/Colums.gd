extends Node2D

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		var cs = get_children()
		for i in range(cs.size()):
			if Global.altar_level < i:
				cs[i].speed_scale = 2
