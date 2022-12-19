extends Area2D
var taken = false
var price_amount = 0
var price_what = "gems"
var item_name = ""
var item_description = ""
var item_long_description = ""
var particle = preload("res://scenes/particle2.tscn")
var amplitude = 5.0
var frequency = 2.0
var time = 0
onready var default_pos = $item.get_position()

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar and Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
		
	var item = choose_item()
	$item.animation = item.name
	item_name = item.name
	item_description = item.description
	item_long_description = item.long_description
	
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		$gem.visible = false
		$price_lbl.visible = false
		price_amount = 0
		price_what = ""
	else:
		if Global.CURRENT_FLOOR == 1:
			item.price = item.price / 2 #Floor 1, 50% off!
		
		$price_lbl.text = "x" + str(item.price)
		price_amount = item.price

func _physics_process(delta):
	time += delta * frequency
	$item.set_position(default_pos + Vector2(0, sin(time) * amplitude))

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position

func choose_item():
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		return Global.get_random_premium_item()
	else:
		return Global.get_random_item()

func do_item_effect(_player):
	emit()
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.set_message(item_description, item_long_description)
		
	if item_name == "blue_heart":
		_player.add_shield(1)
	elif item_name == "brain":
		pass
	elif item_name == "damageup":
		_player.add_damage(1)
	elif item_name == "empty_heart":
		_player.add_total_hearts(1)
	elif item_name == "green_heart":
		_player.add_shield_poision(1)
	elif item_name == "luckup":
		_player.add_luck(1)
	elif item_name == "meleeup":
		_player.add_melee(1)
	elif item_name == "normal_heart":
		_player.add_heart(1)
	elif item_name == "poison":
		_player.add_poison()
	elif item_name == "shoot_speed_up":
		_player.add_shoot_speed(1)
	elif item_name == "speedup":
		_player.add_speed(1)
	elif item_name == "wolf_bite":
		pass

func _on_ItemPedestal_body_entered(body):
	if !taken and Global.pay_price(body, price_what, price_amount):
		do_item_effect(body)
		taken = true
		$price_lbl.visible = false
		$gem.visible = false
		$item.visible = false
