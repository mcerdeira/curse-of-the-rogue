extends StaticBody2D
export var altar_type = ""
var price_amount = 1
var price_what = ""

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		queue_free()
	
	$sprite.animation = altar_type
	$sprite2.animation = altar_type
	$sprite3.animation = altar_type
	price_what = "life"
	if altar_type != "blood":
		price_what = "gems"
		$skull_spr.visible = false

func level_up_altar():
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("players") and Global.pay_price(body, price_what, price_amount):
		level_up_altar()
