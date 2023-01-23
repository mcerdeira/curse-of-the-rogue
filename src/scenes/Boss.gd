extends KinematicBody2D

var bullet = ""
var shoot_ttl = 0
var shoot_ttl_total = 0.2
var pong_dir = Vector2.ZERO
var destiny = null
var dead = false
var hit_ttl = 0
var hit_ttl_total = 0.2
var stop_moving = 0
var poisoned = false
var life = 90
var point_chase = null
var intro_ttl = 0
var active = false
var particle = preload("res://scenes/particle2.tscn")
var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
var BulletLander = preload("res://scenes/BulletLander.tscn")
var move_dir = 1
var movement_type = null
var attack_type = null
var damage_type = null
var state_moving = true
var state_attacking = true
var moving_ttl = 0
var moving_ttl_total = 0
var attacking_ttl = 0
var attacking_ttl_total = 0
var attacking_count = 0
var attacking_count_total = 0
var spawn_enemies = false
var boss_type = ""
var dmg = 1
var infected = false
var speed = 0
var froze_effect = 0
var froze_effect_total = 1
var electric_effect = 0
var electric_effect_total = 2

func generate_boss():
	randomize()
	spawn_enemies = Global.pick_random([false, false, false, true])
	movement_type = Global.pick_random(Global.movement_types)
	attack_type = Global.pick_random(Global.attack_types)
	damage_type = Global.pick_random(Global.damage_types)
	moving_ttl_total = movement_type.ttl
	moving_ttl = moving_ttl_total
	
	attacking_ttl_total = attack_type.ttl
	attacking_ttl = 0
	
	attacking_count_total = attack_type.count
	attacking_count = 0
	speed = movement_type.speed
	
	bullet = damage_type.bullet
	
	$area.add_to_group("bosses")
	add_to_group("enemy_objects")
	
	if attack_type.name == "melee":
		$weapon.visible = true
	else:
		$weapon.queue_free()
		
func effects(from):
	return (from == "poison_fx" or from == "electricity_fx")
		
func OuchSfx():
	var options = {"pitch_scale": 0.5}
	Global.play_sound(Global.TrollHitSfx, options)
		
func hit(origin, dmg, from):
	if active:
		if !effects(from):
			stop_moving = 0.1
			
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
					
		if life <= 0:
			if from == "player":
				Global.add_combo()
			dead = true
		else:
			if from == "player":
				Global.sustain()
		
func _ready():
	Global.FLOOR_TYPE = Global.floor_types.boss
	if Global.FLOOR_TYPE != Global.floor_types.boss:
		queue_free()
		return
	else:
		generate_boss()

func _physics_process(delta):
	if poisoned:
		if randi() % 100 + 1 == 100:
			emit()
		
		hit(null, 1 * delta, "poison_fx")
		
		
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
		
	if froze_effect > 0:
		$sprite.modulate = Global.froze_color
		stop_moving = 1
		froze_effect -= 1 * delta
		if froze_effect <= 0:
			$sprite.modulate = Color8(255, 255, 255)
			stop_moving = 0
	
	if hit_ttl > 0:
		$body.material.set_shader_param("hitted", true)
		$head.material.set_shader_param("hitted", true)
		$body.playing = false
		$body.playing = false
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			hit_ttl = 0
			$body.material.set_shader_param("hitted", false)
			$head.material.set_shader_param("hitted", false)
			$body.playing = true
			$body.playing = true
	
	z_index = position.y
	if active:
		if attacking_ttl_total != -1:
			attacking_ttl -= 1 * delta
			
		if moving_ttl_total != -1:
			moving_ttl -= 1 * delta
		
		check_state(delta)
		
		if state_moving:
			boss_movement(delta)
		if state_attacking:
			boss_attack(delta)
	else:
		if intro_ttl > 0:
			intro_ttl -= 1 * delta
			if intro_ttl <= 0:
				active = true
				intro_ttl = 0
				$area_start.queue_free()
		
func check_state(delta):
	if attacking_ttl <= 0:
		attacking_ttl = attacking_ttl_total
		if attacking_ttl_total == -1:
			state_attacking = true
		else:
			state_attacking = !state_attacking
	
	if moving_ttl <= 0:
		moving_ttl = moving_ttl_total
		if moving_ttl_total == -1:
			state_moving = true
		else:
			state_moving = !state_moving
		
func got_there(point):
	if position.distance_to(point) <= 5:
		return true
	else:
		return false

func find_player():
	return get_tree().get_nodes_in_group("players")[0]
	
func create_enemy_bullet(pos):
	var fire_ball = EnemyBullet.instance()
	fire_ball.type = bullet
	fire_ball.dir = pos
	fire_ball.from = boss_type
	get_parent().add_child(fire_ball)
	fire_ball.set_position(position)
	
func create_enemy_fake_bullet(pos):
	var fire_ball = EnemyBullet.instance()
	fire_ball.type = bullet
	fire_ball.dir = pos
	fire_ball.from = boss_type
	fire_ball.init_fake()
	get_parent().add_child(fire_ball)
	fire_ball.set_position(position)
	
func shoot_cross(delta):
	shoot_ttl -= 1 * delta
	stop_moving = 0.1
	if shoot_ttl <= 0:
		shoot_ttl = shoot_ttl_total
		create_enemy_bullet(Vector2(0, 1))
		create_enemy_bullet(Vector2(0, -1))
		
		create_enemy_bullet(Vector2(1, 0))
		create_enemy_bullet(Vector2(-1, 0))
		
func shoot_spinx(delta):
	shoot_ttl -= 1 * delta
	stop_moving = 0.1
		
	if shoot_ttl <= 0:
		shoot_ttl = shoot_ttl_total
		create_enemy_bullet(Vector2(0, 1))
		create_enemy_bullet(Vector2(0, -1))
		
		create_enemy_bullet(Vector2(1, 0))
		create_enemy_bullet(Vector2(1, 1))
		create_enemy_bullet(Vector2(1, -1))
		
		create_enemy_bullet(Vector2(-1, 0))
		create_enemy_bullet(Vector2(-1, 1))
		create_enemy_bullet(Vector2(-1, -1))
		
func shoot_rain(delta):
	shoot_ttl -= 1 * delta
	stop_moving = 0.1
	if shoot_ttl <= 0:
		if Global.pick_random([true, false]):
			var fire_ball = BulletLander.instance()
			get_parent().add_child(fire_ball)
			var p = Global.SPAWNER.get_random_point()
			fire_ball.set_position(p.position)
		
		shoot_ttl = shoot_ttl_total
		create_enemy_fake_bullet(Vector2(0, -1))
		
func attack_melee(delta):
	pass
	
func jump_attack(delta):
	pass
	
func attack_charge(delta):
	pass

func boss_attack(delta):
	if froze_effect > 0:
		return
		
	if attack_type.name == "charge":
		attack_charge(delta)
	if attack_type.name == "cross":
		shoot_cross(delta)
	if attack_type.name == "spin_x":
		shoot_spinx(delta)
	if attack_type.name == "rain":
		shoot_rain(delta)
	if attack_type.name == "melee":
		attack_melee(delta)
	if attack_type.name == "jump":
		jump_attack(delta)

func boss_movement(delta):
	if stop_moving > 0:
		stop_moving -= 1 * delta
		return 
		
	if spawn_enemies:
		if randi() % 250 == 0:
			emit()
			Global.SPAWNER.spawn_enemy(true)
	
	if movement_type.name == "pong":
		if pong_dir == Vector2.ZERO:
			var xx = speed * rand_range(2, 4) * Global.pick_random([1,-1])
			var yy = speed * rand_range(2, 4) * Global.pick_random([1,-1])
			
			pong_dir = Vector2(xx, yy)
			
		var prev_velocity = pong_dir
		pong_dir = move_and_slide(pong_dir)
		
		if get_slide_count() > 0:
			pong_dir = prev_velocity.bounce(get_slide_collision(0).normal)
		
		
	if movement_type.name == "follow":
		if point_chase == null:
			point_chase = find_player()
			
		var direction = (point_chase.position - self.position).normalized()
		move_and_slide(speed * direction)
		
	if movement_type.name == "random":
		if point_chase == null or got_there(point_chase.position):
			point_chase = Global.SPAWNER.get_random_point()
				
		var direction = (point_chase.position - self.position).normalized()
		move_and_slide(speed * direction)

	if movement_type.name == "horizontal":
		move_and_slide(Vector2(speed * move_dir, 0))
	if movement_type.name == "none":
		pass
		
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
		
func emit():
	var p = particle.instance()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position

func _on_area_body_entered(body):
	if body.name == "Walls":
		move_dir *= -1
		emit()
	
	if body.is_in_group("players"):
		if Global.zombie:
			$sprite.modulate = Global.infected_color
			infected = true
		body.hit(dmg, boss_type)

func _on_weapon_area_body_entered(body):
	if body.is_in_group("players"):
		body.hit(dmg, boss_type)

func _on_area_start_body_entered(body):
	if !active and intro_ttl <= 0 and body.is_in_group("players"):
		intro_ttl = 3
