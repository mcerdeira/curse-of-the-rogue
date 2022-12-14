extends Area2D
var taken = false
var price_amount = 0
var price_what = "gems"
var item_name = ""

var amplitude = 5.0
var frequency = 2.0
var time = 0
onready var default_pos = $item.get_position()

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
		
	var item = choose_item()
	$item.animation = item.name
	item_name = item.name
	
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		$gem.visible = false
		$price_lbl.visible = false
		price_amount = 0
		price_what = ""
	else:
		$price_lbl.text = "x" + str(item.price)
		price_amount = item.price

func _physics_process(delta):
	time += delta * frequency
	$item.set_position(default_pos + Vector2(0, sin(time) * amplitude))

func choose_item():
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		return Global.get_random_premium_item()
	else:
		return Global.get_random_item()

func do_item_effect(_player):
	if item_name == "blue_heart":
		_player.add_shield(1)
	elif item_name == "empty_heart":
		_player.add_total_hearts(1)
	elif item_name == "normal_heart":
		_player.add_heart(1)
	elif item_name == "green_heart":
		_player.add_shield_poision(1)
	elif item_name == "poison":
		_player.add_poison()
	elif item_name == "speedup":
		pass
	elif item_name == "meleeup":
		pass
	elif item_name == "luckup":
		pass

func _on_ItemPedestal_body_entered(body):
	if !taken and Global.pay_price(body, price_what, price_amount):
		do_item_effect(body)
		taken = true
		$price_lbl.visible = false
		$gem.visible = false
		$item.visible = false
