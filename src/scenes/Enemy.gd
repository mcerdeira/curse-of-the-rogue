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
var leave_trail = false
var trail_ttl_total = 0.1
var trail_ttl = trail_ttl_total
var invisible_time = 0
var invisible_time_total = 1
var froze_effect = 0
var electric_effect = 0
var electric_effect_total = 2
var destiny = null
var saturate = 0
var saturate_dir = 1
var falling = false
var dont_drop = false
var fireinmune = false
var falled = false
var _in_water = false
var angle_walker = false
var troll_angle_limit = 4.6
var troll_angle = 0
var troll_angle_dir = 1

func _ready():
	add_to_group("enemy_objects")
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
	
func create_enemy_bullet(pos):
	var fire_ball = EnemyBullet.instance()
	fire_ball.type = "fire_ball"
	fire_ball.dir = pos
	fire_ball.from = enemy_type
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
		emit()
		if enemy_type == "dead_fire":
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_trail"
			fire_ball.from = enemy_type
			get_parent().add_child(fire_ball)
			fire_ball.set_position(position)

func shoot():
	if froze_effect <= 0:
		emit()
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
		if enemy_type == "bat":
			Global.play_sound(Global.BatsSfx)
			var fire_ball = EnemyBullet.instance()
			fire_ball.type = "fire_ball"
			fire_ball.from = enemy_type
			get_parent().get_parent().add_child(fire_ball)
			fire_ball.global_position = global_position
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

func enemy_behaviour(delta):
	if falling:
		$sprite.rotation += 5 * delta
		$sprite.scale.x -= 2 * delta
		$sprite.scale.y = $sprite.scale.x
		if $sprite.scale.x <= 0:
			stop_fall()
			
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
	if enemy_type == "ghost":
		$Line2D.visible = true
		Global.play_sound(Global.GhostSfx)
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
		fireinmune = true
		is_enemy_group = false
		stopandgo = true
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		shoot_on_die = true
		disapear = true
		leave_trail = false
		angle_walker = false
		random_shooter = false
	
	if enemy_type == "dead_fire":
		$Line2D.queue_free()
		Global.play_sound(Global.DeadFireSfx)
		$area/collider.set_deferred("disabled", true)
		$area/collider_dead_fire.set_deferred("disabled", false)
		$area/collider_ghost.set_deferred("disabled", true)
		
		shoot_ttl_total = Global.pick_random([5, 3, 2])
		shoot_ttl = shoot_ttl_total
		shoot_type = true
		speed = 150
		speed_total = 150
		life = 5
		dmg = 2
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
	
	if enemy_type == "bat":
		$Line2D.queue_free()
		Global.play_sound(Global.BatsSfx)
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
		fireinmune = false
		is_enemy_group = true
		stopandgo = false
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = true
		
	if enemy_type == "troll":
		$Line2D.queue_free()
		var options = {"pitch_scale": 0.5}
		Global.play_sound(Global.TrollSfx, options)
		life = Global.attack * 5
		speed = 30
		speed_total = 30
		stopandgo = false
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		dmg = 1
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
		
	if enemy_type == "scorpion" or enemy_type == "scorpion+":
		$Line2D.queue_free()
		Global.play_sound(Global.ScorpionSfx)
		if enemy_type == "scorpion+":
			life = 4
			speed = 180
			speed_total = 200
			stopandgo = false
		else:
			life = 1
			speed = 100
			speed_total = 200
			stopandgo = true
		
		$area/collider.set_deferred("disabled", false)
		$area/collider_dead_fire.set_deferred("disabled", true)
		$area/collider_ghost.set_deferred("disabled", true)
		shoot_ttl_total = 0
		shoot_ttl = shoot_ttl_total
		shoot_type = false
		dmg = 1
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
		
	if enemy_type == "spider" or enemy_type == "spider_xs":
		$Line2D.queue_free()
		if enemy_type == "spider":
			var options = {"pitch_scale": 0.5}
			Global.play_sound(Global.SpiderSfx, options)
			life = 6
			speed = 180
			speed_total = 200
			shoot_on_die = true
			shoot_ttl_total = 3
			shoot_ttl = shoot_ttl_total
			shoot_type = true
			stopandgo = true
			$area/collider.set_deferred("disabled", false)
			$area/collider_dead_fire.set_deferred("disabled", true)
			$area/collider_ghost.set_deferred("disabled", false)
		else:
			life = 1
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

		dmg = 1
		chase_player = true
		flying = false
		fireinmune = false
		is_enemy_group = false
		stopandgo_ttl = Global.pick_random([5, 3, 2, 6])
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		
	elif enemy_type == "skeleton":
		$Line2D.queue_free()
		Global.play_sound(Global.SkeleSfx)
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
		fireinmune = false
		is_enemy_group = false
		stopandgo = false
		shoot_on_die = false
		disapear = false
		leave_trail = false
		angle_walker = false
		random_shooter = false
		
func OuchSfx():
	if enemy_type == "troll":
		var options = {"pitch_scale": 0.5}
		Global.play_sound(Global.TrollHitSfx, options)
	if enemy_type == "ghost":
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
		
func effects(from):
	return (from == "poison_fx" or from == "electricity_fx")
		
func hit(origin, dmg, from):
	if visible and !iamasign:
		if !effects(from):
			stop_moving = 0.01
			
		life -= dmg
		
		if !effects(from):
			hit_ttl = hit_ttl_total
		
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
			froze_effect = 3
		
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
				Global.add_combo()
			dead = true
		else:
			if from == "player":
				Global.sustain()

func die():
	if visible and !iamasign:
		OuchSfx()
		if !dont_drop and Global.pick_random([true, false]):
			drop_gem()
		emit()
		if !dont_drop and shoot_on_die:
			shoot_die()
		queue_free()

func _on_area_body_entered(body):
	if visible and !iamasign and body.is_in_group("players"):
		if Global.zombie:
			$sprite.modulate = Global.infected_color
			infected = true
		body.hit(dmg, enemy_type)
		
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
