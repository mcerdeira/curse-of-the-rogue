extends KinematicBody2D
var texts = null
var enemy = preload("res://scenes/Enemy.tscn")
var hit_texts = [
				"OUCH!!",
				"AWWWWWW...",
				"Stop!",
				"Please DON'T!!!",
				"Why?... WHY????",
				"What are you doing?",
				"$%$&%/&(/()!'$$%&)"
				]
var life = 10
var hit_ttl = 0
var hit_ttl_total = 0.2

func _ready():
	$area.add_to_group("shop_keeper")
	if Global.FLOOR_TYPE != Global.floor_types.shop and Global.FLOOR_TYPE != Global.floor_types.supershop:
		queue_free()
	else:
		if Global.FLOOR_TYPE == Global.floor_types.supershop:
			$sprite.animation = "super"
			if Global.only_supershops:
				texts = [
					"50% OFF!!!!",
					"Welcome my friend!! Wanna buy some cool stuff?",
					"Thanks for helping me out!!!"
				]
			else:
				texts = ["I want to eliminate competition so I can lower the prices..."]
			
		elif Global.FLOOR_TYPE == Global.floor_types.shop:
			texts = [
				"...",
				"AAAAAAAAAAAAAAAAHHHHHHHHHHHHHHHH",
				"ZZZ...ZZZ...ZZZ...ZZZ...ZZZ...",
				"Why do you keep coming here and don´t ever talk to me?",
				"Sometimes, I feel so lonely...",
				"I heard someone very brave came back from death",
				"Have you found happiness?",
				"How many floors are there?",
				"This place seems to be different everyday, but nobody believes me.",
				"I used to have a family... I think!",
				"Do I have a name? I can't remember...",
				"I hate selling things, why can't I just go home?"
			]
			if Global.PREMIUM_ITEMS.size() > 0:
				var item = Global.pick_random(Global.PREMIUM_ITEMS)
				var line = "Did you heard about the " + item.description + "? I don't sell it, anyways!"
				texts.append(line)

		$dialog_text.text = Global.pick_random(texts)
		
func OuchSfx():
	var options = {"pitch_scale": 0.6}
	Global.play_sound(Global.PlayerHurt, options)
		
func hit(origin, dmg, from):
	if visible:
		if $sprite.animation == "default":
			$dialog_text.text = Global.pick_random(hit_texts)
			life -= dmg
		else:
			$dialog_text.text = "DON'T EVEN TRY IT."
		
		hit_ttl = hit_ttl_total
		if life > 0:
			OuchSfx()
		else:
			awake()
			
func awake():
	visible = false
	destroy_items()
	open_doors()
	create_miniboss()
	queue_free()
	
func destroy_items():
	var items = get_tree().get_nodes_in_group("stat_wheel")
	for i in items:
		i.queue_free()
	
	items = get_tree().get_nodes_in_group("items_pedestals")
	for i in items:
		i.queue_free()

func open_doors():
	var items = get_tree().get_nodes_in_group("doors")
	for i in items:
		i.close_door()
	
func create_miniboss():
	Global.MainThemePlaying = false
	Music.play(Global.BossBattle, 0.7)
	var type  = "shop_keeper"
	var enemy_inst = null
	enemy_inst = enemy.instance()
	enemy_inst.enemy_type = type
	enemy_inst.iamasign_ttl = -1
	enemy_inst.global_position = global_position
	
	var root = get_node("/root/Main")
	root.add_child(enemy_inst)
	
func _physics_process(delta):
	if hit_ttl > 0:
		$sprite.material.set_shader_param("hitted", true)
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			$sprite.material.set_shader_param("hitted", false)
			hit_ttl = 0
	
	z_index = position.y
	$dialog.rotation_degrees = randi() % 2 * Global.pick_random([1, -1])
