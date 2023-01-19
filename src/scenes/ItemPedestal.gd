extends Area2D
var taken = false
var price_amount = 0
var price_what = "gems"
var item_name = ""
var item_description = ""
var item_type = ""
var item_long_description = ""
var oneshot = false
var particle = preload("res://scenes/particle2.tscn")
var amplitude = 5.0
var frequency = 2.0
var time = 0
export var local_altar_level = 0
export var noforshop = false
onready var default_pos = $item.get_position()

func _ready():
	if Global.altar_level == Global.altar_level_max and Global.FLOOR_TYPE == Global.floor_types.intro:
		Global.FLOOR_TYPE = Global.floor_types.altar
	
	var chest_replacement = false
	if !(Global.FLOOR_TYPE == Global.floor_types.normal and Global.FLOOR_OVER):
		if Global.FLOOR_TYPE != Global.floor_types.altar and Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
			queue_free()
			return
	else:
		chest_replacement = true
		
	if Global.FLOOR_TYPE == Global.floor_types.altar:
		if local_altar_level > Global.altar_level:
			queue_free()
			return
		
	if noforshop and Global.FLOOR_TYPE == Global.floor_types.shop:
		queue_free()
		return
		
	emit()
	var item = choose_item(chest_replacement)
	$item.animation = item.name
	item_name = item.name
	item_description = item.description
	item_long_description = item.long_description
	item_type = item.type
	
	oneshot = item.oneshot
	
	if chest_replacement or Global.FLOOR_TYPE == Global.floor_types.altar:
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
	if taken:
		$item.material.set_shader_param("white", 1)
		$item.scale.x += 350 * delta
		$item.scale.y -= 50 * delta
		if $item.scale.x > 30:
			queue_free()
			
		if $item.scale.y <= 0:
			$item.scale.y = 0.1
	else:
		time += delta * frequency
		$item.set_position(default_pos + Vector2(0, sin(time) * amplitude))
		
	z_index = global_position.y

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position

func choose_item(chest_replacement:=false):
	return Global.get_random_item(chest_replacement)

func do_item_effect(_player):
	emit()
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.set_message(item_description, item_long_description)
	
	if oneshot:
		Global.remove_from_pool(item_name)
		if item_type != "gun":
			var texture = $item.get_sprite_frames().get_frame($item.animation, $item.get_frame())
			Global.one_shot_items.append(texture)
			Global.refresh_hud()
		
	if item_name == "katana":
		_player.add_primary_weapon()
	if item_name == "blue_heart":
		_player.add_shield(1)
	elif item_name == "spikeball":
		_player.add_automatic_weapon(item_name)
	elif item_name == "bomb":
		_player.add_automatic_weapon(item_name)
	elif item_name == "brain":
		_player.add_brain()
	elif item_name == "damageup":
		_player.add_damage(2)
	elif item_name == "dash":
		_player.add_secondary_weapon(item_name)
	elif item_name == "explosive_item":
		_player.add_secondary_weapon(item_name)	
	elif item_name == "electric_attack":
		_player.add_electric()
	elif item_name == "empty_heart":
		_player.add_total_hearts(1)
	elif item_name == "green_heart":
		_player.add_shield_poision(1)
	elif item_name == "ice_attack":
		_player.add_ice()
	elif item_name == "key":
		_player.add_key(1)
	elif item_name == "master_key":
		_player.add_master_key()
	elif item_name == "magnet":
		_player.add_magnet()
	elif item_name == "knife":
		_player.add_automatic_weapon(item_name)
	elif item_name == "plasma":
		_player.add_automatic_weapon(item_name)
	elif item_name == "luckup":
		_player.add_luck(5)
	elif item_name == "cherry_item":
		_player.add_cherry()
	elif item_name == "blue_lobster":
		_player.add_luck(2)
		_player.add_shield(4)
		_player.add_damage(1)
	elif item_name == "meleeup":
		_player.add_melee(0.1)
	elif item_name == "normal_heart":
		_player.add_heart(1)
	elif item_name == "pay_2_win":
		_player.add_pay_2_win(true)
	elif item_name == "life_2_win":
		_player.add_life_2_win()
	elif item_name == "poison":
		_player.add_poison()
	elif item_name == "roll":
		_player.add_secondary_weapon(item_name)
	elif item_name == "shoot_speed_up":
		_player.add_shoot_speed(0.5)
	elif item_name == "shot_gun":
		_player.add_automatic_weapon(item_name)
	elif item_name == "speedup":
		_player.add_speed(1)
	elif item_name == "tomahawk":
		_player.add_automatic_weapon(item_name)
	elif item_name == "wolf_bite":
		_player.add_wolf_bite()
	elif item_name == "fly_item":
		_player.add_fly()

func _on_ItemPedestal_body_entered(body):
	if body.is_in_group("players") and !taken and Global.pay_price(body, price_what, price_amount):
		emit()
		do_item_effect(body)
		taken = true
		$price_lbl.visible = false
		$gem.visible = false
