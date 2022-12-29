extends Node2D

func _ready():	
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		var cs = get_children()
		for i in range(cs.size()):
			if i < Global.altar_level:
				cs[i].playing = true
				cs[i].speed_scale = 2
