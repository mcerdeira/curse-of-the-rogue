extends KinematicBody2D
var life = 0
var dmg = 0
var iamasign_ttl = 0.9
var iamasign = true
var impulse_speed = 100
var speed = 0
var speed_total = 0
var point_chase = null
var player_chase = null
var particle = preload("res://scenes/particle2.tscn")
var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
var dead = false
var impulse = null
var hit_ttl = 0
var hit_ttl_total = 0.2
export var enemy_type = ""
var shoot_ttl = 0
var shoot_ttl_total = 0
var shoot_type = false
var stop_moving = 0
var spawner = null
var chase_player = true

func _ready():
	$shadow.visible = false
	$sprite.animation = "sign"
	$area.add_to_group("enemies")

func emit():
	var p = particle.instance()
	var root = get_node("/root")
	root.add_child(p)
	p.set_position(to_global(p.position))
	p = particle.instance()
	get_parent().add_child(p)
	p.set_position(to_global(p.position))

func _physics_process(delta):
	if !iamasign:
		enemy_behaviour(delta)
	else:
		if iamasign_ttl > 0:
			iamasign_ttl -= 1 * delta
		if iamasign_ttl <= 0:
			emit()
			find_player()
			set_type(enemy_type)
			$shadow.visible = true
			$shadow.animation = enemy_type
			iamasign = false
			
func find_player():
	player_chase = get_tree().get_nodes_in_group("players")[0]

func shoot():
	if enemy_type == "skeleton":
		var bone = EnemyBullet.instance()
		bone.type = "bone"
		get_parent().add_child(bone)
		bone.set_position(position)

func enemy_behaviour(delta):
	if Global.GAME_OVER:
		if dead:
			die()
		$sprite.playing = false
		return
		
	if speed < speed_total:
		speed += 5 * delta
	
	face_player()
	if stop_moving > 0:
		stop_moving -= 1 * delta
	
	if shoot_type:
		shoot_ttl -= 1 * delta
		if stop_moving <= 0 and shoot_ttl <= shoot_ttl_total / 2:
			stop_moving = 1
		
		if shoot_ttl <= 0:
			if !chase_player:
				point_chase = spawner.get_random_point()
				
			shoot_ttl = shoot_ttl_total
			if Global.pick_random([true, false]):
				shoot_ttl = 0.1
			
			shoot()
	
	if hit_ttl > 0:
		$sprite.playing = false
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			hit_ttl = 0
			$sprite.playing = true
			impulse = null
	
	if !dead and hit_ttl <= 0:
		if chase_player:
			var direction = (player_chase.position - self.position).normalized()
			if player_chase.position.distance_to(position) <= 2:
				stop_moving = 1
						
			if stop_moving <= 0:
				move_and_slide(speed * direction)
		else:
			if point_chase == null:
				point_chase = spawner.get_random_point()
				
			var direction = (point_chase.position - self.position).normalized()
			if stop_moving <= 0:
				move_and_slide(speed * direction)
	
	if impulse:
		move_and_slide((-impulse_speed*5) * impulse)
	
	if dead and hit_ttl <= 0:
		die()
	
func face_player():
	if position.x > player_chase.position.x:
		$sprite.scale.x = 1
	else:
		$sprite.scale.x = -1
	
func set_type(_type):
	enemy_type = _type
	
	$sprite.animation = enemy_type
	if enemy_type == "bat":
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		speed = 0
		speed_total = 0
		life = 1
		dmg = 1
		chase_player = true
		
	if enemy_type == "scorpion":
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		speed = 100
		speed_total = 200
		life = 1
		dmg = 1
		chase_player = true
		
	elif enemy_type == "skeleton":
		shoot_ttl_total = Global.pick_random([5, 3, 2])
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 80
		speed_total = 80
		life = 2
		dmg = 2
		chase_player = Global.pick_random([true, false])
		
func hit(origin, dmg:= 1):
	if !iamasign:
		life -= dmg
		hit_ttl = hit_ttl_total
		impulse = (origin.position - self.position).normalized()
		if life <= 0:
			dead = true

func die():
	if !iamasign:
		emit()
		queue_free()

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		body.hit(dmg, self)
