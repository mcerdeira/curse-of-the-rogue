extends Line2D

var max_len = 100
onready var parent = get_parent()

func _ready():
	max_len = Global.pick_random([100, 50, 25])
	set_as_toplevel(true)

func _process(delta):
	add_point(parent.global_position)
	if get_point_count() >= max_len:
		remove_point(0)
