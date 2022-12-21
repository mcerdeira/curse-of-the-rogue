extends StaticBody2D
export var altar_type = ""
var price_amount = 1
var price_what = ""

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.altar:
		queue_free()
	
	set_values()
	$sprite.animation = altar_type
	$sprite2.animation = altar_type
	$sprite3.animation = altar_type
	price_what = "life"
	if altar_type != "blood":
		price_what = "gems"
		$skull_spr.visible = false
	else:
		$label.add_color_override("font_color", Color8(235, 40, 40))
		
		
func set_values():
	if altar_type == "blood":
		$label.text = str(Global.altar_lifes)
	if altar_type == "gem":
		$label.text = str(Global.altar_gems)

func level_up_altar():
	if altar_type == "blood":
		Global.altar_lifes += 1
		Global.altar_points += 10
	if altar_type == "gem":
		Global.altar_gems += 1
		Global.altar_gems += 1
	set_values()

func _on_Area2D_body_entered(body):
	if !Global.zombie and body.is_in_group("players") and Global.pay_price(body, price_what, price_amount):
		level_up_altar()
