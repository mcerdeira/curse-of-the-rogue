extends KinematicBody2D
var movement = Vector2.ZERO
var shield = 0
var health_total = 3
var health = health_total
var speed = 150
var bad_luck = 100.00
var melee_rate_total = 1
var melee_rate = 0
var attack = 1
var hit_ttl = 0
var hit_ttl_total = 0.2
var inv_time = 0
var inv_time_total = 1.2
var inv_togg_total = 0.1
var inv_togg = 0
var whip_inst = null
var whip = preload("res://scenes/Whip.tscn")
var primary_weapon = "Whip"
var secondary_weapon = "Empty"
var dead = false
var entering = false

func _ready():
	add_to_group("players")
	
func add_gem(count):
	Global.gems += count
	
func hit(dmg, origin:=null):
	if inv_time <= 0:
		$sprite.animation = "hit"
		inv_time = inv_time_total
		hit_ttl = hit_ttl_total
		inv_togg = 0
		if shield >= dmg:
			shield -= dmg
			dmg = 0
		elif shield < dmg and shield != 0:
			shield = 0
			dmg -= shield
		
		Global.combo_time = 0
		Global.current_combo = 0
		
		health -= dmg
		var HUD = get_node("../CanvasLayer/HUD")
		HUD.update_health()
	
func die():
	$sprite.animation = "dead"
	dead = true
	Global.GAME_OVER = true
	
func entering():
	entering = true
	Global.LOGIC_PAUSE = true
	$sprite.material.set_shader_param("blackened", true)
	$sprite.animation = "back"

func _physics_process(delta):
	Global.primary_weapon = primary_weapon
	Global.secondary_weapon = secondary_weapon
	Global.attack_rate = melee_rate_total
	Global.attack = attack
	Global.speed = speed
	Global.health = health
	Global.shield = shield
	Global.health_total = health_total
	Global.bad_luck = bad_luck
	
	if entering:
		$sprite.playing = true
		if $sprite.position.y <= 10:
			$sprite.position.y -= 8 * delta
			$shadow.position.y -= 8 * delta
	
	if dead:
		return
	
	if hit_ttl > 0:
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			if health <= 0:
				die()
	
	if inv_time > 0:
		inv_togg += 1 * delta
		if inv_togg >= inv_togg_total:
			inv_togg = 0
			$sprite.visible = !$sprite.visible
		
		inv_time -= 1 * delta
		if inv_time <= 0:
			inv_time = 0
			$sprite.animation = "default"
			$sprite.visible = true
	
	if Global.LOGIC_PAUSE:
		return 
	
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var down = Input.is_action_pressed("down")
	var up = Input.is_action_pressed("up")
	var action1 = Input.is_action_pressed("action1")
	var action2 = Input.is_action_pressed("action2")
	
	if melee_rate > 0:
		$melee_bar.visible = true
		$melee_bar2.visible = true
		$melee_progress.play("default")
		melee_rate -= 1 * delta
		melee_rate = max(0, melee_rate)
	else:
		$melee_bar.visible = false
		$melee_bar2.visible = false
	
	var move = (left or right or up or down)
	
	movement = Vector2.ZERO
	
	if action2:
		pass
	
	if action1 and melee_rate <= 0:
		if !is_instance_valid(whip_inst):
			melee_rate = melee_rate_total
			var mouse_pos = get_global_mouse_position()
			var angle = get_angle_to(mouse_pos)
			var _z = z_index
			if $sprite.animation == "back":
				_z = z_index - 10
			
			whip_inst = whip.instance()
			add_child(whip_inst)
			whip_inst.z_index = _z
			whip_inst.set_position(Vector2(0,0))
			whip_inst.rotation = angle
			
	if left:
		movement.x = -speed
		$sprite.scale.x = -1
	elif right:
		movement.x = speed
		$sprite.scale.x = 1
		
	if down:
		movement.y = speed
	elif up:
		movement.y = -speed
		
	movement = move_and_slide(movement, Vector2.UP)
	
	z_index = position.y
	
	if move and inv_time <= 0:
		if up:
			$sprite.animation = "back"
		else:
			$sprite.animation = "default"
	
	$sprite.playing = move
	if !move:
		$sprite.frame = 0
