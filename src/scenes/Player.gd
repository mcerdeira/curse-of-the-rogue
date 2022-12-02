extends KinematicBody2D
var movement = Vector2.ZERO
var health = 3
var speed = 150
var melee_rate_total = 1
var melee_rate = 0
var attack = 1
var whip_inst = null
var whip = preload("res://scenes/Whip.tscn")
var primary_wheapon = "Whip"
var secondary_wheapon = ""

func _ready():
	add_to_group("players")

func _physics_process(delta):
	Global.primary_wheapon = primary_wheapon
	Global.attack_rate = melee_rate_total
	Global.attack = attack
	Global.speed = speed
	Global.health = health
	
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
	
	movement = move_and_slide(movement, Vector2.UP)
	
	if move:
		if up:
			$sprite.animation = "back"
		else:
			$sprite.animation = "default"
	
	$sprite.playing = move
	if !move:
		$sprite.frame = 0
