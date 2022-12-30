extends KinematicBody2D
var movement = Vector2.ZERO
var hit_ttl = 0
var hit_ttl_total = 0.2
var inv_time = 0
var inv_time_total = 1.2
var inv_togg_total = 0.1
var inv_togg = 0
var whip_inst = null
var whip = preload("res://scenes/Whip.tscn")
var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
var ani_aditional = ""
var turn_into_zombie_ttl = 0
var turn_into_zombie_ttl_total = 1.3
var normalize_direction = 0

var dead = false
var entering = false

func _ready():
	add_to_group("players")
	if Global.automatic_weapon != "empty":
		$automatic_weapon.animation = Global.automatic_weapon
		$automatic_weapon.visible = true
	else:
		$automatic_weapon.visible = false
	
	if Global.zombie:
		turn_into_zombie(false)
	
func add_gem(count):
	Global.gems += count
	
func add_key(count):
	Global.keys += count
	
func add_heart(count):
	for i in range(Global.health.size()):
		if Global.health[i] == 0 and count > 0:
			Global.health[i] = 1
			count -= 1
			if count <= 0:
				break
	
	Global.refresh_hud()
	
func add_total_hearts(count):
	for i in range(count):
		Global.health.push_back(0)
		
	Global.refresh_hud()
	
func add_shield(count):
	for i in range(count):
		Global.health.push_back(2)
	
	Global.refresh_hud()
	
func add_shield_poision(count):
	for i in range(count):
		Global.health.push_back(3)
	
	Global.temp_poison = true
	Global.refresh_hud()
	
func add_automatic_weapon(weapon):
	Global.automatic_weapon = weapon
	
func add_secondary_weapon(weapon):
	Global.secondary_weapon = weapon
	
func add_pay_2_win():
	#El daño es == a las gemas
	pass
	
func add_wolf_bite():
	#Te transforma en hombre lobo cuando solo nos queda 1 de vida
	# + velocidad + daño
	pass
	
func add_brain():
	#Siendo zombies, nos da recuperacion automatica hasta 2 corazones
	pass
	
func add_poison():
	Global.poison = true
	
func add_electric():
	Global.electric = true
	
func add_ice():
	Global.frozen = true
	
func add_speed(count):
	Global.speed += count
	
func add_shoot_speed(count):
	Global.shoot_speed_total -= count
	
func add_melee(count):
	Global.melee_rate_total -= count
	
func add_luck(count):
	Global.bad_luck -= count
	
func add_damage(count):
	Global.attack += count
	
func hit(dmg, can_zombie:=false):
	if inv_time <= 0:
		$sprite.animation = "hit" + ani_aditional
		inv_time = inv_time_total
		hit_ttl = hit_ttl_total
		inv_togg = 0
		
		for i in range(Global.health.size()-1, -1, -1):
			if dmg > 0:
				if Global.health[i] == 1:
					dmg -= 1
					Global.health[i] = 0
				elif Global.health[i] == 2:
					Global.health.remove(i)
					dmg -= 1
				elif Global.health[i] == 3:
					Global.health.remove(i)
					dmg -= 1
				elif Global.health[i] == 4:
					Global.health.remove(i)
					dmg -= 1
		
		Global.combo_time = 0
		Global.current_combo = 0
		
		if can_zombie:
			if eval_dead():
				turn_into_zombie_ttl = turn_into_zombie_ttl_total
		
		if Global.temp_poison:
			Global.temp_poison = eval_poision()
		
		Global.refresh_hud()
		
func turn_into_zombie(original:=true):
	if original:
		Global.health = [0, 0]
		for i in range(Global.health.size()):
			Global.health[i] = 4
		
	dead = false
	Global.GAME_OVER = false
	Global.zombie = true
	ani_aditional = "_zombie"
	$sprite.animation = $sprite.animation + ani_aditional
	Global.refresh_hud()
	
func die():
	$sprite.animation = "dead" + ani_aditional
	dead = true
	Global.GAME_OVER = true
	
func eval_poision():
	for h in Global.health:
		if h == 3:
			return true 
	return false
	
func eval_dead():
	for h in Global.health:
		if h != 0:
			return false 
	return true
	
func entering():
	entering = true
	Global.LOGIC_PAUSE = true
	$sprite.material.set_shader_param("blackened", true)
	$sprite.animation = "back" + ani_aditional
	
func get_random_enemy():
	var _chase = get_tree().get_nodes_in_group("enemies")
	var direction = null
	if _chase.size() > 0:
		randomize()
		_chase.shuffle()
		direction = (_chase[0].global_position - self.global_position).normalized()
		normalize_direction = 3
		$automatic_weapon.look_at(_chase[0].global_position)
		return direction
	else:
		return null
	
func get_random_dir():
	return Global.pick_random([
		Vector2(0, 1), 
		Vector2(0, -1),
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 0),
		Vector2(-1, 1),
		Vector2(-1, -1)
		])
		
func create_bullet_nodir(_dir):
	if _dir != null:
		var bullet = PlayerBullet.instance()
		bullet.type = Global.automatic_weapon

		var root = get_node("/root/Main")
		root.add_child(bullet)
		bullet.global_position = global_position

func create_bullet(_dir):
	if _dir != null:
		var bullet = PlayerBullet.instance()
		bullet.type = Global.automatic_weapon
		bullet.dir = _dir
		var root = get_node("/root/Main")
		root.add_child(bullet)
		bullet.global_position = global_position
	
func shoot():
	if Global.automatic_weapon == "plasma":
		create_bullet(Vector2(0, 1))
		create_bullet(Vector2(0, -1))
		
		create_bullet(Vector2(1, 0))
		create_bullet(Vector2(1, 1))
		create_bullet(Vector2(1, -1))
		
		create_bullet(Vector2(-1, 0))
		create_bullet(Vector2(-1, 1))
		create_bullet(Vector2(-1, -1))
	else:
		if Global.automatic_weapon == "shot_gun":
			var dir = get_random_enemy()
			create_bullet(dir)
		elif Global.automatic_weapon == "knife":
			create_bullet_nodir(get_random_enemy())
		elif Global.automatic_weapon == "bomb":
			create_bullet(get_random_dir())
		elif Global.automatic_weapon == "tomahawk":
			var xx = 0.2 * $sprite.scale.x
			create_bullet(Vector2(xx, -1))

func _physics_process(delta):
	if $automatic_weapon.visible:
		if normalize_direction > 0:
			normalize_direction -= 1 * delta
		else:
			$automatic_weapon.rotation = lerp_angle($automatic_weapon.rotation, 0, 0.2)
	
	if entering:
		$automatic_weapon.visible = false
		$melee_bar.visible = false
		$melee_bar2.visible = false
		$sprite.playing = true
		if $sprite.position.y <= 10:
			$sprite.position.y -= 8 * delta
			$shadow.position.y -= 8 * delta
			
	if dead:
		if turn_into_zombie_ttl != 0:
			turn_into_zombie_ttl -= 1 * delta
			if turn_into_zombie_ttl <= 0:
				turn_into_zombie()
		else:
			$automatic_weapon.visible = false
			$melee_bar.visible = false
			$melee_bar2.visible = false
		return
	
	if hit_ttl > 0:
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			if eval_dead():
				die()
	
	if inv_time > 0:
		inv_togg += 1 * delta
		if inv_togg >= inv_togg_total:
			inv_togg = 0
			$sprite.visible = !$sprite.visible
		
		inv_time -= 1 * delta
		if inv_time <= 0:
			inv_time = 0
			$sprite.animation = "default" + ani_aditional
			$sprite.visible = true
	
	if Global.LOGIC_PAUSE:
		return 
	
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var down = Input.is_action_pressed("down")
	var up = Input.is_action_pressed("up")
	var action1 = Input.is_action_pressed("action1")
	var action2 = Input.is_action_pressed("action2")
	
	if Global.melee_rate > 0:
		$melee_bar.visible = true
		$melee_bar2.visible = true
		$melee_progress.play("default")
		Global.melee_rate -= 1 * delta
		Global.melee_rate = max(0, Global.melee_rate)
	else:
		$melee_bar.visible = false
		$melee_bar2.visible = false
	
	var move = (left or right or up or down)
	
	movement = Vector2.ZERO
	
	if Global.automatic_weapon != "":
		Global.shoot_speed -= 1 * delta
		if Global.shoot_speed <= 0:
			Global.shoot_speed = Global.shoot_speed_total
			shoot()
	
	if action2:
		pass
	
	if action1 and Global.melee_rate <= 0:
		if !is_instance_valid(whip_inst):
			Global.melee_rate = Global.melee_rate_total
			var mouse_pos = get_global_mouse_position()
			var angle = get_angle_to(mouse_pos)
			var _z = z_index
			if $sprite.animation == "back" + ani_aditional:
				_z = z_index - 10
			
			whip_inst = whip.instance()
			add_child(whip_inst)
			whip_inst.z_index = _z
			whip_inst.set_position(Vector2(0,0))
			whip_inst.rotation = angle
			
	if left:
		movement.x = -Global.speed
		$sprite.scale.x = -1
	elif right:
		movement.x = Global.speed
		$sprite.scale.x = 1
		
	if down:
		movement.y = Global.speed
	elif up:
		movement.y = -Global.speed
		
	movement = move_and_slide(movement, Vector2.UP)
	
	z_index = global_position.y + 16
	
	if move and inv_time <= 0:
		if up:
			$sprite.animation = "back" + ani_aditional
		else:
			$sprite.animation = "default" + ani_aditional
	
	$sprite.playing = move
	if !move:
		$sprite.frame = 0
