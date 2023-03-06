extends Area2D
export var type = "shop"
var particle = preload("res://scenes/particle2.tscn")
var do_action = false
var do_action_ttl_total = 1.5
var do_action_ttl = do_action_ttl_total
var price_what = ""
var price_amount = -1
var opened = false
var pixelated = 0
var got_idols = false

func _ready():
	add_to_group("doors")
	
	if Global.FLOOR_TYPE == Global.floor_types.ending:
		queue_free()
		return
	
	for i in Global.IDOLS:
		if i > 0:
			got_idols = true
			break
			
	if Global.FLOOR_TYPE == Global.floor_types.idols_chamber:
		if Global.ending_unlocked:
			if type == "":
				type = "boss"
		else:
			if type == "":
				type = "cant"
	
	if type == "" and Global.FLOOR_TYPE != Global.floor_types.normal and Global.FLOOR_TYPE != Global.floor_types.intro:
		queue_free()
		return
		
	if type == "shop" and Global.FLOOR_TYPE == Global.floor_types.final_boss:
		type = "ending"
		
	if type == "shop" and (Global.FLOOR_TYPE == Global.floor_types.boss or Global.FLOOR_TYPE == Global.floor_types.intro):
		type = "next"

	if type == "shop" and Global.FLOOR_TYPE != Global.floor_types.normal and Global.FLOOR_TYPE != Global.floor_types.idols_chamber:
		type = "boss"
		
	if type == "shop" and Global.only_supershops:
		type = "supershop"
		
	if Global.final_boss():
		type = "final_boss"
		
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
		
		if do_action_ttl <= do_action_ttl_total / 2:
			Global.set_visible_transition(true)
			pixelated += 200 * delta
			Global.pixelate(pixelated)
		
		if do_action_ttl <= 0:
			go_do_action()
	
func random_type():
	if Global.FLOOR_TYPE == Global.floor_types.intro:
		if got_idols:
			return "idols_chamber"
		else:
			return "cant"
	else:
		if Global.only_supershops:
			return "altar"
		else:
			return Global.pick_random(["altar", "altar", "altar", "supershop"])

func set_price():
	randomize()
	if Global.CURRENT_FLOOR == 1:
		price_what = ""
	else:
		if type == "altar":
			price_what = Global.pick_random(["life", "life", "gems", "gems", ""])
		elif type == "supershop":
			price_what = Global.pick_random(["keys", "gems", "keys", "gems", ""])
		
	if price_what == "":
		price_amount = 0
	elif price_what == "life":
		if randi()%Global.bad_luck == 0:
			price_amount = 0
		else:
			price_amount = 1
	elif price_what == "keys":
		price_amount = Global.pick_random([1, 2])
	elif price_what == "gems":
		if randi()%Global.bad_luck == 0:
			price_amount = 0
		else: 
			price_amount = Global.CURRENT_FLOOR * Global.pick_random([10, 15, 20, 25, 30, 35, 40, 45, 50])

func trad_type():
	if type == "shop":
		return "Shop"
	elif type == "ending":
		return "Exit"
	elif type == "next":
		return "Floor " + str(Global.CURRENT_FLOOR + 1)
	elif type == "altar":
		set_price()
		return "Altar"
	elif type == "cant":
		return "???"
	elif type == "idols_chamber":
		return "CHAMBER"
	elif type == "supershop":
		if !Global.only_supershops:
			set_price()
		return "Shop++"
	elif type == "boss":
		if Global.ending_unlocked:
			return "GO AWAY"
		else:
			return "BOSS"
	elif type == "final_boss":
		return "???"
			
func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
		
func reveal():
	$lbl.visible = true
	if type == "next" or type == "shop" or (type == "supershop" and Global.only_supershops):
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
	
func close_door():
	opened = false
	if type == "altar":
		$sprite.animation = "altar"
	else:
		$sprite.animation = "normal"
	emit()

func open_door():
	opened = true
	if type == "altar":
		if price_amount > 0:
			Global.play_sound(Global.AltarOpenedSfx)
		$sprite.animation = "altaropened"
	else:
		if Global.ending_unlocked:
			if type != "shop" and type != "next":
				$sprite.animation = "opened"
			else:
				opened = false
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
