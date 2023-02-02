extends KinematicBody2D
var type = ""
var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
var particle = preload("res://scenes/particle2.tscn")
var speed_rot = 10
var speed_total = 100
var speed = 0
var dis = 110
var player = null
var angle = 0
var shoot_ttl_total = 1.4
var shoot_ttl = shoot_ttl_total

func _ready():
	emit()

func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
		
func create_bullet_nodir():
	var bullet = PlayerBullet.instance()
	bullet.type = "grandpa_photo"

	var root = get_node("/root/Main")
	root.add_child(bullet)
	bullet.global_position = global_position
		
func shoot():
	if type == "grandpa_photo":
		var _chase = get_tree().get_nodes_in_group("enemy_objects")
		if _chase.size() > 0:
			create_bullet_nodir()
		
func orbital_behaviour(delta):
	z_index = global_position.y + 16
	if type == "grandpa_photo":
		shoot_ttl -= 1 * delta
		if shoot_ttl <= 0:
			shoot_ttl = shoot_ttl_total
			emit()
			shoot()

func _physics_process(delta):
	if !player:
		var p = get_tree().get_nodes_in_group("players")
		if p.size() > 0:
			player = p[0]
			
	if position.x > player.position.x:
		$sprite.scale.x = -1
	else:
		$sprite.scale.x = 1
	
	var direction = (player.position - self.position).normalized()
	if player.position.distance_to(position) >= dis:
		speed += 100 * delta
		if speed >= speed_total:
			speed = speed_total
	else:
		speed -= 160 * delta
		if speed <= 0:
			speed = 0
	
	if speed != 0:
		move_and_slide(speed * direction)

	orbital_behaviour(delta)
