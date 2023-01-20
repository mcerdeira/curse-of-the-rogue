extends Line2D

var delay = 0
var first = true
var max_len = 100
onready var parent = get_parent()

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	delay -= 1 * delta
	
	if delay <= 0:
		var pos = parent.global_position
		add_point(pos)
		if first:
			remove_point(0)
			first = false
		
		if get_point_count() >= max_len:
			remove_point(0)
