extends Area2D
export var type = "next"
var particle = preload("res://scenes/particle2.tscn")

func _ready():
	add_to_group("doors")
	$lbl.visible = false
	$lbl.text = trad_type()

func trad_type():
	if type == "next":
		return "Floor " + str(Global.CURRENT_FLOOR + 1)
	elif type == "shop":
		return "Shop"

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
		
func open_door():
	$lbl.visible = true
	$sprite.animation = "opened"
	emit()
