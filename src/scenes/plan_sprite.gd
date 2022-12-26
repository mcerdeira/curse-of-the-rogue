extends AnimatedSprite
var destroyed = false
var particle = preload("res://scenes/particle2.tscn")
var vegetation = false
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
	enemy_inst.iamasign_ttl = -1
	
	var root = get_node("/root/Main")
	root.add_child(enemy_inst)
	enemy_inst.global_position = global_position
	
func drop_gem():
	var count = 1
	
	for i in range(count):
		var p = Gem.instance()
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

func _destroy():
	emit()
	if !destroyed:
		destroyed = true
		if Global.pick_random([true, false]):
			if Global.pick_random([true, true, false]):
				drop_gem()
			else:
				drop_scorpion()
		queue_free()
