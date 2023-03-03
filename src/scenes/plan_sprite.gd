extends AnimatedSprite
var destroyed = false
var particle = preload("res://scenes/particle2.tscn")
var vegetation = false
var Sign = preload("res://scenes/Sign.tscn")
var Gem = preload("res://scenes/Gem.tscn")
var enemy = preload("res://scenes/Enemy.tscn")

func _ready():
	initialize_me()

func _physics_process(delta):
	if !vegetation and get_parent().vegetation:
		vegetation = true
		initialize_me()
	
	z_index = global_position.y + 16
	
func drop_scorpion():
	var type  = "scorpion+"
	var enemy_inst = null

	enemy_inst = enemy.instance()
	enemy_inst.enemy_type = type
	enemy_inst.iamasign_ttl = 0.5
	
	var root = get_node("/root/Main")
	root.add_child(enemy_inst)
	enemy_inst.global_position = global_position
	
func drop_gem():
	var item = "gem"
	if Global.pick_random([true, true, true, false]):
		item = "gem"
	else:
		item = Global.pick_random(["life", "key"])
	
	var p = Gem.instance()
	p.type = item
	p._init_sprite()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
	
func initialize_me():
	var posi = []
	if vegetation:
		posi = ["1", "1", "2", "2", "no", "no", "no", "no"]
	else:
		posi = ["1", "1", "2", "2", "3", "no", "no", "no", "no", "no"]
	animation = Global.pick_random(posi)
	if animation == "no":
		destroyed = true
		queue_free()
	
func emit():
	var p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
	p = particle.instance()
	get_parent().add_child(p)
	p.global_position = global_position
	
func destroy_silent():
	queue_free()

func create_sign(text, shake, color_override, disappear, goup):
	var s = Sign.instance()
	s.text = text
	s.shake = shake
	s.disappear = disappear
	s.color_override = color_override
	s.goup = goup
	var root = get_node("/root/Main")
	root.add_child(s)
	s.global_position = global_position

func _destroy():
	var cur = Global.add_combo()
	if cur > 0:
		create_sign(str(cur), false, Color8(238, 182, 47), true, true)
	
	Global.play_sound(Global.PropsSfx)
	emit()
	if !destroyed:
		destroyed = true
		if Global.FLOOR_TYPE != Global.floor_types.ending and Global.pick_random([true, false]):
			if Global.pick_random([true, true, true, true, false]):
				drop_gem()
			else:
				drop_scorpion()
		queue_free()
