extends Area2D
export var type = "shop"
var particle = preload("res://scenes/particle2.tscn")
var do_action = false
var do_action_ttl = 1.5
var price_what = ""
var price_amount = -1
var opened = false

func _ready():
	add_to_group("doors")
	
	if type == "" and Global.FLOOR_TYPE != Global.floor_types.normal and Global.FLOOR_TYPE != Global.floor_types.intro:
		queue_free()
		return
		
	if type == "shop" and Global.FLOOR_TYPE != Global.floor_types.normal:
		type = "next"
	
	$lbl.visible = false
	$price_lbl.visible = false
	$amount_spr.visible = false
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
		return Global.pick_random(["altar", "altar","supershop"])

func set_price():
	randomize()
	if type == "altar":
		price_what = Global.pick_random(["life", "keys", "gems", ""])
		
	if price_what == "":
		price_amount = 0
	elif price_what == "life":
		if randi()%Global.bad_luck == 0:
			price_amount = 0
		else:
			var p = randi()%Global.health.size()+1
			price_amount = p
	elif price_what == "keys":
		price_amount = Global.pick_random([1, 2, 3])
	elif price_what == "gems":
		if randi()%Global.bad_luck == 0:
			price_amount = 0
		else: 
			price_amount = Global.pick_random([10, 50, 100])

func trad_type():
	if type == "shop":
		return "Shop"
	elif type == "next":
		return "To Floor " + str(Global.CURRENT_FLOOR + 1)
	elif type == "altar":
		set_price()
		return "Altar"
	elif type == "cant":
		return "???"
	elif type == "supershop":
		set_price()
		return "Shop++"

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
		
func reveal():
	$lbl.visible = true
	if type == "next" or type == "shop":
		open_door()
	elif type != "cant":
		if price_amount > 0:
			$price_lbl.text = "x" + str(price_amount)
			$amount_spr.animation = price_what
			$amount_spr.visible = true
			$price_lbl.visible = true
		else:
			open_door()
		
	emit()

func open_door():
	opened = true
	if type == "altar":
		$sprite.animation = "altaropened"
	else:
		$sprite.animation = "opened"
	emit()
	
func _on_Door_body_entered(body):
	if body.is_in_group("players"):
		if opened:
			if !do_action:
				do_action = true
				body.position.x = position.x
				body.entering()
		else:
			if price_amount > 0:
				if Global.pay_price(body, price_what, price_amount):
					open_door()
