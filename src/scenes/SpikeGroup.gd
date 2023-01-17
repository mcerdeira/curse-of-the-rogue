extends Node2D

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.normal:
		pass
		destroy_all()
	else:
		leave_some()

func leave_some():
	var count = Global.CURRENT_FLOOR + Global.pick_random([0, 1])
	var c = 0

	var spikes = get_children()
	spikes.shuffle()
	for s in spikes:
		if c < count:
			c += 1
			if Global.pick_random([0, 1, 1]) == 0:
				s.queue_free()
		else:
			s.queue_free()

func destroy_all():
	var spikes = get_children()
	for s in spikes:
		s.queue_free()
	
