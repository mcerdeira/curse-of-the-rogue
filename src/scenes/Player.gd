extends KinematicBody2D
var movement = Vector2.ZERO
var hit_ttl = 0
var hit_ttl_total = 0.2
var inv_time = 0
var inv_time_total = 1.2
var inv_togg_total = 0.1
var inv_togg = 0
var zombie_first_dead = false
var whip_inst = null
var whip = preload("res://scenes/Whip.tscn")
var ani_aditional = ""

var dead = false
var entering = false

func _ready():
	add_to_group("players")
	
func add_gem(count):
	Global.gems += count
	
func add_heart(count):
	for i in range(Global.health):
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
	
func add_poison():
	Global.poison = true
	
func add_speed(count):
	Global.speed += count
	
func add_melee(count):
	Global.melee_rate_total = 0
	
func add_luck(count):
	Global.bad_luck -= count
	
func add_damage(count):
	Global.attack += count
	
func hit(dmg, can_zombie:=false):
	if inv_time <= 0:
		$sprite.animation = "hit"
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
				turn_into_zombie()
		
		if Global.temp_poison:
			Global.temp_poison = eval_poision()
		
		Global.refresh_hud()
		
func turn_into_zombie():
	for i in range(Global.health):
		if Global.health[i] == 0:
			Global.health[i] = 4
	
	zombie_first_dead = true
	Global.zombie = true
	ani_aditional = "_zombie"
	
func die():
	if zombie_first_dead:
		zombie_first_dead = false
	else:
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

func _physics_process(delta):
	if entering:
		$sprite.playing = true
		if $sprite.position.y <= 10:
			$sprite.position.y -= 8 * delta
			$shadow.position.y -= 8 * delta
	
	if dead:
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
	
	z_index = position.y
	
	if move and inv_time <= 0:
		if up:
			$sprite.animation = "back" + ani_aditional
		else:
			$sprite.animation = "default" + ani_aditional
	
	$sprite.playing = move
	if !move:
		$sprite.frame = 0
