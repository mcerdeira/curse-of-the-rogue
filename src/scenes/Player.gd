extends KinematicBody2D
var movement = Vector2.ZERO
var health = 3
var speed = 150
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
var primary_wheapon = "Whip"
var secondary_wheapon = ""
var impulse = null
var dead = false

func _ready():
	add_to_group("players")
	
func hit(dmg, origin):
	if inv_time <= 0:
		$sprite.animation = "hit"
		impulse = (origin.position - self.position).normalized()
		inv_time = inv_time_total
		hit_ttl = hit_ttl_total
		inv_togg = 0
		health -= dmg
	
func die():
	$sprite.animation = "dead"
	dead = true
	
func _physics_process(delta):
	Global.primary_wheapon = primary_wheapon
	Global.attack_rate = melee_rate_total
	Global.attack = attack
	Global.speed = speed
	Global.health = health
	
	if dead:
		return
	
	if hit_ttl > 0:		
		hit_ttl -= 1 * delta
		if hit_ttl <= 0:
			impulse = null
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
		
	if impulse:
		move_and_slide((-speed*2) * impulse)
	else:
		movement = move_and_slide(movement, Vector2.UP)
	
	if move and inv_time <= 0:
		if up:
			$sprite.animation = "back"
		else:
			$sprite.animation = "default"
	
	$sprite.playing = move
	if !move:
		$sprite.frame = 0
