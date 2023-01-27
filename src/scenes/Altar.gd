extends StaticBody2D
export var altar_type = ""
var _player = null
var price_amount = 1
var price_what = ""
var entered = false
var in_ttl = 0
var in_ttl_total = 1
var pay_ttl = 0
var pay_ttl_total = 0.1

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		queue_free()
	
	z_index = position.y
	set_values()
	$sprite.animation = altar_type
	$sprite2.animation = altar_type
	$sprite3.animation = altar_type
	price_what = "life"
	if altar_type != "blood":
		price_what = "gems"
		$skull_spr.visible = false
		$blood.visible = false
	else:
		$label.add_color_override("font_color", Color8(235, 40, 40))
		
func _physics_process(delta):
	if entered:
		in_ttl += 1 * delta
		if in_ttl >= in_ttl_total and price_what == "gems":
			pay_ttl -= 1 * delta
			if pay_ttl <= 0:
				pay_ttl = pay_ttl_total
				if Global.pay_price(_player, price_what, price_amount):
					level_up_altar()
		
func set_values():
	if altar_type == "blood":
		$label.text = str(Global.altar_lifes)
	if altar_type == "gem":
		$label.text = str(Global.altar_gems)

func level_up_altar():
	Global.play_sound(Global.AltarSfx)
	if altar_type == "blood":
		Global.altar_lifes += 1
		Global.altar_points += 4
	if altar_type == "gem":
		Global.altar_gems += 1
		Global.altar_points += 0.2
	set_values()
	var need = Global.calc_points_level()
	if Global.altar_points > need:
		Global.altar_level_up()

func _on_Area2D_body_entered(body):
	if body.is_in_group("players"):
		_player = body
		if !entered:
			entered = true
			if Global.zombie and price_what == "life":
				return
			else:
				if Global.pay_price(body, price_what, price_amount):
					level_up_altar()

func _on_Area2D_body_exited(body):
	if entered and body.is_in_group("players"):
		entered = false
		in_ttl = 0
		pay_ttl = 0
