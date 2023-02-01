extends KinematicBody2D
var poisoned = 0
var poisoned_ttl = 0
var freeze_ttl = 0
var movement = Vector2.ZERO
var pixelated = 100
var firstframe = true
var hit_ttl = 0
var hit_ttl_total = 0.2
var inv_time = 0
var inv_time_total = 1.2
var inv_togg_total = 0.1
var inv_togg = 0
var primary_inst = null
var Blast = preload("res://scenes/Blast.tscn")
var whip = preload("res://scenes/Whip.tscn")
var katana = preload("res://scenes/Katana.tscn")
var PlayerBullet = preload("res://scenes/PlayerBullet.tscn")
var particle = preload("res://scenes/particle2.tscn")
var BulletGroup = preload("res://scenes/BulletGroup.tscn")
var ani_aditional = ""
var turn_into_zombie_ttl = 0
var turn_into_zombie_ttl_total = 1.3
var normalize_direction = 0
var explosive_item_ttl = 0
var rolling_ttl = 0
var dashing_ttl = 0
var rolling_cool_down = 0
var dashing_cool_down = 0
var auto_move_angle = null
var facing = 1
var falling = false
var safe_pos = []
var _in_water = false
var dash_pos = []
onready var default_pos = $sprite.get_position() - Vector2(0, 10)
var amplitude = 5.0
var frequency = 2.0
var time = 0
var bulletonetimecreated = false
var back = false
var restzoom = false

var dead = false
var entering = false

func restore_zoom():
	restzoom = true

func camera_zoom(x, y):
	$Camera2D.zoom.x = x
	$Camera2D.zoom.y = y

func _ready():
	Global.pixelate(pixelated)
	
	add_to_group("players")
	if Global.automatic_weapon != "empty":
		$automatic_weapon.animation = Global.automatic_weapon
		$automatic_weapon.visible = true
	else:
		$automatic_weapon.visible = false
		
	if Global.zombie:
		turn_into_zombie(false)
		
	if Global.life2win:
		Global.attack = get_life_for_attack()
		
func add_idol_mask(play_sound:=true):
	if play_sound:
		Global.play_sound(Global.ItemSfx)
	Global.has_idol_mask = true
		
func add_justice():
	Global.play_sound(Global.ItemSfx)
	Global.has_justice = true
		
func add_cherry():
	Global.play_sound(Global.ItemSfx)
	
	Global.add_extra_display("gems", Global.gems)
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("gems")
	
	Global.gems *= 2
	Global.cherry = true
	
func add_gem_now(count):
	if count > 0:
		Global.play_sound(Global.GemSfx)	
	if count > 0:
		if Global.cherry:
			count *= 2
			
	Global.gems += count
			
func add_gem(count):
	if count > 0:
		Global.play_sound(Global.GemSfx)
		
	Global.add_extra_display("gems", count)
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("gems")
	
	if count > 0:
		if Global.cherry:
			count *= 2
			
	Global.gems += count
	
func add_key(count):
	Global.play_sound(Global.KeySfx)
	
	Global.add_extra_display("keys", count)
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("keys")
	
	Global.keys += count
	
func add_master_key():
	Global.play_sound(Global.MasterKeySfx)
	Global.masterkey = true
	
func add_magnet():
	Global.play_sound(Global.ItemSfx)
	Global.magnet = true
	
func add_heart(count, play_sound:=true):
	if play_sound:
		Global.play_sound(Global.LifeSfx)
		
	for i in range(Global.health.size()):
		if Global.health[i] == 0 and count > 0:
			Global.health[i] = 1
			count -= 1
			if count <= 0:
				break
	
	if Global.werewolf:
		turn_into_no_werewolf()
		
	if Global.life2win:
		Global.attack = get_life_for_attack()
	
	Global.refresh_hud()
	
func add_total_hearts(count, play_sound:=true):
	if play_sound:
		Global.play_sound(Global.LifeSfx)
	while(count > 0):
		for i in range(Global.health.size()-1, -1, -1):
			if count > 0:
				if Global.health[i] == 1 or Global.health[i] == 0:
					Global.health.insert(i + 1, 0)
					count -= 1
					
			if count > 0:
				for e in range(count):
					Global.health.push_front(0)
					
				count = 0
		
	Global.refresh_hud()
	
func add_shield(count, play_sound:=true):
	if play_sound:
		Global.play_sound(Global.LifeSfx)
		
	for i in range(count):
		Global.health.push_back(2)
		
	if Global.werewolf:
		turn_into_no_werewolf()
		
	if Global.life2win:
		Global.attack = get_life_for_attack()
	
	Global.refresh_hud()
	
func add_shield_poision(count):
	Global.play_sound(Global.LifeSfx)
	for i in range(count):
		Global.health.push_back(3)
	
	Global.temp_poison = true
	
	if Global.werewolf:
		turn_into_no_werewolf()
		
	if Global.life2win:
		Global.attack = get_life_for_attack()
	
	Global.refresh_hud()
	
func add_automatic_weapon(weapon):
	Global.play_sound(Global.WeaponSfx)
	Global.automatic_weapon = weapon
	
func add_secondary_weapon(weapon):
	Global.play_sound(Global.WeaponSfx)
	Global.secondary_weapon = weapon
	
func add_primary_weapon(weapon):
	Global.play_sound(Global.WeaponSfx)
	Global.primary_weapon = weapon
	
func add_life_2_win():
	Global.play_sound(Global.ItemSfx)
	Global.attack = Global.health.size()
	Global.life2win = true
	if Global.life2win:
		Global.attack = get_life_for_attack()
	
func add_pay_2_win(original:=false):
	if original:
		Global.play_sound(Global.ItemSfx)
	Global.attack = Global.gems
	if Global.attack > Global.attack_max:
		Global.attack = Global.attack_max
	
	Global.pay2win = true
	
func add_wolf_bite():
	Global.play_sound(Global.ItemSfx)
	Global.werewolf = true
	
func add_brain(original:=true):
	if original:
		Global.got_brain = true
		Global.play_sound(Global.ItemSfx)
		
	if Global.zombie:
		Global.health = [4, 4, 4, 4]
	
func add_poison():
	Global.play_sound(Global.ItemSfx)
	Global.poison = true
	
func add_balloon():
	Global.play_sound(Global.ItemSfx)
	Global.has_balloon = true
	
func add_electric():
	Global.play_sound(Global.ItemSfx)
	Global.electric = true
	
func add_ice():
	Global.play_sound(Global.ItemSfx)
	Global.frozen = true
	
func add_speed(count, play_sound:=true):
	var mult = 50.0
	if play_sound:
		Global.play_sound(Global.ItemSfx)
	
	Global.add_extra_display("speed", (count * mult/ 100.0))
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("speed")
	
	Global.speed += (count * mult)
	if Global.speed < 0:
		Global.speed = 0
	
func add_shoot_speed(count, play_sound:=true):
	if play_sound:
		Global.play_sound(Global.ItemSfx)
		
	Global.add_extra_display("shoot_speed", count)
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("shoot_speed")
	
	Global.shoot_speed_speed += count

func add_melee(count, play_sound:=true):
	if play_sound:
		Global.play_sound(Global.ItemSfx)
		
	Global.add_extra_display("melee_speed", count)
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("melee_speed")
	Global.melee_speed += count
	
func add_luck(count, play_sound:=true):
	if play_sound:
		Global.play_sound(Global.ItemSfx)
		
	Global.add_extra_display("luck", count)
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("luck")
	Global.bad_luck -= count
	
func add_damage(count, play_sound:=true):
	if play_sound:
		Global.play_sound(Global.ItemSfx)
		
	Global.add_extra_display("attack", count)
	yield(get_tree().create_timer(.5), "timeout") 
	Global.hide_hud_extras("attack")
	
	Global.attack += count
	if Global.attack < 0:
		Global.attack = 0.1
		
func add_pin():
	Global.play_sound(Global.ItemSfx)
	Global.has_bleed= true
		
func add_fly():
	Global.play_sound(Global.ItemSfx)
	Global.flying = true
	
func in_water():
	_in_water = true
	
func out_water():
	_in_water = false

func do_justice():
	var dests = get_tree().get_nodes_in_group("enemy_objects")
	for d in dests:
		d.hit(null, 0.5, "justice_fx")
	
func hit(dmg, from, can_zombie:=false, effect_name:=""):
	if !entering and inv_time <= 0 and rolling_ttl <= 0:
		Global.play_sound(Global.PlayerHurt)
		
		if effect_name == "poison":
			Global.play_sound(Global.PoisonSfx)
			poisoned = 1
		
		if effect_name == "ice":
			Global.play_sound(Global.FrozeSfx)
			freeze_ttl = 2.5
			
		if effect_name == "":
			if Global.has_justice:
				do_justice()
		
		Global.shaker_obj.shake(2, 0.2)
		
		if typeof(from) in [TYPE_ARRAY]:
			Global.KillerisMe = from[0]
			Global.KillerisMeExtra = from[1]
		else:
			Global.KillerisMe = from
			Global.KillerisMeExtra = ""
		
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
			
		if Global.werewolf and !Global.zombie:
			turn_into_werewolf()
			
		if Global.life2win:
			Global.attack = get_life_for_attack()
		
		Global.refresh_hud()
		
		
func get_life_for_attack():
	var count = 0
	for i in range(Global.health.size()):
		if Global.health[i] != 0:
			count += 1
			
	return count
		
func last_life():
	var count = 0
	for i in range(Global.health.size()):
		if Global.health[i] != 0:
			count += 1
			
	return (count <= 1)
		
func turn_into_werewolf():
	if last_life():
		if ani_aditional != "_werewolf":
			Global.play_sound(Global.WereWolfSfx)
			ani_aditional = "_werewolf"
			$sprite.animation = $sprite.animation + ani_aditional
			Global.speed += Global.werewolf_speed
			Global.attack += Global.werewolf_attack
	
func turn_into_no_werewolf():
	if ani_aditional == "_werewolf" and !last_life():
		Global.play_sound(Global.WereWolfSfx)
		ani_aditional = ""
		$sprite.animation = $sprite.animation.replace("_werewolf", "")
		Global.speed -= Global.werewolf_speed
		Global.attack -= Global.werewolf_attack
	
func one_live():
	Global.health = [1]
	Global.refresh_hud()
		
func turn_into_zombie(original:=true):
	Global.zombie = true
	if original:
		Global.play_sound(Global.ZombieSfx)
		Global.health = [4, 4]
		if Global.got_brain:
			add_brain(false)
		
	dead = false
	Global.GAME_OVER = false
	ani_aditional = "_zombie"
	$sprite.animation = $sprite.animation + ani_aditional
	Global.refresh_hud()
	
func die():
	Global.play_sound(Global.PlayerDieSfx)
	$sprite.animation = "dead" + ani_aditional
	dead = true
	Global.GAME_OVER = true
	Global.shaker_obj.shake(3, 0.2)
	
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
	if !Global.flying:
		Global.play_sound(Global.PlayerEnteringSfx)
		
	entering = true
	Global.LOGIC_PAUSE = true
	$sprite.material.set_shader_param("blackened", true)
	$sprite.animation = "back" + ani_aditional
	$masks.material.set_shader_param("blackened", true)
	
func get_random_enemy():
	var _chase = get_tree().get_nodes_in_group("enemy_objects")
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
	if Global.automatic_weapon == "power_glove":
		var bullet = PlayerBullet.instance()
		bullet.type = Global.automatic_weapon
		bullet.dir = _dir
		bullet.position = $automatic_weapon.position
		add_child(bullet)
	elif Global.automatic_weapon == "spikeball":
		var bullet = BulletGroup.instance()
		add_child(bullet)
		bullet.global_position = global_position
	elif _dir != null:
		var bullet = PlayerBullet.instance()
		bullet.type = Global.automatic_weapon
		bullet.dir = _dir
		var root = get_node("/root/Main")
		root.add_child(bullet)
		bullet.global_position = global_position
	
func shoot():
	if !bulletonetimecreated and Global.automatic_weapon == "spikeball":
		Global.play_sound(Global.SpikeBallSfx)
		bulletonetimecreated = true
		create_bullet(null)
		
	if !bulletonetimecreated and Global.automatic_weapon == "power_glove":
		Global.play_sound(Global.PlasmaSfx)
		bulletonetimecreated = true
		create_bullet(null)
		
	if Global.automatic_weapon == "spells_book":
		Global.play_sound(Global.PlasmaSfx)
		var _chase = get_tree().get_nodes_in_group("enemy_objects")
		var direction = null
		for c in _chase:
			direction = (c.global_position - self.global_position).normalized()
			create_bullet(direction)
		
		if direction:
			emit()
	
	if Global.automatic_weapon == "plasma":
		Global.play_sound(Global.PlasmaSfx)
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
			if (dir):
				Global.play_sound(Global.ShotGunSfx)
			create_bullet(dir)
		elif Global.automatic_weapon == "knife":
			var dir = get_random_enemy()
			if (dir):
				Global.play_sound(Global.KnifeSfx)
			create_bullet_nodir(dir)
		elif Global.automatic_weapon == "bomb":
			Global.play_sound(Global.BombSxf)
			create_bullet(get_random_dir())
		elif Global.automatic_weapon == "tomahawk":
			Global.play_sound(Global.TomaHawkSfx)
			var xx = 0.2 * $sprite.scale.x
			create_bullet(Vector2(xx, -1))
			
func fall():
	if !falling:
		Global.play_sound(Global.FallingSfx)
		falling = true
		$sprite.scale.x = 1
		$sprite.scale.y = 1
		$shadow.visible = false
		$sprite.animation = "hit" + ani_aditional
			
func stop_fall():
	if falling:
		falling = false
		$shadow.visible = true
		$sprite.animation = "default" + ani_aditional
		$sprite.scale.x = 1
		$sprite.scale.y = 1
		$sprite.rotation = 0
		position = safe_pos[safe_pos.size() - 3]
		safe_pos = []
		out_water()
		hit(1, "hole", false)
	
func emit():
	for i in range(2):
		var p = particle.instance()
		var root = get_node("/root/Main")
		root.add_child(p)
		p.global_position = global_position
	
func _draw():
	if dashing_ttl > 0:
		var texture = $sprite.get_sprite_frames().get_frame($sprite.animation,$sprite.get_frame())
		for p in dash_pos:
			draw_texture(texture, to_local(p), Color(1, 1, 1, 0.3))
			
func blast():
	emit()
	emit()
	emit()
	Global.play_sound(Global.BombExplosionSfx)
	explosive_item_ttl = 2.3
	var b = Blast.instance()
	var root = get_node("/root/Main")
	root.add_child(b)
	b.global_position = global_position
	b.no_player_hit = true
			
func melee_attack():
	var _z = z_index
	if Global.primary_weapon == "whip":
		var mouse_pos = get_global_mouse_position()
		var angle = get_angle_to(mouse_pos)
		if $sprite.animation == "back" + ani_aditional:
			_z = z_index - 10
		primary_inst = whip.instance()
		add_child(primary_inst)
		primary_inst.z_index = _z
		primary_inst.set_position(Vector2(0,0))
		primary_inst.rotation = angle
	elif Global.primary_weapon == "katana":
		primary_inst = katana.instance()
		add_child(primary_inst)
		primary_inst.set_position(Vector2(0, 0))
		primary_inst.scale.x = facing
			
func _physics_process(delta):
#	if Input.is_action_just_pressed("debug_button1"):
#		add_melee(0.1)

	if restzoom:
		if $Camera2D.zoom.x <= 1:
			$Camera2D.zoom.x += 1 * delta
			$Camera2D.zoom.y = $Camera2D.zoom.x
			if $Camera2D.zoom.x >= 1:
				$Camera2D.zoom.x = 1
				$Camera2D.zoom.y = 1
	
	if !entering and pixelated > 1:
		pixelated -= 200 * delta
		if pixelated <= 1:
			pixelated = 1
		Global.pixelate(pixelated)
		if pixelated == 1:
			Global.set_visible_transition(false)
	
	if falling:
		$sprite.rotation += 5 * delta
		$sprite.scale.x -= 2 * delta
		$sprite.scale.y = $sprite.scale.x
		if $sprite.scale.x <= 0:
			stop_fall()
			
		return
	
	safe_pos.append(position)
	
	if Global.has_idol_mask:
		add_idol_mask(false)
	
	if Global.werewolf:
		turn_into_werewolf()
		
	if Global.pay2win:
		add_pay_2_win()
		
	if firstframe:
		firstframe = false
		back = true
		$sprite.animation = "back" + ani_aditional
	
	if $automatic_weapon.visible:
		if Global.automatic_weapon == "power_glove":
			var mouse_pos = get_global_mouse_position()
			var angle = get_angle_to(mouse_pos)
			$automatic_weapon.rotation = angle

		else:
			if normalize_direction > 0:
				normalize_direction -= 1 * delta
			else:
				$automatic_weapon.rotation = lerp_angle($automatic_weapon.rotation, 0, 0.2)
		
	if entering:
		$automatic_weapon.visible = false
		if !Global.flying:
			$sprite.playing = true
			
		if $sprite.position.y <= 10:
			$sprite.position.y -= 8 * delta
			$shadow.position.y -= 8 * delta
			
	if dead:
		$sprite.set_position(Vector2(0, 0))
		
		if turn_into_zombie_ttl != 0:
			turn_into_zombie_ttl -= 1 * delta
			if turn_into_zombie_ttl <= 0:
				turn_into_zombie()
		else:
			$automatic_weapon.visible = false
		return
		
	if poisoned > 0:
		$sprite.modulate = Global.poisoned_color
		if randi() % 100 + 1 == 100:
			if !entering and inv_time <= 0:
				poisoned -= 1
				emit()
				hit(1, "poison_fx", false, "")
				if poisoned <= 0:
					$sprite.modulate = Color8(255, 255, 255)
					poisoned = 0
		
	if freeze_ttl > 0:
		freeze_ttl -= 1 * delta
		Global.LOGIC_PAUSE = true
		$sprite.modulate = Global.froze_color
		if freeze_ttl <= 0:
			$sprite.modulate = Color8(255, 255, 255)
			Global.LOGIC_PAUSE = false
		
	if rolling_cool_down > 0:
		rolling_cool_down -= 1 * delta
		
	if dashing_cool_down > 0:
		dashing_cool_down -= 1 * delta
				
	if dashing_ttl > 0:
		dash_pos.append(Vector2(position.x -16, position.y - 16))
		dashing_ttl -= 1 * delta
		update()
		if dashing_ttl <= 0:
			dash_pos = []
			dashing_cool_down = 0.3
			dashing_ttl = 0
			auto_move_angle = null
		
	if explosive_item_ttl > 0:
		explosive_item_ttl -= 1 * delta
		if explosive_item_ttl <= 0:
			explosive_item_ttl = 0 
		
	if rolling_ttl > 0:
		rolling_ttl -= 1 * delta
		$sprite.animation = "roll" + ani_aditional
		$sprite.rotation += (15 * $sprite.scale.x) * delta
		if randi() % 20 == 0:
			emit()
		if rolling_ttl <= 0:
			$sprite.animation = "default"
			$sprite.rotation = 0
			rolling_cool_down = 0.3
			rolling_ttl = 0
			auto_move_angle = null
	
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
		if !entering:
			$sprite.playing = false
		return 
	
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var down = Input.is_action_pressed("down")
	var up = Input.is_action_pressed("up")
	var action1 = Input.is_action_pressed("action1")
	var action2 = Input.is_action_pressed("action2")
	
	if Global.melee_rate > 0:
		Global.melee_rate -= Global.melee_speed * delta
		Global.melee_rate = max(0, Global.melee_rate)
	
	var move = (left or right or up or down)
	
	movement = Vector2.ZERO
	
	if Global.automatic_weapon != "":
		if !bulletonetimecreated:
			Global.shoot_speed -= Global.shoot_speed_speed * delta
			if Global.shoot_speed <= 0:
				Global.shoot_speed = Global.shoot_speed_total
				shoot()
	
	if action2:
		if explosive_item_ttl <= 0 and Global.secondary_weapon == "explosive_item":
			blast()
		
		if dashing_ttl <= 0 and dashing_cool_down <= 0 and Global.secondary_weapon == "dash":
			dashing_ttl = Global.dashing_ttl
			var mouse_pos = get_global_mouse_position()
			if mouse_pos.x > position.x:
				$sprite.scale.x = 1
			else:
				$sprite.scale.x = -1
			auto_move_angle = global_position.direction_to(mouse_pos) * Global.dash_speed
			
		if rolling_ttl <= 0 and rolling_cool_down <= 0 and Global.secondary_weapon == "roll":
			rolling_ttl = Global.rolling_ttl
			var mouse_pos = get_global_mouse_position()
			if mouse_pos.x > position.x:
				$sprite.scale.x = 1
			else:
				$sprite.scale.x = -1
			auto_move_angle = global_position.direction_to(mouse_pos) * Global.roll_speed
	
	if auto_move_angle == null and action1 and Global.melee_rate <= 0:
		if !is_instance_valid(primary_inst):
			Global.melee_rate = Global.melee_rate_total
			melee_attack()
			
	if left:
		movement.x = -Global.speed
		$sprite.scale.x = -1
		back = false
	elif right:
		movement.x = Global.speed
		$sprite.scale.x = 1
		back = false
		
	facing = $sprite.scale.x
		
	if down:
		movement.y = Global.speed
		back = false
	elif up:
		movement.y = -Global.speed
		back = true
		
	if Global.has_idol_mask:
		$masks.visible = true
		if back:
			$masks.animation = "idol_mask_back"
			$masks.z_index = $sprite.z_index - 1
		else:
			$masks.animation = "idol_mask"
			$masks.z_index = $sprite.z_index + 1
		
	if _in_water:
		movement.y += Global.water_speed
		
	if auto_move_angle:
		movement = move_and_slide(auto_move_angle)
	else:
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

	if Global.flying:
		$sprite.playing = false
		time += delta * frequency
		$sprite.set_position(default_pos + Vector2(0, sin(time) * amplitude))
