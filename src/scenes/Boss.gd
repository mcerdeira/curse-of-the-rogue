extends KinematicBody2D

var bleeding = false
var charge_bounce_count = 0
var charging = false
var charging_ttl_total = 1.8
var charging_ttl = charging_ttl_total
var attacking_charge = false
var charge_direction = null
var speed_charge_total = 700
var speed_charge = speed_charge_total
var jump_height = 0
var jump_dir = -1
var jumping = false
var weapon_rotate_speed_base = 600
var weapon_rotate_speed = weapon_rotate_speed_base
var bullet = ""
var shoot_ttl = 0
var shoot_ttl_total = 0.2
var pong_dir = Vector2.ZERO
var destiny = null
var dead = false
var dead_ttl = 2
var hit_ttl = 0
var hit_ttl_total = 0.2
var stop_moving = 0
var poisoned = false
var poisoned_ttl = 3
var total_life = 100.00
var life = total_life
var point_chase = null
var introl_ttl_total = 4.5
var intro_ttl = 0
var active = false
var particle = preload("res://scenes/particle2.tscn")
var EnemyBullet = preload("res://scenes/EnemyBullet.tscn")
var BulletLander = preload("res://scenes/BulletLander.tscn")
var ChargeAttack = preload("res://scenes/ChargeAttack.tscn")
var Blood = preload("res://scenes/Blood.tscn")
var Gem = preload("res://scenes/Gem.tscn")
var charge_inst = null
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
var extra_type = ""
var dmg = 1
var infected = false
var speed = 0
var original_speed = 0
var froze_effect = 0
var froze_effect_total = 1
var electric_effect = 0
var electric_effect_total = 2
var boss_name = ""
var _player_obj = null

func _ready():
	if Global.FLOOR_TYPE != Global.floor_types.boss:
		queue_free()
		return
	else:
		generate_boss()

func generate_boss():
	randomize()
	
	total_life = Global.get_boss_life()
	life = total_life
	
	movement_type = Global.pick_random(Global.movement_types)
	
	if movement_type.name == "none":
		spawn_enemies = true
	else:
		spawn_enemies = Global.pick_random([false, false, true])
	
	attack_type = Global.pick_random(Global.attack_types)
	damage_type = Global.pick_random(Global.damage_types)
	moving_ttl_total = movement_type.ttl
	moving_ttl = moving_ttl_total
	
	attacking_ttl_total = attack_type.ttl
	attacking_ttl = 0
	
	attacking_count_total = attack_type.count
	attacking_count = 0
	speed = movement_type.speed
	original_speed = speed
	
	bullet = damage_type.bullet

	boss_name = movement_type.name3 + " " + attack_type.name3 + " " + damage_type.name3
	
	$head.animation = attack_type.name3
	$body.animation = attack_type.name3
	$extra.animation = movement_type.name3
		
	#TODO:aplicar efecto dmg_type_normal.name3
		
	$area.add_to_group("bosses")
	add_to_group("enemy_objects")
	
	boss_type = attack_type.name3
	extra_type = movement_type.name3
	
	Global.CURRENT_BOSS_NAME = boss_name
	
	if attack_type.name == "melee":
		$weapon.visible = true
	else:
		$weapon.queue_free()
		
func drop_life():
	var p = Gem.instance()
	p.type = "life"
	p._init_sprite()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
		
func effects(from):
	return (from == "poison_fx" or from == "justice_fx" or from == "bleed_fx" or from == "electricity_fx")
	
func AttackSfx():
	var options = {"pitch_scale": 0.3}
	Global.play_sound(Global.TrollSfx, options)
		
func OuchSfx():
	var options = {"pitch_scale": 0.3}
	Global.play_sound(Global.TrollHitSfx, options)
		
func hit(origin, dmg, from):
	if active:
		if !effects(from):
			stop_moving = 0.1
			
		life -= dmg
		
		Global.update_boss_life(life, total_life)
		
		if !effects(from):
			hit_ttl = hit_ttl_total
			
		if !effects(from) and Global.has_bleed:
			bleeding = true
			bleed()
		
		if life > 0:
			if !effects(from):
				OuchSfx()
		else:
			if from == "player":
				Global.kills += 1
		
		if from == "player" and electric_effect <= 0 and Global.electric:
			Global.play_sound(Global.ElectricSfx)
			electric_effect = electric_effect_total
		
		if from == "player" and Global.frozen and froze_effect <= 0:
			Global.play_sound(Global.FrozeSfx)
			speed = original_speed / 3
			froze_effect = 3
		
		if from == "player" and !poisoned and (Global.poison or Global.temp_poison):
			Global.play_sound(Global.PoisonSfx)
			$head.modulate = Global.poisoned_color
			$body.modulate = Global.poisoned_color
			$extra.modulate = Global.poisoned_color
			poisoned_ttl = 3
			poisoned = true
					
		if life <= 0:
			if from == "player":
				Global.add_combo()
			die()
		else:
			if from == "player":
				Global.sustain()
		
func _physics_process(delta):
	if bleeding:
		if randi() % 100 + 1 == 100:
			bleed()
			hit(null, 0.1 * delta, "bleed_fx")
	
	if poisoned:
		if randi() % 100 + 1 == 100:
			emit()
		
		poisoned_ttl -= 1 * delta
		hit(null, 0.3 * delta, "poison_fx")
		if poisoned_ttl <= 0:
			poisoned_ttl = 0
			poisoned = false
			$head.modulate = Color8(255, 255, 255)
			$body.modulate = Color8(255, 255, 255)
			$extra.modulate = Color8(255, 255, 255)
		
		
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
		$head.modulate = Global.froze_color
		$body.modulate = Global.froze_color
		$extra.modulate = Global.froze_color
		
		froze_effect -= 1 * delta
		if froze_effect <= 0:
			speed = original_speed
			$head.modulate = Color8(255, 255, 255)
			$body.modulate = Color8(255, 255, 255)
			$extra.modulate = Color8(255, 255, 255)
	
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
	
	face_player()
	
	$shadow.visible = !jumping
	
	if dead:
		dead_ttl -= 1 * delta
		if randi() % 10 == 0:
			OuchSfx()
			emit(45)
			
		$body.rotation_degrees = randi() % 90 * Global.pick_random([1, -1])
		$head.rotation_degrees = randi() % 90 * Global.pick_random([1, -1])
		$extra.rotation_degrees = randi() % 90 * Global.pick_random([1, -1])
		if dead_ttl <= 0:
			explode()
		
	else:
		if active:
			check_state(delta)
			
			if state_moving:
				boss_movement(delta)
			if state_attacking:
				boss_attack(delta)
		else:
			if intro_ttl > 0:
				intro_ttl -= 1 * delta
				if intro_ttl <= 0:
					start_boss_battle()
		
func start_boss_battle():
	active = true
	intro_ttl = 0
	Global.start_boss_batle()
	Global.LOGIC_PAUSE = false
	$area_start.queue_free()
	
func die():
	dead = true
		
func check_state(delta):	
	if !jumping and !charging and !attacking_charge:
		if attacking_ttl_total != -1:
			attacking_ttl -= 1 * delta
			
		if moving_ttl_total != -1:
			moving_ttl -= 1 * delta
		
		if attacking_ttl <= 0:
			attacking_ttl = attacking_ttl_total
			if attacking_ttl_total == -1:
				state_attacking = true
			else:
				state_attacking = !state_attacking
				if froze_effect > 0:
					if randi() % 5 == 0:
						state_attacking = false
				if state_attacking:
					AttackSfx()
					
				weapon_rotate_speed = weapon_rotate_speed_base
	
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
	fire_ball.from = [boss_type, extra_type]
	fire_ball.effect_name = damage_type.name
	get_parent().add_child(fire_ball)
	fire_ball.set_position(position)
	
func create_enemy_fake_bullet(pos):
	var fire_ball = EnemyBullet.instance()
	fire_ball.type = bullet
	fire_ball.dir = pos
	fire_ball.from = [boss_type, extra_type]
	fire_ball.effect_name = damage_type.name
	fire_ball.init_fake()
	get_parent().add_child(fire_ball)
	fire_ball.set_position(position)
	
func shoot_cross(delta):
	shoot_ttl -= 1 * delta
	if movement_type.stop_on_shoot:
		stop_moving = 0.1
	if shoot_ttl <= 0:
		shoot_ttl = shoot_ttl_total
		$body.material.set_shader_param("shoot_prev", true)
		$head.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$body.material.set_shader_param("shoot_prev", false)
		$head.material.set_shader_param("shoot_prev", false)
		yield(get_tree().create_timer(0.2), "timeout") 
		$body.material.set_shader_param("shoot_prev", true)
		$head.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$body.material.set_shader_param("shoot_prev", false)
		$head.material.set_shader_param("shoot_prev", false)
		
		create_enemy_bullet(Vector2(0, 1))
		create_enemy_bullet(Vector2(0, -1))
		
		create_enemy_bullet(Vector2(1, 0))
		create_enemy_bullet(Vector2(-1, 0))
		
func shoot_X():
	$body.material.set_shader_param("shoot_prev", true)
	$head.material.set_shader_param("shoot_prev", true)
	yield(get_tree().create_timer(0.3), "timeout") 
	$body.material.set_shader_param("shoot_prev", false)
	$head.material.set_shader_param("shoot_prev", false)
	yield(get_tree().create_timer(0.2), "timeout") 
	$body.material.set_shader_param("shoot_prev", true)
	$head.material.set_shader_param("shoot_prev", true)
	yield(get_tree().create_timer(0.3), "timeout") 
	$body.material.set_shader_param("shoot_prev", false)
	$head.material.set_shader_param("shoot_prev", false)
	
	create_enemy_bullet(Vector2(0, 1))
	create_enemy_bullet(Vector2(0, -1))
	
	create_enemy_bullet(Vector2(1, 0))
	create_enemy_bullet(Vector2(1, 1))
	create_enemy_bullet(Vector2(1, -1))
	
	create_enemy_bullet(Vector2(-1, 0))
	create_enemy_bullet(Vector2(-1, 1))
	create_enemy_bullet(Vector2(-1, -1))
		
func shoot_spinx(delta):
	shoot_ttl -= 1 * delta
	if movement_type.stop_on_shoot:
		stop_moving = 0.1
	if shoot_ttl <= 0:
		shoot_ttl = shoot_ttl_total
		$body.material.set_shader_param("shoot_prev", true)
		$head.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$body.material.set_shader_param("shoot_prev", false)
		$head.material.set_shader_param("shoot_prev", false)
		yield(get_tree().create_timer(0.2), "timeout") 
		$body.material.set_shader_param("shoot_prev", true)
		$head.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$body.material.set_shader_param("shoot_prev", false)
		$head.material.set_shader_param("shoot_prev", false)
		
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
	if movement_type.stop_on_shoot:
		stop_moving = 0.1
	if shoot_ttl <= 0:
		var chance = Global.pick_random([0, 1, 1, 1, 2, 2])
		if chance == 1:
			var fire_ball = BulletLander.instance()
			fire_ball.type = bullet
			fire_ball.effect_name = damage_type.name
			fire_ball.from = [boss_type, extra_type]
			get_parent().add_child(fire_ball)
			var p = Global.SPAWNER.get_random_point()
			fire_ball.set_position(p.position)
		elif chance == 2:
			if _player_obj == null:
				_player_obj = find_player()
			
			var fire_ball = BulletLander.instance()
			fire_ball.type = bullet
			fire_ball.effect_name = damage_type.name
			fire_ball.from = [boss_type, extra_type]
			get_parent().add_child(fire_ball)
			fire_ball.set_position(_player_obj.position)
		else:
			pass
		
		shoot_ttl = shoot_ttl_total

		$body.material.set_shader_param("shoot_prev", true)
		$head.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$body.material.set_shader_param("shoot_prev", false)
		$head.material.set_shader_param("shoot_prev", false)
		yield(get_tree().create_timer(0.2), "timeout") 
		$body.material.set_shader_param("shoot_prev", true)
		$head.material.set_shader_param("shoot_prev", true)
		yield(get_tree().create_timer(0.3), "timeout") 
		$body.material.set_shader_param("shoot_prev", false)
		$head.material.set_shader_param("shoot_prev", false)
		
		create_enemy_fake_bullet(Vector2(0, -1))
		
func attack_melee(delta):
	weapon_rotate_speed += 1000 * delta
	$weapon.rotation_degrees += weapon_rotate_speed * delta
	
func jump_attack(delta):
	state_moving = false
	if !jumping:
		jump_dir = -1
		jump_height = 0
		jumping = true
		stop_moving = 900
		
	if jump_dir == -1:
		position.y -= 500 * delta
		jump_height += 100 * delta
		if jump_height >= 100:
			if _player_obj == null:
				_player_obj = find_player()
			
			position.x = _player_obj.position.x
			jump_height = _player_obj.position.y
			jump_dir = 1
	else:
		
		position.y += 1200 * delta
		if position.y >= jump_height:
			attacking_ttl = 0
			Global.shaker_obj.shake(10, 0.6)
			jumping = false
			stop_moving = 0.3
			shoot_X()
			position.y == jump_height
	
func attack_charge(delta):
	stop_moving = 900
	state_moving = false
	if !attacking_charge and !charging and (charge_inst == null or !is_instance_valid(charge_inst)):
		charge_inst = ChargeAttack.instance()
		charge_inst.rotation_degrees = randi()% 360
		add_child(charge_inst)
	elif attacking_charge:
		if charge_direction == null:
			charge_direction = Vector2(1, 0).rotated(charge_inst.rotation)
			charge_inst.queue_free()
		
		move_and_slide(speed_charge * charge_direction)
		if get_slide_count() > 0:
			speed_charge -= 100
			charge_bounce_count += 1
			charge_direction = charge_direction.bounce(get_slide_collision(0).normal)
			if charge_bounce_count >= 3:
				speed_charge = speed_charge_total
				charging = false
				charging_ttl = charging_ttl_total
				charge_direction = null
				state_moving = true
				emit()
				Global.shaker_obj.shake(10, 0.6)
				shoot_X()
				stop_moving = 0.3
				charge_bounce_count = 0
				attacking_charge = false
	else:
		charging = true
		charging_ttl -= 1 * delta
		if charging_ttl <= 0:
			attacking_ttl = 0
			charging = false
			attacking_charge = true
			charging_ttl = charging_ttl_total
			attacking_charge = true

func boss_attack(delta):		
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
			emit()
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
		if pong_dir == Vector2.ZERO:
			var xx = speed * move_dir
			var yy = 0
			
			pong_dir = Vector2(xx, yy)
			
		var prev_velocity = pong_dir
		pong_dir = move_and_slide(pong_dir)
		
		if get_slide_count() > 0:
			emit()
			move_dir *= -1
		
	if movement_type.name == "none":
		pass
		
func face_player():
	if _player_obj == null:
		_player_obj = find_player()
	
	if position.x > _player_obj.position.x:
		$body.scale.x = 1
		$head.scale.x = 1
		$extra.scale.x = 1
	else:
		$body.scale.x = -1
		$head.scale.x = -1
		$extra.scale.x = -1
		
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
			
func bleed():
	if randi() % 7 == 0:
		drop_life()
	
	for i in range(Global.pick_random([1, 2])):
		var p = Blood.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
			
func explode():
	var p = particle.instance()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
	p.init(55)
	
	OuchSfx()
	Global.play_sound(Global.BombSxf)
	Global.shaker_obj.shake(15, 1.3)
	queue_free()
		
func emit(amount=0):
	var p = particle.instance()
	var root = get_node("/root/Main")
	root.add_child(p)
	p.global_position = global_position
	if amount != 0:
		p.init(amount)

func _on_area_body_entered(body):
	if body.is_in_group("players"):
		if Global.zombie:
			$head.modulate = Global.infected_color
			$body.modulate = Global.infected_color
			$extra.modulate = Global.infected_color
			infected = true
		body.hit(dmg, [boss_type, extra_type], false, damage_type.name)

func _on_weapon_area_body_entered(body):
	if body.is_in_group("players"):
		body.hit(dmg, [boss_type, extra_type], false, damage_type.name)

func _on_area_start_body_entered(body):
	if !active and intro_ttl <= 0 and body.is_in_group("players"):
		intro_ttl = introl_ttl_total
		Global.show_boss_name(boss_name)
		Global.LOGIC_PAUSE = true
