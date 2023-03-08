extends KinematicBody2D
var sleep = false
var pingpong = false
var pong_dir = Vector2.ZERO
var rbull = null
var life = 0
var dmg = 0
var bleeding = false
var shoot_count_total = 0
var shoot_count = 0
var iamasign_ttl = 0.9
var iamasign = true
var impulse_speed = 120
var speed = 0
var speed_total = 0
var point_chase = null
var player_chase = null
var Blood = preload("res://scenes/Blood.tscn")
var Ink = preload("res://scenes/Ink.tscn")
var particle = preload("res://scenes/particle2.tscn")
var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
var Gem = preload("res://scenes/Gem.tscn")
var RotateBullets = preload("res://scenes/RotateBullets.tscn")
var Sign = preload("res://scenes/Sign.tscn")
var enemy = null
var dead = false
var impulse = null
var hit_ttl = 0
var hit_ttl_total = 0.2
export var enemy_type = ""
var stoped = false
var random_shooter = false
var shoot_ttl = 0
var shoot_ttl_total = 0
var shoot_type = false
var stop_moving = 0
var chase_player = true
var flying = false
var stopandgo = false
var stopandgo_ttl = 0
var is_enemy_group = false
var infected = false
var poisoned = false
var shoot_on_die = false
var disapear = false
var leave_trail = false
var trail_ttl_total = 0.1
var trail_ttl = trail_ttl_total
var invisible_time = 0
var invisible_time_total = 1
var froze_effect = 0
var froze_effect_total = 3
var electric_effect = 0
var electric_effect_total = 2
var destiny = null
var falling = false
var dont_drop = false
var fireinmune = false
var falled = false
var _in_water = false
var angle_walker = false
var troll_angle_limit = 4.6
var troll_angle = 0
var troll_angle_dir = 1
var inmune_while_moving = false
var inmune_now = false
var match_xy = false
var match_coor = ""

func _ready():
	add_to_group("enemy_objects")
	$shadow.visible = false
	$sprite.animation = "sign"
	$area.add_to_group("enemies")
	
func ink():
	for i in range(Global.pick_random([1, 2])):
		var p = Ink.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
	
func bleed():
	if randi() % 7 == 0:
		drop_life()
	
	for i in range(Global.pick_random([1, 2])):
		var p = Blood.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position

func emit(colored=false):
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
		
func drop_life():
	var p = Gem.instance()
	p.type = "life"
	p._init_sprite()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
	
func drop_key():
	var p = Gem.instance()
	p.type = "key"
	p._init_sprite()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
		
func drop_gem():
	var count = 1
	
	if randi() % 15 == 0:
		drop_key()
	else:
		for i in range(count):
			var p = Gem.instance()
			var root = get_node("/root/Main")
			root.add_child(p)
			p.global_position = global_position

func _physics_process(delta):
	if !iamasign:
		if bleeding:
			if randi() % 100 + 1 == 100:
				bleed()
				hit(null, 1 * delta, "bleed_fx")
		
		if poisoned:
			if randi() % 100 + 1 == 100:
				emit()
			
			hit(null, 1 * delta, "poison_fx")
			
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
	
func create_enemy_bullet(pos, effect=""):
	if randi() % 10 == 0:
		emit()
	
	var fire_ball = EnemyBullet.instance()
	fire_ball.type = "fire_ball"
	fire_ball.dir = pos
	fire_ball.from = enemy_type
	if effect:
		fire_ball.effect_name = effect
		fire_ball.type = effect + "_ball"
	
	get_parent().add_child(fire_ball)
	fire_ball.set_position(position)
	
func shoot_die():
	if !falled:
		if enemy_type == "spider":
			enemy = load("res://scenes/Enemy.tscn")
			var options = {"pitch_scale": 2}
			Global.play_sound(Global.SpiderSfx, options)
			var count = Global.pick_random([5, 3, 7])
			for i in range(count):
				var type  = "spider_xs"
				var enemy_inst = null

				enemy_inst = enemy.instance()
				enemy_inst.enemy_type = type
				enemy_inst.iamasign_ttl = -1
				
				var root = get_node("/root/Main")
				root.add_child(enemy_inst)
				
				var m = Global.pick_random([1, -1])
				
				var pos = Vector2.ZERO
				pos.x = global_position.x + i * 5 * m
				pos.y = global_position.y + i * 5 * m
				
				enemy_inst.global_position = pos
				
		if enemy_type == "shop_keeper":
			var doors = get_tree().get_nodes_in_group("doors")
			for d in doors:
				d.open_door()
			
			Global.only_supershops = true
			Global.play_sound(Global.LevelEndSfx)
			
			create_enemy_bullet(Vector2(0, 1))
			create_enemy_bullet(Vector2(0, -1))
			
			create_enemy_bullet(Vector2(1, 0))
			create_enemy_bullet(Vector2(1, 1))
			create_enemy_bullet(Vector2(1, -1))
			
			create_enemy_bullet(Vector2(-1, 0))
			create_enemy_bullet(Vector2(-1, 1))
			create_enemy_bullet(Vector2(-1, -1))
			
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
		
func in_water():
	if visible and !iamasign:
		_in_water = true
	
func out_water():
	if visible and !iamasign:
		_in_water = false
		
func trail():
	if !falled:
		if enemy_type == "dead_fire":
			emit()
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_trail"
			fire_ball.from = enemy_type
			get_parent().add_child(fire_ball)
			fire_ball.set_position(position)
		if enemy_type == "squid":
			ink()
			
func remove_rotate_bullet():
	if rbull != null:
		rbull.queue_free()
		rbull = null
		emit()
			
func add_rotatebullet():
	if enemy_type == "idol" and rbull == null:
		emit()
		rbull = RotateBullets.instance()
		rbull.from = enemy_type
		add_child(rbull)

func shoot():
	if froze_effect <= 0:
		emit()
		$sprite.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$sprite.material.set_shader_param("shoot_prev", false)
		yield(get_tree().create_timer(0.2), "timeout") 
		$sprite.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$sprite.material.set_shader_param("shoot_prev", false)
		
		if enemy_type == "bloby":
			if Global.pick_random([true, false]):
				create_enemy_bullet(Vector2(0, 1), "poison")
				create_enemy_bullet(Vector2(0, -1), "poison")
				
				create_enemy_bullet(Vector2(1, 0), "poison")
				create_enemy_bullet(Vector2(-1, 0), "poison")
			else:
				create_enemy_bullet(Vector2(1, 1), "poison")
				create_enemy_bullet(Vector2(1, -1), "poison")
				create_enemy_bullet(Vector2(-1, 1), "poison")
				create_enemy_bullet(Vector2(-1, -1), "poison")
				
		if enemy_type == "shop_keeper":
			create_enemy_bullet(Vector2(0, 1))
			create_enemy_bullet(Vector2(0, -1))
			
			create_enemy_bullet(Vector2(1, 0))
			create_enemy_bullet(Vector2(1, 1))
			create_enemy_bullet(Vector2(1, -1))
			
			create_enemy_bullet(Vector2(-1, 0))
			create_enemy_bullet(Vector2(-1, 1))
			create_enemy_bullet(Vector2(-1, -1))
				
		if enemy_type == "squid":
			create_enemy_bullet(Vector2(0, 1))
			create_enemy_bullet(Vector2(0, -1))
			
			create_enemy_bullet(Vector2(1, 0))
			create_enemy_bullet(Vector2(1, 1))
			create_enemy_bullet(Vector2(1, -1))
			
			create_enemy_bullet(Vector2(-1, 0))
			create_enemy_bullet(Vector2(-1, 1))
			create_enemy_bullet(Vector2(-1, -1))
				
		if enemy_type == "spider":
			create_enemy_bullet(Vector2(0, 1))
			create_enemy_bullet(Vector2(0, -1))
			
			create_enemy_bullet(Vector2(1, 0))
			create_enemy_bullet(Vector2(1, 1))
			create_enemy_bullet(Vector2(1, -1))
			
			create_enemy_bullet(Vector2(-1, 0))
			create_enemy_bullet(Vector2(-1, 1))
			create_enemy_bullet(Vector2(-1, -1))
			
		if enemy_type == "troll":
			Global.play_sound(Global.TrollSfx)
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_ball"
			fire_ball.from = enemy_type
			get_parent().get_parent().add_child(fire_ball)
			fire_ball.global_position = global_position
			
		if enemy_type == "mushroom_guy":
			Global.play_sound(Global.TrollSfx)
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_ball"
			fire_ball.from = enemy_type
			fire_ball.effect_name = "mushroom"
			
			get_parent().get_parent().add_child(fire_ball)
			fire_ball.global_position = global_position
	
		if enemy_type == "bat":
			Global.play_sound(Global.BatsSfx)
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_ball"
			fire_ball.from = enemy_type
			get_parent().get_parent().add_child(fire_ball)
			fire_ball.global_position = global_position
			
		if enemy_type == "idol":
			create_enemy_bullet(Vector2(0, 1))
			create_enemy_bullet(Vector2(0, -1))
			
			create_enemy_bullet(Vector2(1, 0))
			create_enemy_bullet(Vector2(-1, 0))
			
		if enemy_type == "skeleton":
			Global.play_sound(Global.SkeleShootSfx)
			var bone = EnemyBullet.instance()
			bone.type = "bone"
			bone.from = enemy_type
			get_parent().add_child(bone)
			bone.set_position(position)
		if enemy_type == "dead_fire":
			Global.play_sound(Global.DeadFireShootSfx)
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_ball"
			fire_ball.from = enemy_type
			get_parent().add_child(fire_ball)
			fire_ball.set_position(position)
		if enemy_type == "tentacle":
			Global.play_sound(Global.GhostShootSfx)
			invisible_time = 0
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_ball"
			fire_ball.from = enemy_type
			get_parent().add_child(fire_ball)
			fire_ball.set_position(position)
		if enemy_type == "ghost":
			Global.play_sound(Global.GhostShootSfx)
			invisible_time = 0
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_ball"
			fire_ball.from = enemy_type
			get_parent().add_child(fire_ball)
			fire_ball.set_position(position)
			
func fall():
	if visible and !iamasign:
		Global.play_sound(Global.FallingSfx)
		dont_drop = true
		falling = true
		falled = true
		$sprite.scale.x = 1
		$sprite.scale.y = 1
		$shadow.visible = false
		$sprite.playing = false
		return true
	else:
		return false
			
func stop_fall():
	falling = false
	falled = true
	$sprite.scale.x = 0
	$sprite.scale.y = 0
	$sprite.rotation = 0
	hit(null, 999, "hole")
	
func flip_match_coor():
	if match_coor == "":
		match_coor = Global.pick_random(["x", "y"])
	elif match_coor == "x":
		match_coor = "y"
	elif match_coor == "y":
		match_coor = "x"

func enemy_behaviour(delta):
	if falling:
		$sprite.rotation += 5 * delta
		$sprite.scale.x -= 2 * delta
		$sprite.scale.y = $sprite.scale.x
		if $sprite.scale.x <= 0:
			stop_fall()
			
		return
		
	if sleep:
		return
		
	if Global.GAME_OVER:
		if dead:
			die()
		$sprite.playing = flying
		return
		
	if electric_effect > 0:
		var dests = get_tree().get_nodes_in_group("enemy_objects")
		while(true):
			randomize()
			dests.shuffle()
			
			destiny = dests[0]
			
			var id = self.get_instance_id()
			var id1 = destiny.get_instance_id()
				
			if id == id1:
				destiny = null
							
			if destiny and is_instance_valid(destiny):
				if destiny.electric_effect <= 0:
					destiny.electric_effect = electric_effect_total
					destiny.hit(null, 0.5, "electricity_fx")
					
				update()
			else:
				update()
				
			if destiny or dests.size() == 1:
				break
				
		electric_effect -= 1 * delta
		if electric_effect <= 0:
			update()
			
	if angle_walker:
		if troll_angle_dir == 1:
			troll_angle += 20 * delta
			if troll_angle >= troll_angle_limit:
				troll_angle_dir = -1
		else:
			troll_angle -= 20 * delta
			if troll_angle <= -troll_angle_limit:
				troll_angle_dir = 1
				
		$sprite.rotation_degrees = troll_angle
		
	if random_shooter:
		if randi() % 500 == 0:
			shoot()
		
	if froze_effect > 0:
		$sprite.modulate = Global.froze_color
		stop_moving = 1
		froze_effect -= 1 * delta
		if froze_effect <= 0:
			$sprite.modulate = Color8(255, 255, 255)
			stop_moving = 0
				
	if stopandgo:
		stopandgo_ttl -= 1 * delta
		if stopandgo_ttl <= 0:
			stopandgo_ttl = Global.pick_random([5, 3, 1])
			if stoped:
				stoped = false
				stop_moving = 0
			else:
				stoped = true
				stop_moving = stopandgo_ttl
		
	
	face_player()
	
	if leave_trail:
		trail_ttl -= 1 * delta
		if trail_ttl <= 0:
			trail_ttl = trail_ttl_total
			trail()
		
	if stop_moving > 0:
		if !flying:
			$sprite.playing = false
		stop_moving -= 1 * delta
		if stop_moving <= 0:
			flip_match_coor()
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
				point_chase = Global.SPAWNER.get_random_point()
				
			shoot_ttl = shoot_ttl_total
			
			shoot_count -= 1
			
			var add_again = false
			if shoot_count <= 0:
				shoot_count = Global.pick_random(shoot_count_total)
				add_again = true
			else:
				shoot_ttl = 0.1
			
			remove_rotate_bullet()
			
			shoot()
			if add_again:
				add_rotatebullet()
	
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
		if match_xy:
			if match_coor == "":
				flip_match_coor()
			else:
				var pos = Vector2.ZERO
				if match_coor == "x":
					pos.x = player_chase.position.x
					pos.y = position.y
					
				elif match_coor == "y":
					pos.x = position.x
					pos.y = player_chase.position.y
			
				var direction = (pos - self.position).normalized()
				if pos.distance_to(position) <= 2:
					flip_match_coor()
					stop_moving = 1
							
				if stop_moving <= 0:
					move_and_slide(speed * direction)
		
		elif pingpong:
			if stop_moving <= 0:
				if pong_dir == Vector2.ZERO:
					var xx = speed * rand_range(2, 4) * Global.pick_random([1,-1])
					var yy = speed * rand_range(2, 4) * Global.pick_random([1,-1])
					
					pong_dir = Vector2(xx, yy)
					
				var prev_velocity = pong_dir
				pong_dir = move_and_slide(pong_dir)
				
				if get_slide_count() > 0:
					if Global.pick_random([true, false]):
						shoot()
					emit()
					pong_dir = prev_velocity.bounce(get_slide_collision(0).normal)
			
		elif chase_player:
			var direction = (player_chase.position - self.position).normalized()
			if player_chase.position.distance_to(position) <= 2:
				stop_moving = 1
						
			if stop_moving <= 0:
				move_and_slide(speed * direction)
		else:
			if point_chase == null:
				point_chase = Global.SPAWNER.get_random_point()
				
			var direction = (point_chase.position - self.position).normalized()
			if stop_moving <= 0:
				if inmune_while_moving:
					inmune_now = true
					if randi() % 15 == 0:
						emit()
					$sprite.animation = enemy_type + "_inmune"
					
				if disapear:
					invisible_time += 1 * delta
					if invisible_time >= invisible_time_total:
						invisible_time = 0
						emit()
						visible = false
	
				move_and_slide(speed * direction)
			else:
				if inmune_while_moving:
					inmune_now = false
					$sprite.animation = enemy_type
				
	if _in_water:
		move_and_slide(Vector2(0, Global.water_speed))
	
	if impulse:
		move_and_slide((-impulse_speed) * impulse)
	
	z_index = position.y
	
	if dead and hit_ttl <= 0:
		die()
	
func face_player():
	if froze_effect <= 0:
		if position.x > player_chase.position.x:
			$sprite.scale.x = 1
		else:
			$sprite.scale.x = -1
	
func set_type(_type):
	enemy_type = _type
	$sprite.position.y = 0
	$sprite.animation = enemy_type
	
	var life_mult = 1
	if Global.has_idol_mask:
		$sprite/weak_fx.visible = true
		life_mult = 0.5
	
	add_rotatebullet()
	
	if enemy_type != "bloby":
		$Line2D.queue_free()
	else:
		$Line2D.visible = true
	
	if enemy_type == "bloby":
		var options = {"pitch_scale": 2.5}
		Global.play_sound(Global.SpiderSfx, options)
		life = 4 * life_mult
		speed = 100
		speed_total = 100
		shoot_on_die = false
		shoot_ttl_total = 3
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		pingpong = true
		shoot_count_total = [3, 6, 9]
		shoot_count = Global.pick_random(shoot_count_total)
		
		stopandgo = false
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)

		dmg = 1
		chase_player = false
		flying = true
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
		
	if enemy_type == "tentacle":
		Global.play_sound(Global.GhostSfx)
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", false)
		$area/collider_squid.set_deferred("disabled", true)
		$sprite.animation = enemy_type + "_inmune"
		shoot_count_total = [1, 2]
		shoot_count = Global.pick_random(shoot_count_total)
		shoot_ttl_total = 7
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 100
		speed_total = 100
		life = 3 * life_mult
		dmg = 1
		chase_player = false
		flying = true
		fireinmune = true
		is_enemy_group = false
		stopandgo = true
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = true
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = true
	
	if enemy_type == "ghost":
		Global.play_sound(Global.GhostSfx)
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", false)
		$area/collider_squid.set_deferred("disabled", true)
		shoot_count_total = [1, 2]
		shoot_count = Global.pick_random(shoot_count_total)
		shoot_ttl_total = 7
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 100
		speed_total = 100
		life = 3 * life_mult
		dmg = 1
		chase_player = false
		flying = true
		fireinmune = true
		is_enemy_group = false
		stopandgo = true
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = true
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = true

	if enemy_type == "squid":
		Global.play_sound(Global.DeadFireSfx)
		$area/collider.set_deferred("disabled", true)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", false)
		
		shoot_ttl_total = Global.pick_random([5, 3, 2])
		shoot_ttl = shoot_ttl_total
		
		shoot_count_total = [1, 2]
		shoot_count = Global.pick_random(shoot_count_total)
		
		shoot_type = true
		speed = 130
		speed_total = 130
		life = 5 * life_mult
		dmg = 1
			
		flying = true
		fireinmune = true
		is_enemy_group = false
		stopandgo = false
		shoot_on_die = false
		$shadow.visible = true
		disapear = false
		leave_trail = true
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
		match_xy = true
		
	if enemy_type == "dead_fire":
		Global.play_sound(Global.DeadFireSfx)
		$area/collider.set_deferred("disabled", true)
		$area/collider_dead_fire.set_deferred("disabled", false)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)
		
		shoot_ttl_total = Global.pick_random([5, 3, 2])
		shoot_ttl = shoot_ttl_total
		
		shoot_count_total = [1, 2]
		shoot_count = Global.pick_random(shoot_count_total)
		
		shoot_type = true
		speed = 150
		speed_total = 150
		life = 5 * life_mult
		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = true
			
		flying = false
		fireinmune = true
		is_enemy_group = false
		stopandgo = false
		shoot_on_die = true
		$sprite.position.y = -32
		$shadow.visible = false
		disapear = false
		leave_trail = true
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
	
	if enemy_type == "bat":
		Global.play_sound(Global.BatsSfx)
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)
		
		$collider2.set_deferred("disabled", true)
		shoot_ttl_total = 15
		shoot_ttl = shoot_ttl_total
		
		shoot_count_total = [5]
		shoot_count = Global.pick_random(shoot_count_total)
		
		shoot_type = true
		speed = 0
		speed_total = 0
		life = 1 * life_mult
		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = true
		
		flying = true
		fireinmune = false
		is_enemy_group = true
		stopandgo = false
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = true
		inmune_while_moving = false
		
	if enemy_type == "idol":
		var options = {"pitch_scale": 0.5}
		Global.play_sound(Global.TrollSfx, options)
		
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", false)
		$area/collider_squid.set_deferred("disabled", true)
		
		shoot_count_total = [45]
		shoot_count = Global.pick_random(shoot_count_total)
		
		shoot_ttl_total = 7
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 60
		speed_total = 60
		life = 8 * life_mult
		dmg = 1
		chase_player = false
		flying = true
		fireinmune = true
		is_enemy_group = false
		stopandgo = true
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = true
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
		
	if enemy_type == "shop_keeper":
		life = 25
		speed = 230
		speed_total = 260
		shoot_on_die = true
		shoot_ttl_total = 3
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		
		shoot_count_total = [9, 12, 15]
		shoot_count = Global.pick_random(shoot_count_total)
		
		stopandgo = true
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", false)
		$area/collider_squid.set_deferred("disabled", true)

		dmg = 1
		chase_player = true
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		disapear = false
		leave_trail = false
		angle_walker = true
		random_shooter = false
		inmune_while_moving = false
		
	if enemy_type == "mushroom_guy":
		var options = {"pitch_scale": 1.5}
		Global.play_sound(Global.TrollSfx, options)
		life = 8 * life_mult
		speed = 30
		speed_total = 30
		stopandgo = false
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = true
			
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = true
		random_shooter = true
		inmune_while_moving = false
		
	if enemy_type == "troll":
		var options = {"pitch_scale": 0.5}
		Global.play_sound(Global.TrollSfx, options)
		life = 6 * life_mult
		speed = 30
		speed_total = 30
		stopandgo = false
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = true
			
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = true
		random_shooter = true
		inmune_while_moving = false
		
	if enemy_type == "chest_closed":
		life = 3 * life_mult
		speed = 180
		speed_total = 200
		stopandgo = false
		
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)
		sleep = true
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = true
			
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
		
	if enemy_type == "scorpion" or enemy_type == "scorpion+":
		Global.play_sound(Global.ScorpionSfx)
		if enemy_type == "scorpion+":
			life = 3 * life_mult
			if Global.has_idol_mask:
				speed = 100
				speed_total = 200
				stopandgo = true
			else:
				speed = 180
				speed_total = 200
				stopandgo = false
		else:
			life = 1 * life_mult
			speed = 100
			speed_total = 200
			stopandgo = true
		
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = true
			
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
		
	if enemy_type == "spider" or enemy_type == "spider_xs":
		if enemy_type == "spider":
			var options = {"pitch_scale": 0.5}
			Global.play_sound(Global.SpiderSfx, options)
			life = 6 * life_mult
			speed = 180
			speed_total = 200
			shoot_on_die = true
			shoot_ttl_total = 3
			shoot_ttl = shoot_ttl_total
			shoot_type = true
			
			shoot_count_total = [3, 6, 9]
			shoot_count = Global.pick_random(shoot_count_total)
			
			stopandgo = true
			$area/collider.set_deferred("disabled", false)
			$area/collider_dead_fire.set_deferred("disabled", true)
			$area/collider_ghost.set_deferred("disabled", false)
			$area/collider_squid.set_deferred("disabled", true)
		else:
			life = 1 * life_mult
			speed = 100
			speed_total = 200
			shoot_on_die = false
			shoot_ttl_total = 0
			shoot_ttl = shoot_ttl_total
			shoot_type = false
			stopandgo = false
			$area/collider.set_deferred("disabled", false)
			$area/collider_dead_fire.set_deferred("disabled", true)
			$area/collider_ghost.set_deferred("disabled", true)
			$area/collider_squid.set_deferred("disabled", true)

		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = true
			
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
		
	elif enemy_type == "skeleton":
		Global.play_sound(Global.SkeleSfx)
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		$area/collider_squid.set_deferred("disabled", true)
		
		shoot_ttl_total = Global.pick_random([5, 3, 2])
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		
		shoot_count_total = [1, 3, 5]
		shoot_count = Global.pick_random(shoot_count_total)
		
		speed = 80
		speed_total = 80
		life = 2 * life_mult
		dmg = 1
		if Global.has_idol_mask:
			chase_player = false
		else:
			chase_player = Global.pick_random([true, false])
			
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo = false
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		inmune_while_moving = false
		
func OuchSfx():
	if enemy_type == "shop_keeper":
		var options = {"pitch_scale": 0.6}
		Global.play_sound(Global.PlayerHurt, options)
	if enemy_type == "bloby":
		var options = {"pitch_scale": 2.5}
		Global.play_sound(Global.SpiderHitSfx, options)
	if enemy_type == "idol":
		var options = {"pitch_scale": 0.3}
		Global.play_sound(Global.TrollHitSfx, options)
	if enemy_type == "troll":
		var options = {"pitch_scale": 0.5}
		Global.play_sound(Global.TrollHitSfx, options)
	if enemy_type == "mushroom_guy":
		var options = {"pitch_scale": 1.5}
		Global.play_sound(Global.TrollHitSfx, options)
	if enemy_type == "ghost":
		Global.play_sound(Global.GhostHitSfx)
	if enemy_type == "squid":
		Global.play_sound(Global.DeadFireHitSfx)
	if enemy_type == "tentacle":
		Global.play_sound(Global.GhostHitSfx)
	if enemy_type == "dead_fire":
		Global.play_sound(Global.DeadFireHitSfx)
	if enemy_type == "bat":
		Global.play_sound(Global.BatsHitSfx)
	if enemy_type == "scorpion" or enemy_type == "scorpion+":
		Global.play_sound(Global.ScorpionHitSfx)
	if enemy_type == "spider":
		var options = {"pitch_scale": 0.5}
		Global.play_sound(Global.SpiderHitSfx, options)
	if enemy_type == "spider_xs":
		var options = {"pitch_scale": 2}
		Global.play_sound(Global.SpiderHitSfx, options)
	if enemy_type == "skeleton":
		Global.play_sound(Global.SkeleHitSfx)
		
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
	
func effects(from):
	return (from == "poison_fx" or from == "justice_fx" or from == "bleed_fx" or from == "electricity_fx")
		
func hit(origin, dmg, from):
	if visible and !iamasign:
		if inmune_while_moving and inmune_now:
			return
		
		if sleep:
			awake()
		
		if !effects(from):
			stop_moving = 0.01
			
		life -= dmg
		
		if !effects(from) and Global.has_bleed:
			bleeding = true
			bleed()
		
		if !effects(from):
			hit_ttl = hit_ttl_total
			if Global.has_iron_fist:
				if randi()%(Global.bad_luck/2) == 0:
					life = 0
					create_sign("CRITICAL HIT!", true, null, false, false)
		
		if life > 0:
			if !effects(from):
				OuchSfx()
		else:
			if from == "player":
				Global.kills += 1
		
		if from == "player" and electric_effect <= 0 and Global.electric:
			Global.play_sound(Global.ElectricSfx)
			electric_effect = electric_effect_total
		
		if from == "player" and Global.frozen:
			Global.play_sound(Global.FrozeSfx)
			froze_effect = froze_effect_total
		
		if from == "player" and (Global.poison or Global.temp_poison):
			Global.play_sound(Global.PoisonSfx)
			$sprite.modulate = Global.poisoned_color
			poisoned = true
		
		if is_enemy_group:
			get_parent().stop_moving = 0.5
		
		if origin:
			impulse = (origin.position - self.position).normalized()
			
		if life <= 0:
			if from == "player":
				var cur = Global.add_combo()
				if cur > 0:
					create_sign(str(cur), false, Color8(238, 182, 47), true, true)
			dead = true
		else:
			if from == "player":
				Global.sustain()

func die():
	if visible and !iamasign:
		OuchSfx()
		emit()
		if !dont_drop and Global.pick_random([true, false]):
			drop_gem()
		if !dont_drop and shoot_on_die:
			shoot_die()
		queue_free()
		
func awake():
	if sleep:
		Global.play_sound(Global.ScorpionSfx)
		$sprite.animation = "mimic"
		$shadow.animation = "mimic"
		sleep = false

func _on_area_body_entered(body):
	if visible and !iamasign and body.is_in_group("players"):
		if Global.zombie:
			$sprite.modulate = Global.infected_color
			infected = true
		body.hit(dmg, enemy_type)
		awake()
			
	if electric_effect <= 0 and Global.has_balloon:
		Global.play_sound(Global.ElectricSfx)
		electric_effect = electric_effect_total
		
func _draw():
	if electric_effect > 0 and destiny:
		var des_pos = to_local(destiny.position)
		var xx
		var yy
		var last_x
		var last_y
		var amount
		var dir
		var argument0 = 0
		var argument1 = 0
		var argument2 = des_pos.x
		var argument3 = des_pos.y
		var argument5 = 10
		var argument6 = 6
		var argument7 = 12

		xx = argument0
		yy = argument1
		last_x = argument0
		last_y = argument1
		dir = Vector2(xx, yy).angle_to_point(Vector2(argument2,argument3))

		for i in range(((Vector2(xx, yy).distance_to(Vector2(argument2,argument3))) / argument5) + 5):
			dir = Vector2(xx, yy).angle_to_point(Vector2(argument2,argument3))
			xx += cos(dir) * argument5 * -1
			yy -= sin(dir) * argument5

			amount = argument6-rand_range(0, argument7)
			xx += cos(dir - 90) * amount
			yy -= sin(dir - 90) * amount
			draw_line(Vector2(xx,yy),Vector2(last_x,last_y), Color8(255, 255, 255), 1)
			last_x = xx
			last_y = yy
