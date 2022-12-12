extends Area2D
export var type = "next"
var particle = preload("res://scenes/particle2.tscn")
var do_action = false
var do_action_ttl = 1.5

func _ready():
	add_to_group("doors")
	$lbl.visible = false
	if type == "":
		type = random_type()
		$sprite.animation = type
	
	$lbl.text = trad_type()
	
func go_do_action():
	Global.next_floor(type)
	
func _physics_process(delta):
	if do_action:
		do_action_ttl -= 1 * delta
		if do_action_ttl <= 0:
			go_do_action()
	
func random_type():
	if Global.FLOOR_TYPE == Global.floor_types.intro:
		return "cant"
	else:
		return Global.pick_random(["altar", "altar", "cant", "supershop"])

func trad_type():
	if type == "next":
		return "Floor " + str(Global.CURRENT_FLOOR + 1)
	elif type == "altar":
		return "Altar"
	elif type == "cant":
		return "???"
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

func _on_Door_body_entered(body):
	if !do_action and $sprite.animation == "opened":
		if body.is_in_group("players"):
			do_action = true
			body.position.x = position.x
			body.entering()
