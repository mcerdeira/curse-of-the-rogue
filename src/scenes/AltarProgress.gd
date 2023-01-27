extends StaticBody2D
var red = 255
var blue = 0
var r_direction = -1
var b_direction = 1

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		queue_free()
		return
	calc_level()
	
func calc_level():
	var total = Global.calc_points_level()
	var prog = Global.altar_points
	
	var size = prog / total
	$bar2.scale.x = size
	$lbl_altar.text = str(Global.altar_level)

func _physics_process(delta):
	calc_level()
	
	z_index = global_position.y + 16
	
	$bar2.modulate = Color8(red, 255, blue)
	red += (50 * r_direction) * delta
	blue += (10 * b_direction) * delta
	
	$lbl_altar.modulate = $bar2.modulate
	
	if b_direction == -1 and blue < 0:
		b_direction = 1
	elif b_direction == 1 and blue > 255:
		b_direction = -1
	
	if r_direction == -1 and red < 0:
		r_direction = 1
	elif r_direction == 1 and red > 255:
		r_direction = -1
