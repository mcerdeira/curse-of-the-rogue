extends Node2D
var particle = preload("res://scenes/particle2.tscn")
var price_amount = 25
var price_what = "gems"
var ttl = 0
var rolling = false
var effect_name = ""
var effect_description = ""
var _player = null
var zoom = 1

func _ready():
	add_to_group("stat_wheel")
	if Global.FLOOR_TYPE != Global.floor_types.altar and Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
		return
	
	var chance = [1, 1, 1, 0]
	if Global.altar_level >= Global.altar_level_max / 2:
		chance = [1, 0, 0]
		
	if Global.altar_level == Global.altar_level_max:
		chance = [0]

	if Global.pick_random(chance) == 1:
		queue_free()
		return
	
	$price_lbl.text = "x" + str(price_amount)
	$wheel.rotation_degrees = rand_range(0, 360)
	
	z_index = global_position.y + 100
	
func _physics_process(delta):
	if rolling:
		$wheel.rotation_degrees += 3 * ttl
		ttl -= Global.pick_random([1, 2]) * delta
		zoom -= 0.07 * delta
		_player.camera_zoom(zoom, zoom)
		if ttl <= 0:
			zoom = 1
			ttl = 0
			rolling = false
			Global.LOGIC_PAUSE = false
			yield(get_tree().create_timer(.6), "timeout") 
			eval_result()
			_player.restore_zoom()
	
func eval_result():
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	HUD.set_message(effect_name, effect_description)
	
	Global.play_sound(Global.WheelSfx)
	
	if effect_name == "Vitality":
		_player.add_heart(1)
		
	if effect_name == "Tired":
		_player.hit(1, "wheel")
	
	if effect_name == "Oh no":
		_player.add_luck(-1)
		_player.one_live()
		
	if effect_name == "Caffeine":
		_player.add_speed(1)
		
	if effect_name == "Free Roll":
		_player.add_gem(price_amount)
		
	if effect_name == "Pumped":
		_player.add_damage(1)
		
	if effect_name == "Weak":
		_player.add_damage(-1)
		
	if effect_name == "Sleepy":
		_player.add_speed(-1)
	
func start_roll():
	Global.LOGIC_PAUSE = true
	rolling = true
	randomize()
	var a = rand_range(1, 3)
	var b = rand_range(1, 3)
	var c = rand_range(1, 3)
	var d = rand_range(0, 1)
	ttl = a + b + c + d

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position

func _on_Area2D_body_entered(body):
	if body.is_in_group("players") and !rolling and Global.pay_price(body, price_what, price_amount):
		_player = body
		emit()
		start_roll()
		rolling = true

func _on_cositor_area_entered(area):
	if rolling and area.is_in_group("wheel_points"):
		Global.play_sound(Global.WheelMoveSfx)
		effect_name = area.effect_name
		effect_description = area.effect_description
