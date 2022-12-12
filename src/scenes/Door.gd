extends Area2D
export var type = "next"
var particle = preload("res://scenes/particle2.tscn")

func _ready():
	add_to_group("doors")
	$lbl.visible = false
	if type == "":
		type = random_type()
		$sprite.animation = type
	
	$lbl.text = trad_type()
	
func random_type():
	return Global.pick_random(["altar", "altar", "cant", "supershop"])

func trad_type():
	if type == "next":
		return "Floor " + str(Global.CURRENT_FLOOR + 1)
	elif type == "altar":
		return "Altar"
	elif type == "supershop":
		return "Shop++"

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
		
func reveal():
	$lbl.visible = true
	if type == "next":
		if type == "altar":
			$sprite.animation = "altaropened"
		else:
			$sprite.animation = "opened"
	emit()

func open_door():
	$lbl.visible = true
	$sprite.animation = "opened"
	emit()
