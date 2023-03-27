extends Node2D
var buff = 128
var dirinput = Vector2(0, -1)

func _ready():
	position = dirinput * buff
	
func _physics_process(delta):
	if Global.UseGamePad:
		var dirinput = Input.get_vector("ui_axis_left", "ui_axis_right", "ui_axis_up", "ui_axis_down")
		if dirinput != Vector2.ZERO:
			dirinput = dirinput.normalized()
			position = dirinput * buff
	else:
		global_position = get_global_mouse_position()
