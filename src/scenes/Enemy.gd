extends KinematicBody2D
var life = 0
var dmg = 0
var iamasign_ttl = 0.9
var iamasign = true
var impulse_speed = 120
var speed = 0
var speed_total = 0
var point_chase = null
var player_chase = null
var particle = preload("res://scenes/particle2.tscn")
var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
var Gem = preload("res://scenes/Gem.tscn")
var dead = false
var impulse = null
var hit_ttl = 0
var hit_ttl_total = 0.2
export var enemy_type = ""
var stoped = false
var shoot_ttl = 0
var shoot_ttl_total = 0
var shoot_type = false
var stop_moving = 0
var spawner = null
var chase_player = true
var flying = false
var stopandgo = false
var stopandgo_ttl = 0
var is_enemy_group = false
var infected = false
var poisoned = false
var shoot_on_die = false
var disapear = false
var invisible_time = 0
var invisible_time_total = 1

func _ready():
	$shadow.visible = false
	$sprite.animation = "sign"
	$area.add_to_group("enemies")

func emit(colored:=false):
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
		if colored:
			if infected:
				p.color = Global.infected_color
			else:
				p.color = Global.poisoned_color
		
func drop_gem():
	var count = 1
	
	for i in range(count):
		var p = Gem.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position

func _physics_process(delta):
	if !iamasign:
		if poisoned:
			if randi() % 100 + 1 == 100:
				emit()
			
			hit(null, 1 * delta, "")
			
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
	
func create_enemy_bullet(pos):
	var fire_ball = EnemyBullet.instance()
	fire_ball.type = "fire_ball"
	fire_ball.dir = pos
	get_parent().add_child(fire_ball)
	fire_ball.set_position(position)
	
func shoot_die():
	if enemy_type == "ghost":
		create_enemy_bullet(Vector2(0, 1))
		create_enemy_bullet(Vector2(0, -1))
		
		create_enemy_bullet(Vector2(1, 0))
		create_enemy_bullet(Vector2(1, 1))
		create_enemy_bullet(Vector2(1, -1))
		
		create_enemy_bullet(Vector2(-1, 0))
		create_enemy_bullet(Vector2(-1, 1))
		create_enemy_bullet(Vector2(-1, -1))
		
	if enemy_type == "dead_fire":
		create_enemy_bullet(Vector2(1, 0))
		create_enemy_bullet(Vector2(-1, 0))
		create_enemy_bullet(Vector2(0, 1))
		create_enemy_bullet(Vector2(0, -1))

func shoot():
	emit()
	if enemy_type == "bat":
		var fire_ball = EnemyBullet.instance()
		fire_ball.type = "fire_ball"
		get_parent().get_parent().add_child(fire_ball)
		fire_ball.global_position = global_position
	if enemy_type == "skeleton":
		var bone = EnemyBullet.instance()
		bone.type = "bone"
		get_parent().add_child(bone)
		bone.set_position(position)
	if enemy_type == "dead_fire":
		var fire_ball = EnemyBullet.instance()
		fire_ball.type = "fire_ball"
		get_parent().add_child(fire_ball)
		fire_ball.set_position(position)
	if enemy_type == "ghost":
		invisible_time = 0
		var fire_ball = EnemyBullet.instance()
		fire_ball.type = "fire_ball"
		get_parent().add_child(fire_ball)
		fire_ball.set_position(position)

func enemy_behaviour(delta):
	if Global.GAME_OVER:
		if dead:
			die()
		$sprite.playing = flying
		return
				
	if stopandgo:
		stopandgo_ttl -= 1 * delta
		if stopandgo_ttl <= 0:
			stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
			if stoped:
				stoped = false
				stop_moving = 0
			else:
				stoped = true
				stop_moving = stopandgo_ttl
		
	
	face_player()
		
	if stop_moving > 0:
		if !flying:
			$sprite.playing = false
		stop_moving -= 1 * delta
	else:
		if speed < speed_total:
			speed += 5 * delta
		
		if !flying:
			$sprite.playing = true
	
	if shoot_type:
		shoot_ttl -= 1 * delta
		if stop_moving <= 0 and shoot_ttl <= shoot_ttl_total / 2:
			stop_moving = 1
		
		if shoot_ttl <= 0:
			if disapear:
				emit()
				visible = true
			
			if !chase_player:
				point_chase = spawner.get_random_point()
				
			shoot_ttl = shoot_ttl_total
			if Global.pick_random([true, false]):
				shoot_ttl = 0.1
			
			shoot()
	
	if hit_ttl > 0:
		$sprite.material.set_shader_param("hitted", true)
		$sprite.playing = false
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			$sprite.material.set_shader_param("hitted", false)
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
				if disapear:
					invisible_time += 1 * delta
					if invisible_time >= invisible_time_total:
						invisible_time = 0
						emit()
						visible = false
	
				move_and_slide(speed * direction)
	
	if impulse:
		move_and_slide((-impulse_speed) * impulse)
	
	z_index = position.y
	
	if dead and hit_ttl <= 0:
		die()
	
func face_player():
	if position.x > player_chase.position.x:
		$sprite.scale.x = 1
	else:
		$sprite.scale.x = -1
	
func set_type(_type):
	enemy_type = _type
	$sprite.position.y = 0
	$sprite.animation = enemy_type
	if enemy_type == "ghost":
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", false)
		
		shoot_ttl_total = 7
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 100
		speed_total = 100
		life = 7
		dmg = 2
		chase_player = false
		flying = true
		is_enemy_group = false
		stopandgo = true
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = true
		disapear = true
	
	if enemy_type == "dead_fire":
		$area/collider.set_deferred("disabled", true)
		$area/collider_dead_fire.set_deferred("disabled", false)
		$area/collider_ghost.set_deferred("disabled", true)
		
		shoot_ttl_total = Global.pick_random([5, 3, 2])
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 10
		speed_total = 10
		life = 5
		dmg = 2
		chase_player = true
		flying = true
		is_enemy_group = false
		stopandgo = false
		shoot_on_die = true
		$sprite.position.y = -32
		$shadow.visible = false
		disapear = false
	
	if enemy_type == "bat":
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		
		$collider2.set_deferred("disabled", true)
		shoot_ttl_total = 15
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 0
		speed_total = 0
		life = 1
		dmg = 1
		chase_player = true
		flying = true
		is_enemy_group = true
		stopandgo = false
		shoot_on_die = false
		disapear = false
		
	if enemy_type == "scorpion":
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		speed = 100
		speed_total = 200
		life = 1
		dmg = 1
		chase_player = true
		flying = false
		is_enemy_group = false
		stopandgo = true
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = false
		disapear = false
		
	elif enemy_type == "skeleton":
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		
		shoot_ttl_total = Global.pick_random([5, 3, 2])
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 80
		speed_total = 80
		life = 2
		dmg = 2
		chase_player = Global.pick_random([true, false])
		flying = false
		is_enemy_group = false
		stopandgo = false
		shoot_on_die = false
		disapear = false
		
func hit(origin, dmg, from):
	if visible and !iamasign:
		life -= dmg
		hit_ttl = hit_ttl_total
		
		if Global.poison:
			$sprite.modulate = Global.poisoned_color
			poisoned = true
		
		if is_enemy_group:
			get_parent().stop_moving = 0.5
		
		if origin:
			impulse = (origin.position - self.position).normalized()
		if life <= 0:
			if from == "player":
				Global.add_combo()
			dead = true
		else:
			if from == "player":
				Global.sustain()

func die():
	if visible and !iamasign:
		if Global.pick_random([true, false]):
			drop_gem()
		emit()
		if shoot_on_die:
			shoot_die()
		queue_free()

func _on_area_body_entered(body):
	if visible and !iamasign and body.is_in_group("players"):
		if Global.zombie:
			$sprite.modulate = Global.infected_color
			infected = true
		body.hit(dmg)
