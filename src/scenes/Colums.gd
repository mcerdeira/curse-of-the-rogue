extends Node2D

func _ready():	
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		var cs = get_children()
		for i in range(cs.size()):
			cs[i].z_index = cs[i].global_position.y + 44
			if i < Global.altar_level:
				cs[i].playing = true
				cs[i].speed_scale = 2
